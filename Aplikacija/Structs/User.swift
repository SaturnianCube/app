//
//  User.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import Foundation

struct User: Identifiable, Hashable {
	
	let id = UUID()
	let name: String
	let rating: Decimal
	let biography: String
	let comments: [Comment]
	
	static func generate () -> User {
		return User(name: "Janezek", rating: 1.0, biography: "Sem Janezek. Živjo!", comments: [ Comment.generate() ])
	}
	
}
