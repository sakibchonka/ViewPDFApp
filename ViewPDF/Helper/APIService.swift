//
//  APIService.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//
import Foundation

class APIService: ObservableObject {
	@Published var downloadedURL: URL?
	@Published var errorMessage: String?
	@Published var products: [Product] = []
	
	func fetch(from urlString: String) {
		guard let remoteURL = URL(string: urlString) else {
			self.errorMessage = "Invalid URL"
			return
		}
		
		let task = URLSession.shared.downloadTask(with: remoteURL) { tempURL, response, error in
			if let error = error {
				DispatchQueue.main.async {
					self.errorMessage = "Download failed: \(error.localizedDescription)"
				}
				return
			}
			
			guard let tempURL = tempURL else {
				DispatchQueue.main.async {
					self.errorMessage = "No file downloaded"
				}
				return
			}
			
			let fileManager = FileManager.default
			let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
			let destURL = docsDir.appendingPathComponent("downloaded.pdf")
			
			try? fileManager.removeItem(at: destURL)
			
			do {
				try fileManager.copyItem(at: tempURL, to: destURL)
				DispatchQueue.main.async {
					self.downloadedURL = destURL
					self.errorMessage = nil
				}
			} catch {
				DispatchQueue.main.async {
					self.errorMessage = "Saving failed \(error.localizedDescription)"
				}
			}
		}
		task.resume()
	}
	
	func fetchProducts(from urlString: String) {
		guard let url = URL(string: urlString) else {
			self.errorMessage = "Invalid product URL"
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, _, error in
			if let error = error {
				DispatchQueue.main.async {
					self.errorMessage = "API error: \(error.localizedDescription)"
				}
				return
			}
			
			guard let data = data else {
				DispatchQueue.main.async {
					self.errorMessage = "No data received"
				}
				return
			}
			
			do {
				let fetchedProducts = try JSONDecoder().decode([Product].self, from: data)
				DispatchQueue.main.async {
					self.products = fetchedProducts
					self.errorMessage = nil
				}
			} catch {
				DispatchQueue.main.async {
					self.errorMessage = "Parsing error: \(error.localizedDescription)"
				}
			}
		}.resume()
	}
}

