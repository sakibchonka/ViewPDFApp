//
//  PDFDownloader.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//
import Foundation

class PDFDownloader: ObservableObject {
	@Published var downloadedURL: URL?
	@Published var errorMessage: String?
	
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
}

