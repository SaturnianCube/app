//
//  User.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import Foundation

struct User: Identifiable, Hashable {
	
	private static var ID_COUNTER: UInt = 1
	
	let id: UInt
	let name: String
	let rating: Decimal
	let biography: String
	let comments: [Comment]
	
	init (
		name: String,
		rating: Decimal,
		biography: String,
		comments: [Comment]
	) {
		
		self.id = User.ID_COUNTER
		User.ID_COUNTER += 1
		
		self.name = name
		self.rating = rating
		self.biography = biography
		self.comments = comments
	}
	
	static func generate () -> User {
		return User(
			name: "Janezek",
			rating: 1.0,
			biography: "Sem Janezek. Živjo!",
			comments: [ Comment.generate() ]
		)
	}
	
}
