//
//  MainView.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import SwiftUI

enum Destination: Hashable {
	case pdfViewer(URL)
	case productList
	case imagePicker
}

struct MainView: View {
	
	@StateObject private var downloader = APIService()
	@StateObject private var authVM = AuthViewModel()
	@State private var path: [Destination] = []
	
	let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
	
	var body: some View {
		if authVM.isSignedIn {
			NavigationStack(path: $path) {
				VStack(spacing: 20) {
					Text("Home Page")
						.font(.largeTitle)
						.fontWeight(.bold)
						.frame(maxWidth: .infinity, alignment: .center)
						.padding(.top)
					
					Spacer()
					
					LazyVGrid(columns: gridItems, spacing: 80) {
						Button("Open PDF") {
							downloader.fetch(from: "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf")
						}
						.frame(width: 120, height: 50)
						.background(Color.blue)
						.foregroundStyle(.white)
						.clipShape(.capsule)
						
						Button("Products") {
							path.append(.productList)
						}
						.frame(width: 120, height: 50)
						.background(Color.green)
						.foregroundStyle(.white)
						.clipShape(.capsule)
						
						Button("Camera") {
							path.append(.imagePicker)
						}
						.frame(width: 120, height: 50)
						.background(Color.orange)
						.foregroundStyle(.white)
						.clipShape(.capsule)
					}
					.padding(.horizontal)
					
					if let error = downloader.errorMessage {
						Text("\(error)").foregroundStyle(.red)
							.multilineTextAlignment(.center)
							.padding(.horizontal)
					}
					
					Spacer()
				}
				.padding()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(ViewPDFConstants.App.appBackgroundColor)
				.navigationDestination(for: Destination.self) { destination in
					switch destination {
					case .pdfViewer(let url):
						PDFKitView(url: url)
					case .imagePicker:
						ImagePickerView()
					case .productList:
						ProductListView()
						
					}
				}
				.onReceive(downloader.$downloadedURL.compactMap{$0}) { url in
					path.append(.pdfViewer(url))
				}
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button("sign out") {
							authVM.signOut()
						}
						
						.buttonBorderShape(.capsule)
						.foregroundStyle(.red)
						.buttonStyle(.bordered)
					}
				}
			}
			
		} else {
			LoginView()
		}
	}
}

#Preview {
	MainView()
}
