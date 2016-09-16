//
//  AppDelegate.swift
//  MyTraveller
//
//  Created by Pardeep Chaudhary on 15/09/16.
//  Copyright © 2016 Pardeep Chaudhary. All rights reserved.
//

import UIKit
import UberRides

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyA0QxYiCbGWmOlePsE1YFnfI1vHQQCsU_U")
        //#define GOOGLE_API_KEY_Server @"AIzaSyA0QxYiCbGWmOlePsE1YFnfI1vHQQCsU_U"
        
        self.setupUber()
        return true
    }
    
    func setupUber(){
        // China based apps should specify the region
        Configuration.setRegion(.Default)
        // If true, all requests will hit the sandbox, useful for testing
        Configuration.setSandboxEnabled(true)
        // If true, Native login will try and fallback to using Authorization Code Grant login (for privileged scopes). Otherwise will redirect to App store
        Configuration.setFallbackEnabled(false)
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        // Handle incoming SSO Requests
//        RidesAppDelegate.sharedInstance.application(application, didFinishLaunchingWithOptions: launchOptions)
//        
//        // Other logic
//        return true
//    }
    /*
    @available(iOS 9, *)
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let handledURL = RidesAppDelegate.sharedInstance.application(app, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        
        if (!handledURL) {
            // Other URL parsing logic
        }
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let handledURL = RidesAppDelegate.sharedInstance.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        if (!handledURL) {
            // Other URL parsing logic
        }
        
        return true
    }
    */
}

