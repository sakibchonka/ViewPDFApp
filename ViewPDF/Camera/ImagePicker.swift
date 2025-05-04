//
//  ImagePicker.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 04/05/25.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		let parent: ImagePicker

		init(parent: ImagePicker) {
			self.parent = parent
		}

		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			if let image = info[.originalImage] as? UIImage {
				parent.selectedImage = image
			}
			parent.presentationMode.wrappedValue.dismiss()
		}

		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			parent.presentationMode.wrappedValue.dismiss()
		}
	}

	@Environment(\.presentationMode) var presentationMode
	var sourceType: UIImagePickerController.SourceType = .photoLibrary
	@Binding var selectedImage: UIImage?

	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	func makeUIViewController(context: Context) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.sourceType = sourceType
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

