//
//  SplashView.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 02/05/25.
//

import SwiftUI

struct SplashView: View {
	@State private var isActive = false
	
	
	var body: some View {
		if isActive {
			LoginView()
		} else {
			_SplashView(isActive: $isActive)
		}
	}
}

struct _SplashView: View {
	@Binding var isActive: Bool
	@State private var animate = false
	
	var body: some View {
		VStack {
			Image("AppLogo")
				.resizable()
				.clipShape(.rect(cornerRadius: 20))
				.scaledToFit()
				.frame(width: 150, height: 150)
				.opacity(animate ? 1 : 0)
				.onAppear {
					withAnimation(.easeIn(duration: 0.5)) {
						animate = true
					}
				}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Color("AppBackground")
		)
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				isActive = true
			}
		}
	}
}

#Preview {
	SplashView()
}

