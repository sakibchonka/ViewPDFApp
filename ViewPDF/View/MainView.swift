//
//  MainView.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import SwiftUI

enum Destination: Hashable {
	case pdfViewer(URL)
}

struct MainView: View {
	
	@StateObject private var downloader = PDFDownloader()
	@State private var path: [Destination] = []
	
	var body: some View {
		NavigationStack(path: $path) {
			VStack(spacing: 20) {
				Text("Welcome")
				
				Button("Open PDF") {
					downloader.fetch(from: "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf")
				}

				
				if let error = downloader.errorMessage {
					Text("\(error)").foregroundStyle(.red)
				}
			}
			.padding()
			.navigationDestination(for: Destination.self) { destination in
				switch destination {
				case .pdfViewer(let url):
					
					PDFKitView(url: url)
				}
			}
			.onReceive(downloader.$downloadedURL.compactMap{$0}) { url in
				path.append(.pdfViewer(url))
			}
		}
	}
}
