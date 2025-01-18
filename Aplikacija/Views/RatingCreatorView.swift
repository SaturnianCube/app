//
//  RatingCreatorView.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import Foundation
import SwiftUI

struct RatingCreatorView: View {
	
	@StateObject private var viewModel: RatingCreatorViewModel
	
	init (targetUser: User, onRatingAdded: @escaping ((Rating) -> Void)) {
		_viewModel = .init(wrappedValue: .init(targetUser: targetUser, onRatingAdded: onRatingAdded))
	}
	
	var body: some View {
		ZStack {
						
			Color(.systemGroupedBackground)
				.edgesIgnoringSafeArea(.all)
			
			VStack {
				
				Heading(text: "Dodaj oceno")
				
				Form {
				
					HStack {
						Text("Ocena")
						Spacer()
						TextField("Ocena", value: $viewModel.inputRating, format: .number)
							.keyboardType(.numberPad)
							.multilineTextAlignment(.trailing)
					}
					
					HStack {
						Text("Komentar")
						Spacer()
						TextField("Komentar", text: $viewModel.inputComment)
					}
					
				}
				.alert(isPresented: $viewModel.shouldShowError) {
					Alert(title: Text("Napaka"), message: Text(viewModel.errorMessage))
				}
				
				Button("Objavi", systemImage: "plus") {
					Task {
						await viewModel.submit()
					}
				}
				.buttonStyle(PrimaryButtonStyle())
			}.disabled(viewModel.isLoading)
			
			if viewModel.isLoading {
				LoadingBuffer()
			}
		}
	}
}

#Preview {
	RatingCreatorView(targetUser: User.generateDummy(), onRatingAdded: { _ in })
}
