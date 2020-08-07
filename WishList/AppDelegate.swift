//
//  AppDelegate.swift
//  WishList
//
//  Created by Harendra Singh on 04/01/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel
import Firebase
import FirebaseAuth
import TwitterKit

var rechability = Reachability()
var unicDeviceToken = ""
var requestIDGlobal = ""

var AvailableServer = [["Server":"Development","HostUrl":"https://wishlist.operislabs.com","selected":false],
                       ["Server":"Production","HostUrl":"https://wishlist.whoat.net","selected":true]]

var SELECTED_HOST = "selected_host"
var AVAILABLE_HOST = "available_host"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
                TWTRTwitter.sharedInstance().start(withConsumerKey:"Boj81rH5ziLhYet5O49T6cCDo", consumerSecret:"WOnJynlDi4VRvOdsUT6JRezIIs4Fb0qOWM1N3eGIBbdWKUWETZ")
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
        Mixpanel.sharedInstance(withToken: "202bb88d85a0c957fee6da5215b88b84")
        setupMixpanel()
        
        for i in 3..<100{
            let dic = ["Server":"Dev \(i)","HostUrl":"https://niceleads-staging-pr-\(i).herokuapp.com","selected":false] as [String : Any]
            AvailableServer.append(dic)
        }
        
        let userDefauld = UserDefaults.standard
        let selectedHost = userDefauld.value(forKey: AVAILABLE_HOST)
        if selectedHost == nil{
            userDefauld.set(AvailableServer, forKey: AVAILABLE_HOST)
            AvailableServer.forEach { (server) in
                let isSelected = server["selected"] as! Bool
                
                if isSelected{
                    userDefauld.set(server, forKey: SELECTED_HOST)
                }
            }
        }
        
        // Bugsee.launch(withToken: "921c5204-60a9-430b-98d2-1b8b11b2ab4d")
        if let payload = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
            
            if let _ = WLUserSettings.getAuthToken() {
                
                if let requestid = payload["requestid"] as? Int {
                    
                    requestIDGlobal = "\(requestid)"
                }
            }
        }
        FirebaseApp.configure()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.host == "page" {
            
            if url.path == "/main" {
                
                let myAlert = UIAlertView()
                myAlert.title = "Title"
                myAlert.message = "My message"
                myAlert.addButton(withTitle: "Ok")
                myAlert.delegate = self
                myAlert.show()
            }
            
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func setupMixpanel() {
        
        let mixPanel = Mixpanel.sharedInstance(withToken: "202bb88d85a0c957fee6da5215b88b84")
        
        if WLUserSettings.getEmail() != nil {
            
            print(WLUserSettings.getEmail()!)
            mixPanel.identify(WLUserSettings.getEmail()!)
        }
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
        guard let url = dynamicLink.url  else {
            print("Deep link url has not object")
            return
        }
        var email = ""
        print("your incoming param is: \(url.absoluteString)")
        if url.absoluteString.contains("accept"){
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let components = components {

                if let queryItems = components.queryItems {
                    for queryItem in queryItems {
                        if queryItem.name == "requestId" {
                            email = queryItem.value ?? ""
                        }
                        //                        print("\(queryItem.name): \(queryItem.value)")
                    }
                }
            }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "incomming") as? IncomingRequestDetailViewController
//            nextVC?.selectedRequestID = 1
            let nav = UINavigationController(rootViewController: nextVC!)
            nav.isNavigationBarHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
//        else if url.absoluteString.contains("reset"){
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let resetPasswd = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController
//
//            let nav = UINavigationController(rootViewController: resetPasswd!)
//            nav.isNavigationBarHidden = true
//            self.window?.rootViewController = nav
//            self.window?.makeKeyAndVisible()
//        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL{
            print("incoming url is \(incomingURL)")
            
            let linkHandler = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else{
                    print("Found error! \(error?.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink{
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandler{
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Mixpanel.sharedInstance()?.track("App Entered In Background", properties:nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard WLUserSettings.getAuthToken() != nil else { return }
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "UpdateCounterForAppForeground"), object: nil)
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "UpdateCounterForAppForegroundForNotification"), object: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        Mixpanel.sharedInstance()?.track("App Killed", properties:nil)
        self.saveContext()
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //send this device token to server
        
        let characterSet: CharacterSet = CharacterSet(charactersIn: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .trimmingCharacters( in: characterSet )
            .replacingOccurrences( of: " ", with: "" ) as String
        print(deviceTokenString)
        unicDeviceToken =  deviceTokenString
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let _ = WLUserSettings.getAuthToken() {
            
            var infoDict = [String : AnyObject]()
            // show your banner
            
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? String {
                    infoDict["alert"] = alert as AnyObject
                }
            }
            
            if let requestid = userInfo["requestid"] as? Int {
                
                requestIDGlobal = "\(requestid)"
            }
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "NotificationIdentifier"), object: infoDict)
            
        }
        
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.kofax.WishList" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "WishList", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

