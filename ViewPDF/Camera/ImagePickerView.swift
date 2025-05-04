//
//  ImagePickerView.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 04/05/25.
//

import SwiftUI
import AVFoundation

struct ImagePickerView: View {
	@State private var selectedImage: UIImage?
	@State private var isShowingImagePicker = false
	@State private var isShowingCamera = false

	var body: some View {
		VStack(spacing: 20) {
			// Show selected or captured image
			if let image = selectedImage {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(height: 250)
					.cornerRadius(10)
			} else {
				Rectangle()
					.fill(Color.gray.opacity(0.3))
					.frame(height: 250)
					.overlay(Text("No Image Selected").foregroundColor(.gray))
			}

			// Buttons
			HStack {
				Button("Capture Photo") {
					checkCameraPermission { granted in
						if granted {
							isShowingCamera = true
							isShowingImagePicker = false
						} else {
							print("camera access denied")
						}
					}
					
				}
				.disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
				
				Button("Choose from Gallery") {
					isShowingCamera = false
					isShowingImagePicker = true
				}
			}
			.buttonStyle(.borderedProminent)
		}
		.fullScreenCover(isPresented: $isShowingCamera) {
			ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
		}
		.sheet(isPresented: $isShowingImagePicker) {
			ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
		}
		.padding()
		.navigationTitle("Select Image")
	}
	
	func checkCameraPermission(completion: @escaping (Bool) -> Void) {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			completion(true)
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .video) { granted in
				DispatchQueue.main.async {
					completion(granted)
				}
			}
		case .denied, .restricted:
			completion(false)
		@unknown default:
			completion(false)
		}
	}
}

