//
//  AppDelegate.swift
//  Physao
//
//  Created by Emmanuel Shiferaw on 10/28/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//

import UIKit
import Parse

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Util.copyFile("UserInfo.sqlite")
        
        Parse.setApplicationId("2FJcyZIv8WlvXCokXRKhUPfKRVH3kl1TLasEW8GE",
            clientKey: "cpJr5DgL3k1lBDbGJCfGG3wA32hTg5elIVvaWYa4")
        
        // notification
        print("start \(__FUNCTION__)")
        NSLog("%@ %@", "\(__FUNCTION__)", "\(launchOptions)")
        
        if let n = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            delay(0.5) {
                self.doAlert(n)
            }
        }
        
        print("end \(__FUNCTION__)")
        
        return true
    }
    
    // will get this registration, no matter whether user sees registration dialog or not
    func application(application: UIApplication, didRegisterUserNotificationSettings settings: UIUserNotificationSettings) {
        print("did register \(settings)")
        // do not change registration here, you'll get a vicious circle
        NSNotificationCenter.defaultCenter().postNotificationName("didRegisterUserNotificationSettings", object: self)
    }
    
    func doAlert(n:UILocalNotification) {
        print("creating alert")
        let inactive = UIApplication.sharedApplication().applicationState == .Inactive
        let s = inactive ? "inactive" : "active"
        let alert = UIAlertController(title: "Hey",
            message: "While \(s), I received a local notification: \(n.alertBody!)",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.window!.rootViewController!.presentViewController(alert,
            animated: true, completion: nil)
    }
    
    // even if user refused to allow alert and sounds etc.,
    // we will receive this call if we are in the foreground when a local notification fires
    func application(application: UIApplication, didReceiveLocalNotification n: UILocalNotification) {
        print("start \(__FUNCTION__)")
        NSLog("%@", "\(__FUNCTION__)")
        self.doAlert(n)
        print("end \(__FUNCTION__)")
    }
    
    
    // new in iOS 9, same as in iOS 8 except that now we have `responseInfo` dictionary coming in
    func application(application: UIApplication, handleActionWithIdentifier id: String?, forLocalNotification n: UILocalNotification, withResponseInfo d: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("start \(__FUNCTION__)")
        NSLog("%@", "\(__FUNCTION__)")
        print("user tapped \(id)")
        if let s = d[UIUserNotificationActionResponseTypedTextKey] as? String {
            print(s)
        }
        // you _must_ call the completion handler to tell the runtime you did this!
        completionHandler()
        print("end \(__FUNCTION__)")
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
        print("start \(__FUNCTION__)")
        print("end \(__FUNCTION__)")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

