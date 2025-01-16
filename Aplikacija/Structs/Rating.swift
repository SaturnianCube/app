//
//  Rating.swift
//  Aplikacija
//
//  Created on 23. 11. 24.
//

import Foundation
import FirebaseFirestore

struct Rating: Identifiable, IdentifiableStruct, Hashable, Codable {
	
	@DocumentID var id: String?
	var user: DocumentReference
	var rating: Decimal
	var comment: String
	
	static func generate (userRef: DocumentReference) async -> DocumentReference {

		let dataManager = DataManager.shared
		
		let rating = Rating(
			user: userRef,
			rating: Decimal(Int.random(in: 1..<51) / 10),
			comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
		)
		
		return await dataManager.addRating(rating: rating)!
	}
}
