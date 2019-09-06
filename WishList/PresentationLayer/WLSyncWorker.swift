
//
//  File.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit
import AddressBook

var contactFound = false

class WLSyncWorker: WLModel, UIAlertViewDelegate {
    
    fileprivate var dataContactIDs : NSMutableArray?
    fileprivate var contactIndex : Int = 0
    fileprivate var addressBookRef : ABAddressBook?
    
    func getAccessToAddressBookWithSuccess(_ successCallback: @escaping SuccessCallback, errorCallback: ErrorCallback)
    {
        
        let status = ABAddressBookGetAuthorizationStatus()
        if status == .denied || status == .restricted {
            // user previously denied, to tell them to fix that in settings
            
            errorCallback((), NSError(domain: "", code: 0, userInfo: nil))
            WLThreading.main({ () -> Void in
                
                let alertView = UIAlertView(title: "No Contact Access", message:"To fully utilize Who@, you need to grant Who@ access to your contacts. To allow access, go to Settings -> Privacy -> Contacts -> allow access to Who@", delegate: nil, cancelButtonTitle: "ok")
                alertView.alertViewStyle = .default
                alertView.show()
            })
            
            return
        }
        
        var error: Unmanaged<CFError>?
        addressBookRef = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue()
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            granted, error in
            if !granted {
                // warn the user that because they just denied permission, this functionality won't work
                // also let them know that they have to fix this in settings
                
                WLThreading.main({ () -> Void in
                    
                    let alertView = UIAlertView(title: "No Contact Access", message:"To fully utilize Who@, you need to grant Who@ access to your contacts. To allow access, go to Settings -> Privacy -> Contacts -> allow access to Who@", delegate: nil, cancelButtonTitle: "ok")
                    alertView.alertViewStyle = .default
                    alertView.show()
                })
                
                return
            }
            if (ABAddressBookCopyArrayOfAllPeople(self.addressBookRef)?.takeRetainedValue()) != nil {
                // now do something with the array of people
                successCallback((), true as AnyObject)
            }
        }
    }
    func setupContacts(_ contacts: NSArray , isFullSync : Bool){
        self.contactIndex = 0
        self.dataContactIDs = NSMutableArray()
        
        for i in 0 ..< contacts.count
        {
            if let record: ABRecord = contacts[i] as ABRecord
            {
                _ = ABRecordCopyValue(record, kABPersonModificationDateProperty)
                let recordId = ABRecordGetRecordID(record)
                self.dataContactIDs?.add(NSNumber(value: recordId as Int32))
            }
        }
    }
    
    func startSyncWithSuccess(_ successCallback: @escaping SuccessCallback, progressCallBack: @escaping ProgressCallback, errorCallback: @escaping ErrorCallback)
    {
        WLThreading.background { () -> Void in
            
            self.getAccessToAddressBookWithSuccess({ (Void1, Any) -> Void in
                
                let contacts = self.getArrayOfAddressbookRecords()
                if contacts!.count > 0
                {
                    //isFullSync  need to implement
                    self.setupContacts(contacts!, isFullSync: true)
                }else{
                    
                    WLThreading.main({ () -> Void in
                        
                        let alertView = UIAlertView(title: "No Contacts", message:"There weren't any contacts to be synced", delegate: nil, cancelButtonTitle: "ok")
                        alertView.alertViewStyle = .default
                        alertView.tag = 2
                        alertView.delegate = self
                        alertView.show()
                        errorCallback((), NSError(domain: "There weren't any contacts to be synced", code: 0, userInfo: nil))
                        return
                    })
                }
                
                if self.dataContactIDs?.count == 0 {
                    let alertView = UIAlertView(title: "Success", message:"No contacts have been modified or created since you last synced", delegate: nil, cancelButtonTitle: "ok")
                    alertView.alertViewStyle = .default
                    alertView.show()
                    
                    successCallback((), true as AnyObject)
                    return
                }
                
                if self.dataContactIDs != nil {
                    
                    
                    var progressStep =  Int(self.dataContactIDs!.count / 100)
                    progressStep = progressStep == 0 ? 1 : progressStep
                    
                    let data = self.getcontactsWithProgress({ (Void1, _: (total: Int, progress: Int)) -> Void in
                        
                        if (self.contactIndex % progressStep == 0)
                        {
                            //                        var prog = CGFloat(self.contactIndex) / CGFloat(self.dataContactIDs.count * 0.9)
                            progressCallBack((), (self.dataContactIDs!.count ,(self.contactIndex*99/self.dataContactIDs!.count)))
                        }
                    })
                    
                    self.syncContacts(data!, successCallback: { (Void1, Any) -> Void in
                        
                        WLThreading.main({ () -> Void in
                            
                            //                        let alertView = UIAlertView(title: "Success", message:"Your contacts have been uploaded. We'll send you an email when we're done processing the contacts.", delegate: nil, cancelButtonTitle: "ok")
                            //                        alertView.alertViewStyle = .Default
                            //                        alertView.show()
                        })
                        
                        successCallback((), true as AnyObject)
                        
                        }, errorCallback: { (Void1, NSError1) -> Void in
                            WLThreading.main({ () -> Void in
                                
                                let alertView = UIAlertView(title: "", message:"Failed to sync contacts please try again.", delegate: nil, cancelButtonTitle: "ok")
                                alertView.alertViewStyle = .default
                                alertView.show()
                                errorCallback((), NSError1)
                            })
                    })
                }
                
                }, errorCallback: { (Void1, NSError) -> Void in
                    
                    WLThreading.main({ () -> Void in
                        
                        let alertView = UIAlertView(title: "Failed to sync contacts", message:"WLSyncWorker startSyncWithSuccess", delegate: nil, cancelButtonTitle: "ok")
                        alertView.alertViewStyle = .default
                        
                        alertView.show()
                    })
                    
            })
        }
    }
    
    func syncContacts( _ data : NSArray, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.syncContact);
        task.addArg("contacts", value: data);
//        let  strToken = WLUserSettings.getAuthToken()!
        
        let device = UIDevice()
        task.addArg("devicename", value: device.name as AnyObject)
        let uuid = UIDevice.current.uniqueDeviceIdentifier()
        task.addArg("udid", value: uuid as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
    
    
    fileprivate func getcontactsWithProgress(_ progressCallBack :ProgressCallback)-> NSMutableArray?
    {
        let contacts = NSMutableArray()
        let idCount : Int = self.dataContactIDs!.count
        while(self.contactIndex < idCount)
        {
            let dict = getNextContact()
            if dict != nil {
                contacts.add(dict!)
            }
            progressCallBack((), (self.dataContactIDs!.count ,self.contactIndex))
        }
        
        return contacts
    }
    
    
    fileprivate func getNextContact()-> NSMutableDictionary?
    {
        let record  : ABRecord = self.dataContactIDs![self.contactIndex] as ABRecord
        let contactid = self.dataContactIDs![self.contactIndex] as! NSNumber
        let ref: ABRecord! = ABAddressBookGetPersonWithRecordID(addressBookRef!, contactid.int32Value).takeUnretainedValue() as ABRecord!
        self.contactIndex += 1
        let contact : WLContact = WLContact().initWithAddressBookRecord(ref)
        return contact.serialize()
    }
    
    fileprivate func getArrayOfAddressbookRecords()->NSArray?
    {
        let contacts: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue()
        return contacts
    }
}
