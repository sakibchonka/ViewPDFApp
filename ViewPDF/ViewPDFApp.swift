//
//  ViewPDFApp.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import SwiftUI

@main
struct ViewPDFApp: App {
    let persistenceController = PersistenceController.shared

	var body: some Scene {
		WindowGroup {
			SplashView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
	}
}
