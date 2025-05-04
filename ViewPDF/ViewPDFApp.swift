//
//  ViewPDFApp.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseMessaging

@main
struct ViewPDFApp: App {
    let persistenceController = PersistenceController.shared
	
	@UIApplicationDelegateAdaptor(Appdelegate.self) var appDelegate
	
	init() {
		FirebaseApp.configure()
	}

	var body: some Scene {
		WindowGroup {
			SplashView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
	}
}

class Appdelegate: NSObject, UIApplicationDelegate {
	var notificationManager = NotificationManager()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		
		Messaging.messaging().delegate = self
		notificationManager.requestNotificationPermissions()
		
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		print("APNs device token received")
		Messaging.messaging().apnsToken = deviceToken
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
		print("Received notification: \(userInfo)")
		
		return .newData
	}
}

extension Appdelegate: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		print("FCM Token: \(fcmToken ?? "")")
	}
	
}
