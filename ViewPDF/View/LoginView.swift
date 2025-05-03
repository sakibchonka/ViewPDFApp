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
	
	var body: some View {
		Group {
			if authVM.isSignedIn {
//				Text("You are signed in")
//					.font(.headline)
//				Button("Sign out"){
//					authVM.signOut()
//				}
//				.padding()
//				.foregroundStyle(.white)
//				.background(.red)
//				.cornerRadius(8)
				MainView()
			} else {
				VStack(spacing: 20) {
					Text("Sign in with Google")
						.font(.title)
					
					GoogleSignInButton {
						if let vc = presentingVC {
							authVM.signInWithGoogle(presenting: vc)
						}
					}
					.frame(width: 220, height: 48)
				}
				.background(ViewControllerResolver { vc in
					DispatchQueue.main.async {
						self.presentingVC = vc
					}
				})
			}
		}
		.animation(.easeInOut, value: authVM.isSignedIn)
	}
}


#Preview {
	LoginView()
}

