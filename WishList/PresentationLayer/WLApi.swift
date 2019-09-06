//
//  WLApi.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLApi: NSObject {
    
    let manager = AFHTTPRequestOperationManager()
    
    func login(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let loginUrl = WLAppSettings.loginurl(args)

        print(loginUrl)
        manager.post(loginUrl, parameters: prepareObjects1(args), success: { (operation, responseObject) in
            
            if let _ = responseObject as? Dictionary<String, AnyObject> {
                successCallback((), responseObject as AnyObject)
            }
        }, failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
            
            print(error)
            errorCallback((), error as NSError)
            
        })
    }
    
    func register(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let registerUrl = WLAppSettings.registerurl(args)
        
        print(registerUrl)
        print(prepareObjects(args))
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        manager.post(registerUrl,
            parameters: prepareObjects1(args),
            success: { (operation ,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                //print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func profile(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let profileUrl = WLAppSettings.addProfileURL(args)
        
        print(profileUrl)
        print(prepareObjects(args))
        print(WLUserSettings.getAuthToken())
        
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        print(profileUrl)
        
        var profileImage: UIImage?
        var imageData: Data?
        print(prepareObjects(args))
        
        let possibleOldImagePath = UserDefaults.standard.object(forKey: "path") as? String
        
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = self.documentsPathForFileName(oldImagePath)
            let oldImageData = try? Data(contentsOf: URL(fileURLWithPath: oldFullPath))
            profileImage = UIImage(data: oldImageData!)
            imageData = profileImage!.jpegData(compressionQuality: 1)
            
        }
        
        let op : AFHTTPRequestOperation = manager.post(profileUrl, parameters: prepareObjects(args), constructingBodyWith: { (formData: AFMultipartFormData!) -> Void in
            
            //print(imageData)
            if imageData != nil {
                formData.appendPart(withFileData: imageData!, name: "image", fileName: "profilepicture.jpg", mimeType: "image/jpeg")
                
            }
            },
            success:
            {
                (operation, responseObject) in
                
                //print(responseObject, terminator: "")
                
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    
                    successCallback((), responseObject as AnyObject)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                //print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })!
        
        
        op.start()
        
    }
    
    func getProfile(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let profileURL = WLAppSettings.profileurl(args)
        
        print(profileURL)
        guard let token = WLUserSettings.getAuthToken() else {return}
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        
        manager.get(profileURL,
            parameters: nil,
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    
    func checkEmailStatus(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let checkEmailStatusURL = WLAppSettings.checkEmailStatusURL(args)
        
        print(checkEmailStatusURL)
        print("Token \(WLUserSettings.getAuthToken()!)")
        
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(checkEmailStatusURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func resendEmailVerification(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let resendEmailVerificationURL = WLAppSettings.resendEmailVerificationURL(args)
        
        print(resendEmailVerificationURL)
        print("Token \(WLUserSettings.getAuthToken()!)")
        
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(resendEmailVerificationURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func companyList(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let companyListURL = WLAppSettings.companyList(args)
        print(WLAppSettings.companyList(args))
        print(companyListURL)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(companyListURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }

    func contactGroupOrganizer(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let contactGroupOrganizerURL = WLAppSettings.contactGroupOrganizerURL(args)
        print(WLAppSettings.contactGroupOrganizerURL(args))
        print(contactGroupOrganizerURL)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(contactGroupOrganizerURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func getWishListForUser(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let getWishListURLForUser = WLAppSettings.getMyWishList(args)
        print(WLAppSettings.companyList(args))
        print(getWishListURLForUser)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getWishListURLForUser,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        //                //print(responseObject)
                        //                //print("JSON: " + responseObject.description)
                        //TGUserSettings
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func getCompaniesForSelectedGroups(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let getCompaniesForSelectedGroupsURL = WLAppSettings.getCompaniesForSelectedGroupsURL(args)
        print(getCompaniesForSelectedGroupsURL)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getCompaniesForSelectedGroupsURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func getMemberList(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let getMemberListURL = WLAppSettings.getMemberList(args)
        print(getMemberListURL)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getMemberListURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        //                //print(responseObject)
                        //                //print("JSON: " + responseObject.description)
                        //TGUserSettings
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }

    func getGroupMemberList(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let getGroupMemberListURL = WLAppSettings.getGroupMemberListURL(args)
        print(getGroupMemberListURL)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getGroupMemberListURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        //                //print(responseObject)
                        //                //print("JSON: " + responseObject.description)
                        //TGUserSettings
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func getSelectedCompaniesGroupMember(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let getSelectedCompaniesGroupMemberURL = WLAppSettings.getSelectedCompaniesGroupMemberURL(args)
        print(getSelectedCompaniesGroupMemberURL)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getSelectedCompaniesGroupMemberURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func getGroupListForUser(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let getGroupListURL = WLAppSettings.getGroupList(args)
        print(getGroupListURL)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getGroupListURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func getTheirWishListForUser(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let getTheirMemberListURL = WLAppSettings.getTheirMemberList(args)
        print(getTheirMemberListURL)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getTheirMemberListURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        //                //print(responseObject)
                        //                //print("JSON: " + responseObject.description)
                        //TGUserSettings
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func loadMoreCompanyList(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let loadMoreCompanyListURL = WLAppSettings.LoadMoreCompanyListURL(args)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(loadMoreCompanyListURL,
            parameters: nil,
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func prepareObjects(_ dict : Dictionary<String, Any> ) -> [String: String] {
        
        var dictParameters = [String: String]()
        for (key, value) in dict {
            dictParameters[key] = "\(value)"
        }
        
        return dictParameters
    }
    
    func documentsPathForFileName(_ name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as NSString
        let fullPath = path.appendingPathComponent(name)
        
        return fullPath
    }
    
    func getInvite(_ args: Dictionary<String, AnyObject>, successCallback: SuccessCallback, errorCallback: ErrorCallback)
    {
//        //let manager = AFHTTPRequestOperationManager();
//        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let inviteUrl = WLAppSettings.inviteUrl(args);
        
//        manager.POST(inviteUrl,
//            parameters: prepareObjects(args),
//            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
//                //print("JSON: " + responseObject.description)
//                //TGUserSettings
//                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
//                    
//                    successCallback((), responseObject as Any)
//                }
//            },
//            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
//                //print("Error: " + error.localizedDescription)
//                errorCallback((), error)
//        })
        
    }
    
    func forgotPassword(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let registerUrl = WLAppSettings.forgotPasswordurl(args)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.post(registerUrl,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
        
    }
    
    func prepareObjects1(_ dict : Dictionary<String, Any> ) -> NSMutableDictionary
    {
        let dictParameters = NSMutableDictionary()
        for (key, value) in dict
        {
            dictParameters.setValue(value as? AnyObject, forKey: key)
        }
        
        return dictParameters
    }
    
    func syncContact(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let syncContactUrl = WLAppSettings.syncContacts(args)
        print(syncContactUrl)
        print(WLUserSettings.getAuthToken())
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        manager.requestSerializer.timeoutInterval = 40000
        print(prepareObjects1(args))
        manager.post(syncContactUrl,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func registerWithFB(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let registerWithFBURL = WLAppSettings.registerWithFBURL(args)
        
        print(registerWithFBURL)
      
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(prepareObjects(args))
        
        manager.post(registerWithFBURL,
                     parameters: prepareObjects(args),
                     success: { (operation,responseObject) in
                        //print(responseObject)
                        print("JSON: " , responseObject.debugDescription)
                        //TGUserSettings
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                     failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        
                        print("Error: " + error.localizedDescription)
                        
                        errorCallback((), error as NSError)
        })
    }
    
    func myBusiness(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        var args = args
        
        let myBusinessURL = WLAppSettings.myBusinessURL(args)
        print(myBusinessURL)
        print(WLUserSettings.getAuthToken()!)
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        
        let forPUT = args["forPUT"] as! Bool
        args.removeValue(forKey: "forPUT")
        
        print(prepareObjects1(args))
        
        if forPUT {
            
            let business_discussion = args["myBusinessDiscussion"] as? String ?? ""
            
            if business_discussion.length > 0 {
                
                manager.put(myBusinessURL,
                    parameters: prepareObjects1(args),
                    success: { (operation,responseObject) in
                        
                        successCallback((), [String: AnyObject]() as AnyObject)
                    },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
                })
            } else {
                
                manager.get(myBusinessURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        
                        //print("JSON: " + responseObject.description)
                        if let _ = responseObject as? Dictionary<String, AnyObject> {
                            successCallback((), responseObject as AnyObject)
                        }
                    },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
                })
            }
        } else {
            
            print(prepareObjects1(args))
            manager.post(myBusinessURL,
                parameters: prepareObjects1(args),
                success: { (operation,responseObject) in
                    
                    successCallback((), [String: AnyObject]() as AnyObject)
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                    print("Error: " + error.localizedDescription)
                    errorCallback((), error as NSError)
            })
        }
    }
    
    func chooseNetwork(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let chooseNetworkURL = WLAppSettings.chooseNetworkURL(args)
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        let fromMoreScreen = args["fromMoreScreen"] as! Bool
        
        if fromMoreScreen {
            
            manager.get(chooseNetworkURL,
                parameters: nil,
                success: { (operation,responseObject) in
                    //print(responseObject)
                    //print("JSON: " + responseObject.description)
                    //TGUserSettings
                    if let _ = responseObject as? Dictionary<String, AnyObject> {
                        successCallback((), responseObject as AnyObject)
                    }
                },
                failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                    print("Error: " + error.localizedDescription)
                    errorCallback((), error as NSError)
            })
            
        } else {
            
            manager.patch(chooseNetworkURL,
                parameters: prepareObjects1(args),
                success: { (operation,responseObject) in
                    //print(responseObject)
                    //print("JSON: " + responseObject.description)
                    //TGUserSettings
                    if let _ = responseObject as? Dictionary<String, AnyObject> {
                        successCallback((), responseObject as AnyObject)
                    }
                },
                failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                    print("Error: " + error.localizedDescription)
                    errorCallback((), error as NSError)
            })
        }
        
        
    }
    
    func selectedCompanies(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let selectedCompaniesURL = WLAppSettings.sendSelectedCompaniesURL(args)
        print(selectedCompaniesURL)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.post(selectedCompaniesURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                
                successCallback((), [String: AnyObject]() as AnyObject)
                //print(responseObject)
                //print("JSON: " + responseObject.description)
//                //TGUserSettings
//                if let _ = responseObject as? Dictionary<String, AnyObject> {
//                    successCallback((), responseObject as Any)
//                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func companyWishList(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let wishListURL = WLAppSettings.companyWishList(args)
        
        print(wishListURL)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(wishListURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func getConnections(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let getConnectionURL = WLAppSettings.getConnectionURL(args)
        
        print(getConnectionURL)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getConnectionURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                } else if let _ = responseObject as? [[String: AnyObject]] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func mutualContacts(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let getMutualConnectionURL = WLAppSettings.getMutualContactURL(args)
        
        print(getMutualConnectionURL)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getMutualConnectionURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [[String: AnyObject]] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func sendRequest(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let sendRequestURL = WLAppSettings.sendRequestURL(args)
        
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        print("Token \(WLUserSettings.getAuthToken()!)")
        print(sendRequestURL)
        print(prepareObjects1(args))
        manager.post(sendRequestURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func getNotifications(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        if WLUserSettings.getAuthToken() != nil {
            
            let getNotificationsURL = WLAppSettings.getNotificationsURL(args)
            print(getNotificationsURL)
            
            //let manager = AFHTTPRequestOperationManager();
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
            
            manager.get(getNotificationsURL,
                        parameters: prepareObjects1(args),
                        success: { (operation,responseObject) in
                            //print(responseObject)
                            //print("JSON: " + responseObject.description)
                            //TGUserSettings
                            if let _ = responseObject as? [String: AnyObject] {
                                successCallback((), responseObject as AnyObject)
                            }
                },
                        failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                            print("Error: " + error.localizedDescription)
                            errorCallback((), error as NSError)
            })
        }
    }
    
    func getInboundDetail(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let getNotificationsURL = WLAppSettings.getInboundDetailURL(args)
        print(getNotificationsURL)
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        print(prepareObjects1(args))
        manager.post(getNotificationsURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func getTerms(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let getTermsURL = WLAppSettings.getTermsURL(args)
        print(getTermsURL)
        //let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        manager.get(getTermsURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func notificationAction(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let notificationActionURL = WLAppSettings.notificationActionURL(args)
        //let manager = AFHTTPRequestOperationManager();
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        print(notificationActionURL)
        print(prepareObjects1(args))
        
        manager.post(notificationActionURL,
            parameters: prepareObjects1(args),
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func searchCompany(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let searchCompanyURL = WLAppSettings.searchCompanyURL(args).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(searchCompanyURL)
        print("Token \(WLUserSettings.getAuthToken()!)")
        
        for operation in manager.operationQueue.operations {
            
            operation.cancel()
        }
        manager.operationQueue.cancelAllOperations()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(searchCompanyURL,
            parameters: nil,
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }

    func searchCompanyForGroup(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let searchCompaniesForGroup = WLAppSettings.searchCompaniesForGroup(args).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(searchCompaniesForGroup)
        print("Token \(WLUserSettings.getAuthToken()!)")
        
        for operation in manager.operationQueue.operations {
            
            operation.cancel()
        }
        manager.operationQueue.cancelAllOperations()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(searchCompaniesForGroup,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        //print(responseObject)
                        //print("JSON: " + responseObject.description)
                        //TGUserSettings
                        if let _ = responseObject as? [String: AnyObject] {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func loadMoreCompanyFeed(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let loadMoreCompanyFeedURL = WLAppSettings.loadMoreCompanyFeed(args)
        print(loadMoreCompanyFeedURL)
        print("Token \(WLUserSettings.getAuthToken()!)")
        //let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(loadMoreCompanyFeedURL,
            parameters: nil,
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func searchCompanyOfIntrust(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let searchCompanyOfIntrustURL = WLAppSettings.searchCompanyOfIntrustURL(args).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(searchCompanyOfIntrustURL)
        print("Token \(WLUserSettings.getAuthToken()!)")
        
        for operation in manager.operationQueue.operations {
            
            operation.cancel()
        }
        manager.operationQueue.cancelAllOperations()
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(searchCompanyOfIntrustURL,
            parameters: nil,
            success: { (operation,responseObject) in
//                //print(responseObject)
//                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func theirProfile(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let theirProfileURL = WLAppSettings.theirProfileURL(args).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(theirProfileURL)
        print("Token \(WLUserSettings.getAuthToken()!)")
        //let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(theirProfileURL,
            parameters: nil,
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func updateProfile(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let profileurl = WLAppSettings.profileurl(args)
        //let manager = AFHTTPRequestOperationManager()
        
        print(WLUserSettings.getAuthToken())
        print(profileurl)
        print(prepareObjects(args))
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        var profileImage: UIImage?
        var imageData: Data?
        print(prepareObjects(args))
        let possibleOldImagePath = UserDefaults.standard.object(forKey: "path1") as? String
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = self.documentsPathForFileName(oldImagePath)
            let oldImageData = try? Data(contentsOf: URL(fileURLWithPath: oldFullPath))
            profileImage = UIImage(data: oldImageData!)
            imageData = profileImage!.jpegData(compressionQuality: 1)
            
        }

        let op : AFHTTPRequestOperation = manager.post(profileurl, parameters: prepareObjects(args), constructingBodyWith: { (formData: AFMultipartFormData!) -> Void in
            
            if imageData != nil {
                formData.appendPart(withFileData: imageData!, name: "image", fileName: "profilepicture.jpg", mimeType: "image/jpeg")
            }
            },
            success:
            {
                (operation, responseObject) in
                //print(responseObject, terminator: "")
                //TGUserSettings
                if let _ = responseObject as? Dictionary<String, AnyObject> {
                    
                    successCallback((), responseObject as AnyObject)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })!
        op.start()
    }
    
    func checkHandle(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let checkHandleURL = WLAppSettings.checkHandleURL(args).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print(checkHandleURL)
        
        print("Token \(WLUserSettings.getAuthToken()!)")
        //let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(checkHandleURL,
            parameters: nil,
            success: { (operation,responseObject) in
                //print(responseObject)
                //print("JSON: " + responseObject.description)
                //TGUserSettings
                if let _ = responseObject as? [String: AnyObject] {
                    successCallback((), responseObject as AnyObject)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                print("Error: " + error.localizedDescription)
                errorCallback((), error as NSError)
        })
    }
    
    func getMutualForNotificationDetail(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let getMutualContactForNotificationDetail = WLAppSettings.getMutualContactForNotificationDetailURL(args)
        print(getMutualContactForNotificationDetail)
        print("Token \(WLUserSettings.getAuthToken()!)")
        //let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getMutualContactForNotificationDetail,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        //print(responseObject)
                        //print("JSON: " + responseObject.description)
                        //TGUserSettings
                        if let _ = responseObject as? [String: AnyObject] {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
    
    func searchConnection(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback){
        
        let getSearchConnectionURL = WLAppSettings.getSearchConnectionURL(args).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(getSearchConnectionURL)
        print("Token \(WLUserSettings.getAuthToken()!)")
        //let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Token \(WLUserSettings.getAuthToken()!)", forHTTPHeaderField: "Authorization")
        
        manager.get(getSearchConnectionURL,
                    parameters: nil,
                    success: { (operation,responseObject) in
                        //print(responseObject)
                        //print("JSON: " + responseObject.description)
                        //TGUserSettings
                        if let _ = responseObject as? [String: AnyObject] {
                            successCallback((), responseObject as AnyObject)
                        }
            },
                    failure: { (operation: AFHTTPRequestOperation!,error: Error!) in
                        //print("Error: " + error.localizedDescription)
                        errorCallback((), error as NSError)
        })
    }
}

