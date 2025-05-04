//
//  ProductListView.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//

import SwiftUI

struct ProductListView: View {
	@State private var products: [ProductEntity] = []
	@State private var name: String = ""
	@State private var id: String = ""
	@State private var errorMessage: String?
	@State private var selectedProduct: ProductEntity?

	let manager = CoreDataHelper()
	@StateObject private var apiService = APIService()

	var body: some View {
		NavigationView {
			VStack(spacing: 16) {
				TextField("Product Name", text: $name)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				

				// MARK: Save & Update Buttons
				HStack {
					Button("Save") {
						do {
							let product = Product(id: id, name: name, data: [:])
							try manager.saveProduct(product)
							clearFields()
							try loadProducts()
						} catch {
							errorMessage = error.localizedDescription
						}
					}

					if let selected = selectedProduct {
						Button("Update") {
							do {
								try manager.updateProduct(id: selected.id ?? "", newName: name)
								clearFields()
								try loadProducts()
							} catch {
								errorMessage = error.localizedDescription
							}
						}
						.foregroundColor(.blue)
					}
				}

				if let message = errorMessage {
					Text(message).foregroundColor(.red)
				}

				// MARK: API Fetched List
				VStack(alignment: .leading) {
					Text("Fetched From API").font(.headline)
					List(apiService.products, id: \.id) { product in
						VStack(alignment: .leading) {
							Text(product.name).font(.subheadline)
							Text("ID: \(product.id)").font(.caption)
							
							if let data = product.data, !data.isEmpty {
								ForEach(data.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
									Text("\(key): \(String(describing: value))")
										.font(.caption2)
										.foregroundColor(.gray)
								}
							}
						}
						.onTapGesture {
							selectedProduct = nil
							id = product.id
							name = product.name
						}
					}
					.frame(height: 200)
				}

				// MARK: Core Data List
				VStack(alignment: .leading) {
					Text("Saved Products").font(.headline)
					List {
						ForEach(products, id: \.self) { product in
							VStack(alignment: .leading) {
								Text(product.name ?? "No Name").font(.headline)
								Text("ID: \(product.id ?? "Unknown")").font(.caption)
							}
							.onTapGesture {
								selectedProduct = product
								id = product.id ?? ""
								name = product.name ?? ""
							}
						}
						.onDelete(perform: delete)
					}
				}
			}
			.padding()
			.navigationTitle("Products")
			.onAppear {
				apiService.fetchProducts(from: ViewPDFConstants.Products.productAPI)
				do { try loadProducts() } catch {
					errorMessage = error.localizedDescription
				}
			}
		}
	}

	private func loadProducts() throws {
		products = try manager.fetchAllProducts()
	}

	private func delete(at offsets: IndexSet) {
		for index in offsets {
			let product = products[index]
			if let id = product.id {
				do {
					try manager.deleteProduct(id: id)
					try loadProducts()
				} catch {
					errorMessage = error.localizedDescription
				}
			}
		}
	}

	private func clearFields() {
		id = UUID().uuidString
		name = ""
		selectedProduct = nil
		errorMessage = nil
	}
}

#Preview {
	ProductListView()
}
