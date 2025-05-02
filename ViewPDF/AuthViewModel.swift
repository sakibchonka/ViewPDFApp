//
//  AuthViewModel.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

//import Foundation
import Combine
import CoreData
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
//import GoogleSignInSwift

class AuthViewModel: ObservableObject {
	@Published var user: User?
	@Published var isSignedIn = false
	private var cancellables = Set<AnyCancellable>()
	
	init() {
		user = Auth.auth().currentUser
		if let currentUser = user {
			// TODO: this is called in every second launch and even for same user.
			saveUserToCoreData(user: currentUser)
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
	
	func saveUserToCoreData(user: User) {
		let context = PersistenceController.shared.container.viewContext
		
		let entity = UserEntity(context: context)
		entity.uid = user.uid
		entity.email = user.email
		entity.displayName = user.displayName
		entity.photoURL = user.photoURL?.absoluteString
		
		do {
			try context.save()
			print("user saved to core data")
		} catch {
			print("failed to save user: \(error)")
		}
	}
	
	func fetchSavedUser() -> UserEntity? {
		let context = PersistenceController.shared.container.viewContext
		let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
		
		do {
			let users = try context.fetch(fetchRequest)
			return users.first
		} catch {
			print("failed to fetch user: \(error)")
			return nil
		}
	}
}
