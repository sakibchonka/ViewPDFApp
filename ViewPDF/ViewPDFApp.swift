//
//  ViewPDFApp.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import SwiftUI
import FirebaseCore

@main
struct ViewPDFApp: App {
    let persistenceController = PersistenceController.shared
	
	init() {
		FirebaseApp.configure()
	}

	var body: some Scene {
		WindowGroup {
			SplashView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
	}
}
