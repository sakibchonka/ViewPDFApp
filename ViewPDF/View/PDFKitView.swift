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
		
		viewController.view.addSubview(pdfView)
		
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
