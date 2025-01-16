//
//  ProfileViewModel.swift
//  Aplikacija
//
//  Created on 16. 1. 25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class UserInfoViewModel: ObservableObject {

	@Published var user: User
	@Published var ratings: [Rating]
	
	@Published var showRatingSheet: Bool = false
	
	init (user: User) {
		self.user = user
		self.ratings = []
	}
	
	func fetchRatings () async {
		self.ratings = await DataManager.shared.fetchRatingsByRef(ratingRefs: user.ratings)
	}
	
	var averageRating: Decimal {
		return ratings.count > 0
			? ratings.reduce(0, { result, current in
					result + current.rating
			 }) / Decimal(ratings.count)
			: 0.0
	}

}
