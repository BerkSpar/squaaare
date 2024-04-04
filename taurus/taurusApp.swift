//
//  taurusApp.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import AppTrackingTransparency
import FirebaseCore
import FirebaseMessaging
import GoogleMobileAds
import AdSupport
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        #if DEBUG
            Analytics.setAnalyticsCollectionEnabled(false)
        #endif
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("Firebase: \(fcm)")
        }
    }
}

@main
struct taurusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    func requestPermissionAndInit() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown
                // and we are authorized
                print("Authorized")
                
                // Now that we are authorized we can get the IDFA
                print(ASIdentifierManager.shared().advertisingIdentifier)
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            case .denied:
                // Tracking authorization dialog was
                // shown and permission is denied
                print("Denied")
            case .notDetermined:
                // Tracking authorization dialog has not been shown
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    init() {
        requestPermissionAndInit()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
