//
//  ButtonStyle.swift
//  Aplikacija
//
//  Created on 13. 1. 25.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
	func makeBody (configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue)
			.clipShape(.capsule)
			.cornerRadius(10)
			.scaleEffect(configuration.isPressed ? 0.95 : 1)
			.animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct ScaleEffectButtonStyle: ButtonStyle {
	func makeBody (configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 1.4 : 1)
			.animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
	}
}
