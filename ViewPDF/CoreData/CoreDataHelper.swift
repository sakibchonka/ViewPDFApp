//
//  CoreDataHelper.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//

import CoreData
import FirebaseAuth

class CoreDataHelper {
	private let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
		self.context = context
	}
	
	func saveUserToCoreData(user: User) {
		let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "uid == %@", user.uid)

		do {
			let results = try context.fetch(fetchRequest)
			let entity = results.first ?? UserEntity(context: context)

			entity.uid = user.uid
			entity.email = user.email
			entity.displayName = user.displayName
			entity.photoURL = user.photoURL?.absoluteString

			try context.save()
			print("User saved/updated.")
		} catch {
			print("Error saving user: \(error)")
		}
	}
	
	func fetchUser(withUID uid: String) -> UserEntity? {
		let context = PersistenceController.shared.container.viewContext
		let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
		request.predicate = NSPredicate(format: "uid == %@", uid)

		do {
			return try context.fetch(request).first
		} catch {
			print("Failed to fetch user with uid \(uid): \(error)")
			return nil
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
