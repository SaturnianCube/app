//
//  User.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, IdentifiableStruct, Hashable, Codable {
		
	@DocumentID var id: String?
	var name: String
	var biography: String
	var ratings: [DocumentReference]
		
	static func generate () async -> User {
		
		let dataManager = DataManager.shared
		
		var user = User(
			name: "Janezek",
			biography: "Sem Janezek. Živjo!",
			ratings: []
		)
		
		let ref = await dataManager.addUser(user: user)!
		
		for _ in 1...Int.random(in: 1...8) {
			user.ratings.append(await Rating.generate(userRef: ref))
		}
		
		return user
	}
	
}
