//
//  AppDelegate.swift
//  TPDLinePay_Example
//
//  Created by 高嘉琦 on 2017/12/29.
//  Copyright © 2017年 Cherri Tech Inc. All rights reserved.
//

import UIKit
import TPDirect
import AdSupport
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        TPDSetup.setWithAppId(13769, withAppKey: "app_K3EfgihFOC6eNqsoB028X0ezFYaZTr58uBlJ7YFofNG8oFixETKuYVSeBvST", with: TPDServerType.sandBox)
        
        TPDSetup.shareInstance().setupIDFA(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        
        TPDSetup.shareInstance().serverSync()
        
        TPDLinePay.addExceptionObserver(#selector(tappayLinePayExceptionHandler(notification:)))
        
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // For version higher than iOS 9.0
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Check Url from TapPay and parse URL data.
        let tapPayHandled = TPDLinePay.handle(url)
        if (tapPayHandled) {
            return true
        }
        
        return false
    }
    // For version lower than iOS 9.0
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Check Url from TapPay and parse URL data.
        let tapPayHandled = TPDLinePay.handle(url)
        if (tapPayHandled) {
            return true
        }
        
        return false
    }
    //When exception happened receive notification.
    @objc func tappayLinePayExceptionHandler(notification: Notification) {
        
        let result : TPDLinePayResult = TPDLinePay.parseURL(notification)
        
        print("status : \(result.status) , orderNumber : \(result.orderNumber) , recTradeid : \(result.recTradeId) , bankTransactionId : \(result.bankTransactionId) ")
        
    }
    
}

