//
//  AppDelegate.swift
//  Hijinnks
//
//  Created by adeiji on 2/19/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import SendBirdSDK
import Instabug

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager:LocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Instabug.start(withToken: "de5b541611200a4338f5396f7a39150d", invocationEvent: .shake)
        initializeParse(launchOptions: launchOptions)
        initializeGoogleMaps()
        configureGlobalAppearances()
        startLocationServices()
        SBDMain.initWithApplicationId(APIKeys.SendBirdAPIKey.rawValue)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Check if the user is logged in.  If he isn't than show the LoginViewController, otherwise show the ViewInvitationsViewController
        if isLoggedIn() {
            DEUserManager.sharedManager.setFriends(user: PFUser.current()!)
            
            setupNavigationController()
        } else {
            showLoginView()
        }
        return true
    }
    
    func initializeGoogleMaps () {
        GMSPlacesClient.provideAPIKey("AIzaSyBumgyof-1r1HAiXd6pY6ZUjoj1mQb5Ie4")
        GMSServices.provideAPIKey("AIzaSyCwH5MoYOHPX0P3tfDG26zgUNLQ4LSOAWI")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if FBSDKAccessToken.current() != nil {
            setupNavigationController()
            
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func startLocationServices () {
        locationManager = LocationManager()
        locationManager.startStandardUpdates()
    }
    
    // Setup the views for the entire application.  For ex: UINavigationBar color, UITextField text
    func configureGlobalAppearances () {
        // Set the appearance of the UINavigationBar
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "header.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: UIBarMetrics.defaultPrompt)
        UINavigationBar.appearance().tintColor = Colors.DarkGray.value
//        let searchBarTextAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        let backImg: UIImage = UIImage(named: "left-arrow.png")!
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg, for: .normal, barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(_ : UIOffset.init(horizontal: 0, vertical: -60), for: UIBarMetrics.default)
    }
    
    func initializeParse(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let parseConfiguration = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "com.hijinnks.dephyned"
            ParseMutableClientConfiguration.server = "https://hijinnks.herokuapp.com/parse"
        }
        
        
        Parse.initialize(with: parseConfiguration)
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
    }
    
    func isLoggedIn () -> Bool {
        if PFUser.current() == nil {
            return false
        }
        
        DEUserManager.sharedManager.setupSendBird(userId: (PFUser.current()?.objectId)!)
        return true
    }
    
    func showLoginView () {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let loginViewController = DELoginViewController()
        loginViewController.navigationItem.title = "Hijiinks"
        let navigationController = UINavigationController(rootViewController: loginViewController)
        self.window?.rootViewController = navigationController
    }
    
    func setupNavigationController () {
        // Set up the Application Window and then display our initial screen for viewing invitations
        // DEBUG - For testing purposes we're using CreateInvitationViewController First
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let mainTabBarController = MainTabBarController()
        self.window!.rootViewController = mainTabBarController
    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Hijinnks")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

