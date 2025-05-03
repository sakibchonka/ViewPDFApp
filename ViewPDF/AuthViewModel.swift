//
//  AuthViewModel.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import Combine
import CoreData
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthViewModel: ObservableObject {
	@Published var user: User?
	@Published var isSignedIn = false
	private let coreDataHelper = CoreDataHelper()
	private var cancellables = Set<AnyCancellable>()
	
	init() {
		user = Auth.auth().currentUser
		isSignedIn = user != nil
		if let currentUser = user {
			// TODO: this is called in every second launch and even for same user.
			if coreDataHelper.fetchUser(withUID: currentUser.uid) == nil {
				coreDataHelper.saveUserToCoreData(user: currentUser)
			}
		}
		isSignedIn = user != nil
	}
	
	func signInWithGoogle(presenting: UIViewController) {
		Task {
			do {
				let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)
				guard let idToken = result.user.idToken?.tokenString else { return }
				let accessToken = result.user.accessToken.tokenString
				let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
				
				let authResult = try await Auth.auth().signIn(with: credential)
				
				DispatchQueue.main.async {
					self.user = authResult.user
					self.isSignedIn = true
				}
			} catch {
				print("Google Sign-In Error: \(error.localizedDescription)")
			}
		}
	}
	
	func signOut() {
		do {
			try Auth.auth().signOut()
			GIDSignIn.sharedInstance.signOut()
			self.user = nil
			self.isSignedIn = false
		} catch {
			print("Sign-out error: \(error)")
		}
	}
}
