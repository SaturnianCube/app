//
//  RatingCreatorViewModel.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class RatingCreatorViewModel: ObservableObject {

	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var dataManager = DataManager.shared
	
	@Published var user: User
	var onRatingAdded: ((Rating) -> Void)
	
	@State var inputComment: String = ""
	@State var inputRating: Decimal = 0.0
	
	@State var errorMessage: String = "" {
		didSet { shouldShowError = !errorMessage.isEmpty }
	}
	@State var shouldShowError: Bool = false
	@State var isLoading: Bool = false
	
	init (user: User, onRatingAdded: @escaping ((Rating) -> Void)) {
		self.user = user
		self.onRatingAdded = onRatingAdded
	}
	
	func submit () async {
		
		guard let user = dataManager.currentUser else {
			errorMessage = "Objavljanje ocen na svoj profil ni dovoljeno"
			return
		}
		
		if inputComment.isEmpty {
			errorMessage = "Komentar manjka"
			return
		}
		
		if inputRating < 0 {
			errorMessage = "Ocena ne sme biti nižja od 0"
			return
		}
		
		if inputRating > 5 {
			errorMessage = "Ocena ne sme biti višja od 5"
			return
		}
		
		isLoading = true
			
		var rating = Rating(
			user: dataManager.getUserRef(user: user)!,
			rating: inputRating,
			comment: inputComment
		)
		
		let ref = await dataManager.addRating(rating: rating)
		
		isLoading = false

		if ref != nil {
			
			rating.id = ref?.documentID
			onRatingAdded(rating)
			
			presentationMode.wrappedValue.dismiss()
		} else {
			errorMessage = "Ocena ni bila uspešno objavljena"
		}
	}

}
