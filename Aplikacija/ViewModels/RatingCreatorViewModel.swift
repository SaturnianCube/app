//
//  RatingCreatorViewModel.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import SwiftUI

class RatingCreatorViewModel: CreatorViewModel {

	@ObservedObject private var dataManager: DataManager = .shared
		
	// Inputs
	@Published var targetUser: User
	private var onRatingAdded: ((Rating) -> Void)
		
	// UI Inputs
	@Published var inputComment: String = ""
	@Published var inputRating: Decimal = 0.0
	
	init (targetUser: User, onRatingAdded: @escaping ((Rating) -> Void)) {
		self.targetUser = targetUser
		self.onRatingAdded = onRatingAdded
	}
	
	func submit () async {
		
		guard let currentUser = dataManager.currentUser else {
			errorMessage = "Niste prijavljeni"
			return
		}
		
		guard targetUser != dataManager.currentUser else {
			errorMessage = "Objavljanje ocen na svoj profil ni dovoljeno"
			return
		}
		
		guard !inputComment.isEmpty else {
			errorMessage = "Komentar ne sme biti prazen"
			return
		}
		
		guard inputRating >= 1 else {
			errorMessage = "Ocena ne sme biti nižja od 0"
			return
		}
		
		guard inputRating <= 5 else {
			errorMessage = "Ocena ne sme biti višja od 5"
			return
		}
		
		isLoading = true
			
		var rating = Rating(
			user: User.getRefById(id: currentUser.id!),
			rating: inputRating,
			comment: inputComment
		)
		
		let res = await rating.create(forUser: targetUser)
		
		isLoading = false

		if let res = res {
			onRatingAdded(res)
		} else {
			errorMessage = "Nekaj je šlo narobe pri objavi ocene"
		}
	}

}
