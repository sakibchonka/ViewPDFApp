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
		if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
			print("📁 Core Data SQLite file is located at:\n\(storeURL.path)")
		}

	}
	
	//MARK: User Entity
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
	
	//MARK: Product Entity
	func saveProduct(_ product: Product) throws {
		// Validation
		guard !product.id.isEmpty, !product.name.isEmpty else {
			throw NSError(domain: "Validation", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid product data"])
		}
		
		let entity = ProductEntity(context: context)
		entity.id = product.id
		entity.name = product.name
		entity.data = product.data as? NSObject
		
		try context.save()
	}
	
	func fetchAllProducts() throws -> [ProductEntity] {
		let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
		return try context.fetch(request)
	}
	
	func updateProduct(id: String, newName: String) throws {
		let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %@", id)
		
		if let product = try context.fetch(request).first {
			product.name = newName
			try context.save()
		} else {
			throw NSError(domain: "NotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
		}
	}
	
	func deleteProduct(id: String) throws {
		let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %@", id)
		
		if let product = try context.fetch(request).first {
			context.delete(product)
			try context.save()
		} else {
			throw NSError(domain: "NotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
		}
	}
}


//usage
//let apiService = APIService()
//let coreDataHelper = CoreDataHelper()
//
//apiService.fetchProducts { result in
//	switch result {
//	case .success(let products):
//		for product in products {
//			do {
//				try coreDataHelper.saveProduct(product)
//			} catch {
//				print("Save failed for \(product.id): \(error)")
//			}
//		}
//	case .failure(let error):
//		print("API error: \(error)")
//	}
//}
