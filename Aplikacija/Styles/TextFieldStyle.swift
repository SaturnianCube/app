//
//  TextFieldStyle.swift
//  Aplikacija
//
//  Created on 13. 1. 25.
//

import Foundation
import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
	func _body (configuration: TextField<Self._Label>) -> some View {
		configuration
			.foregroundColor(.secondary)
			.padding(10)
			.overlay {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.secondary, lineWidth: 2)
			}
	}
}
