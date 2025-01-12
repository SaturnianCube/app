//
//  Heading.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI

struct Heading: View {
	
	@State var text: String
	
    var body: some View {
		HStack {
			Text(text).font(.largeTitle).fontWeight(.bold)
			Spacer()
		}
    }
}

#Preview {
	Heading(text: "Test Heading")
}
