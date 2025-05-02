//
//  PDFRestAPIHelper.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//

import Foundation

class PDFRestAPIHelper {
	private let apiKey = "cc73f6c7-ebac-495a-9279-4d0fc7023036"
	private let url = URL(string: "https://api.pdfrest.com/word")!
	
	func convertPDFToWord(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue(apiKey, forHTTPHeaderField: "Api-Key")
		
		let boundary = UUID().uuidString
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		
		let httpBody = createMultipartBody(fileURL: fileURL, boundary: boundary)
		request.httpBody = httpBody
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data,
				  let responseText = String(data: data, encoding: .utf8) else {
				completion(.failure(NSError(domain: "Invalid response", code: 0)))
				return
			}
			
			completion(.success(responseText))
		}.resume()
	}
	
	private func createMultipartBody(fileURL: URL, boundary: String) -> Data {
		var body = Data()
		let fieldName = "file"
		let filename = fileURL.lastPathComponent
		let mimeType = "application/pdf"
		
		// Opening boundary
		body.append("--\(boundary)\r\n".data(using: .utf8)!)
		body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
		body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
		
		if let fileData = try? Data(contentsOf: fileURL) {
			body.append(fileData)
		}
		
		// Closing boundary
		body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
		return body
	}
}

