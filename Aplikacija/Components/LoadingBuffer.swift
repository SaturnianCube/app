//
//  LoadingBuffer.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI

struct LoadingBuffer: View {
    var body: some View {
		ZStack {
			VStack(spacing: 16) {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: .white))
					.scaleEffect(2)
			}
			.frame(width: 100, height: 100)
			.background(Color.gray.opacity(0.5))
			.cornerRadius(12)
		}
    }
}

#Preview {
    LoadingBuffer()
}
