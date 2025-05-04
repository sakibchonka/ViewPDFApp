//
//  LoginView.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
	@StateObject private var authVM = AuthViewModel()
	@State private var presentingVC: UIViewController?
	@StateObject private var notificationManager = NotificationManager()
	
	var body: some View {
		Group {
			if authVM.isSignedIn {
				
				MainView()
				
			} else {
				
				VStack(spacing: 20) {
					Text("Welcome to View PDF")
						.font(.title)
						.fontWeight(.bold)
						.fontDesign(.serif)
						.padding()
					
					Rectangle().fill(Color.clear).frame(height: 20)

					
					Text("Sign in with Google")
						.font(.title2)
						.foregroundStyle(.primary)
						
					
					GoogleSignInButton {
						if let vc = presentingVC {
							authVM.signInWithGoogle(presenting: vc)
						}
					}
					.frame(width: 220, height: 48)
					.shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(ViewPDFConstants.App.appBackgroundColor)
				.background(ViewControllerResolver { vc in
					DispatchQueue.main.async {
						self.presentingVC = vc
					}
				})
			}
		}
		.animation(.easeInOut, value: authVM.isSignedIn)
		.onAppear {
			notificationManager.requestNotificationPermissions()
		}
	}
}


#Preview {
	LoginView()
}

