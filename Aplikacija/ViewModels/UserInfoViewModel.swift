//
//  ProfileViewModel.swift
//  Aplikacija
//
//  Created on 16. 1. 25.
//

import SwiftUI
import FirebaseFirestore

class UserInfoViewModel: ObservableObject {
	
	@ObservedObject private var dataManager: DataManager = .shared
	
	// Inputs
	let user: User
	
	// UI State
	@Published var ratings: [Rating] = []
	@Published var showRatingSheet: Bool = false
	
	init (user: User) {
		self.user = user
	}
	
	var currentUser: User? {
		return dataManager.currentUser
	}
	
	func fetchRatings () async {
		self.ratings = await Rating.fetchByRefs(refs: user.ratings)
	}
	
	var averageRating: Decimal {
		return ratings.count > 0
			? ratings.reduce(0, { result, current in
					result + current.rating
			 }) / Decimal(ratings.count)
			: 0.0
	}
	
	var sortedRatings: [Rating] {
		return ratings.sorted { $0.postDate > $1.postDate }
	}

}
