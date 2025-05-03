//
//  ViewControllerResolver.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//

import SwiftUI

struct ViewControllerResolver: UIViewControllerRepresentable {
	var onResolve: (UIViewController) -> Void
	
	func makeUIViewController(context: Context) -> some UIViewController {
		ResolverViewController(onResolve: onResolve)
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
	
	private class ResolverViewController: UIViewController {
		let onResolve: (UIViewController) -> Void
		
		init(onResolve: @escaping (UIViewController) -> Void) {
			self.onResolve = onResolve
			super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func viewDidLoad() {
			super.viewDidLoad()
			onResolve(self)
		}
	}
	
}

