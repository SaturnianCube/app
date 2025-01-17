//
//  RatingViewModel.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class RatingViewModel: ObservableObject {

	// Inputs
	@Published var rating: Rating
	@Published var user: User?
	
	init (rating: Rating) {
		self.rating = rating
		self.user = nil
	}
	
	func fetchRatingUser () async {
		self.user = await User.fetchById(id: rating.user.documentID)
	}

}
