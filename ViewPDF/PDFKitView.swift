//
//  PDFKitView.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewControllerRepresentable {
	let url: URL
	let onConvertTapped: (URL) -> Void
	
	func makeUIViewController(context: Context) -> UIViewController {
		let viewController = UIViewController()
		
		//PDF setup
		let pdfView = PDFView(frame: viewController.view.bounds)
		pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		pdfView.autoScales = true
		pdfView.displayMode = .singlePageContinuous
		pdfView.displayDirection = .vertical
		
		if let document = PDFDocument(url: url) {
			pdfView.document = document
		}
		
		//Download button
		let downloadButton = UIButton(type: .system)
		downloadButton.setTitle("Download", for: .normal)
		downloadButton.tintColor = .white
		downloadButton.backgroundColor = .systemGray
		downloadButton.layer.cornerRadius = 8
		downloadButton.isEnabled = false
		downloadButton.translatesAutoresizingMaskIntoConstraints = false
		downloadButton.addTarget(context.coordinator, action: #selector(Coordinator.downloadPDF), for: .touchUpInside)
		
		//Convert button
		let convertButton = UIButton(type: .system)
		convertButton.setTitle("Convert", for: .normal)
		convertButton.tintColor = .white
		convertButton.backgroundColor = .systemBlue
		convertButton.layer.cornerRadius = 8
		convertButton.translatesAutoresizingMaskIntoConstraints = false
		convertButton.addTarget(context.coordinator, action: #selector(Coordinator.convertPDF), for: .touchUpInside)
		
		viewController.view.addSubview(pdfView)
		viewController.view.addSubview(downloadButton)
		viewController.view.addSubview(convertButton)
		
		NSLayoutConstraint.activate([
			downloadButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			downloadButton.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			downloadButton.widthAnchor.constraint(equalToConstant: 100),
			downloadButton.heightAnchor.constraint(equalToConstant: 44),
			
			convertButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			convertButton.trailingAnchor.constraint(equalTo: downloadButton.leadingAnchor, constant: -12),
			convertButton.widthAnchor.constraint(equalToConstant: 100),
			convertButton.heightAnchor.constraint(equalToConstant: 44),
		])
		
		context.coordinator.pdfURL = url
		context.coordinator.onConvertTapped = onConvertTapped
		context.coordinator.downloadButton = downloadButton
		
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator()
	}
}

class Coordinator: NSObject {
	
	var pdfURL: URL?
	var onConvertTapped: ((URL) -> Void)?
	var downloadButton: UIButton?
	
	private var hasConverted = false
	
	@objc func downloadPDF() {
		guard hasConverted else {
			print("🛑 Cannot download before conversion.")
			return
		}
		
		guard let pdfURL = pdfURL else { return }
		
		let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let destinationURL = documentsPath.appendingPathComponent(pdfURL.lastPathComponent)
		
		do {
			let data = try Data(contentsOf: pdfURL)
			try data.write(to: destinationURL)
			print("✅ PDF saved to: \(destinationURL)")
		} catch {
			print("❌ Failed to save PDF: \(error)")
		}
	}
	
	@objc func convertPDF() {
		
		guard let pdfURL = pdfURL else { return }
		
		onConvertTapped?(pdfURL)
		hasConverted = true
		downloadButton?.isEnabled = true
		downloadButton?.backgroundColor = .systemGreen
		
	}
}

