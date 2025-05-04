//
//  PDFNotificationManager.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 04/05/25.
//

import Foundation
import UserNotifications
import FirebaseMessaging
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
	
	// Request Notification Permissions
	func requestNotificationPermissions() {
		// Set the delegate for UNUserNotificationCenter
		UNUserNotificationCenter.current().delegate = self
		
		// Request authorization for notifications
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				DispatchQueue.main.async {
					// Register for remote notifications if permissions are granted
					UIApplication.shared.registerForRemoteNotifications()
				}
			} else if let error = error {
				print("Error requesting notification permissions: \(error.localizedDescription)")
			}
		}
	}

//	// Optional: Handle foreground notifications (if needed)
//	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//		completionHandler([.alert, .badge, .sound])
//	}
//
	// Handle notification registration success/failure
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		// Pass the device token to Firebase
		Messaging.messaging().apnsToken = deviceToken
	}
//
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register for notifications: \(error.localizedDescription)")
	}
}

