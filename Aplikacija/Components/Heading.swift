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
		Text("")
			.navigationTitle(text)
    }
}

#Preview {
	Heading(text: "Test Heading")
}
