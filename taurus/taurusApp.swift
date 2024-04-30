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
import FacebookCore
import Adjust

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
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
        
        let yourAppToken = "mses35jw720w"
        let environment = ADJEnvironmentSandbox
        let adjustConfig = ADJConfig(
           appToken: yourAppToken,
           environment: environment)
        Adjust.appDidLaunch(adjustConfig)
        adjustConfig?.logLevel = ADJLogLevelVerbose
        
        
        ConfigService.shared.start()
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
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
    @Environment(\.scenePhase) var scenePhase
    
    func requestDataPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown
                // and we are authorized
                print("Authorized")
                Settings.shared.isAdvertiserTrackingEnabled = true
                Settings.shared.isAutoLogAppEventsEnabled = true
                Settings.shared.isAdvertiserIDCollectionEnabled = true
                // Now that we are authorized we can get the IDFA
                print(ASIdentifierManager.shared().advertisingIdentifier)
                GADMobileAds.sharedInstance().start()
            case .denied:
                // Tracking authorization dialog was
                // shown and permission is denied
                print("Denied")
                Settings.shared.isAdvertiserTrackingEnabled = false
                Settings.shared.isAutoLogAppEventsEnabled = false
                Settings.shared.isAdvertiserIDCollectionEnabled = false
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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { newValue in
                    if newValue == .active {
                        requestDataPermission()
                    }
                }
        }
    }
}
