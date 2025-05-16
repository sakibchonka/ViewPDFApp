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
	
	func sendItemDeletedNotification(itemName: String) {
		let content = UNMutableNotificationContent()
		content.title = "Product Deleted"
		content.body = "The product \(itemName) was deleted."
		content.sound = .default
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
		
		let request = UNNotificationRequest(identifier: "ProductDeletedNotification", content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request) { error in
			if let error = error {
				print("Error scheduling local notification: \(error.localizedDescription)")
			}
		}
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .badge, .sound])
	}
}

