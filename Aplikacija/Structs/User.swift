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
		
		let users = [
			User(name: "Janezek", rating: 1.0, biography: "Sem Janezek. Živjo!", comments: [ Comment.generate() ]),
			User(name: "Eva", rating: 3.6, biography: "Sem prvič na tej aplikaciji. Ž20", comments: [ Comment.generate(), Comment.generate() ]),
			User(name: "Bojan", rating: 5.0, biography: "Sem invalidna oseba. Rad nakupujem.", comments: [ Comment.generate(), Comment.generate(), Comment.generate() ]),
			User(name: "Jure", rating: 2.5, biography: "Nimam pojma kaj delam, ampak bom naredil faks.", comments: [ Comment.generate(), Comment.generate(), Comment.generate(), Comment.generate() ])
		]
		
		return users[Int.random(in: 0..<users.count)]
	}
}
