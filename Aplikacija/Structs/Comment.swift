//
//  Comment.swift
//  Aplikacija
//
//  Created on 23. 11. 24.
//

import Foundation

struct Comment: Identifiable, Hashable {
	
	let id = UUID()
	let author: User
	let rating: Decimal
	let content: String
	
	static func generate () -> Comment {
		return Comment(author: User(name: "Janezek", rating: 1.0, biography: "Dobrodošel na mojem profilu. Vsem podam oceno.", comments: [ ]), rating: Decimal(Int.random(in: 1..<51) / 10), content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
	}
}
