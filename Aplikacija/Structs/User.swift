//
//  User.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Hashable, Codable, IdentifiableStruct {
	
	private static let dataManager: DataManager = DataManager.shared
	private static let collectionName: String = "users"
	
	@DocumentID var id: String?
	var name: String
	var biography: String
	var ratings: [DocumentReference]
	
	// Methods
	
	mutating public func create () async {
		let updatedUser = await User.dataManager.addDocument(collection: User.collectionName, data: self)
		self.id = updatedUser?.documentID
	}
	
	public func update () async {
		let _ = await User.dataManager.updateDocument(collection: User.collectionName, data: self)
	}
	
	mutating public func delete () async {
		
		let res = await User.dataManager.deleteDocument(collection: User.collectionName, data: self)
		
		if res {
			self.id = nil
		}
	}
	
	// Static
	
	static func getRefById (id: String) -> DocumentReference {
		return dataManager.getDocumentRefById(collection: collectionName, id: id)
	}
	
	static func getRef (user: User) -> DocumentReference? {
		return dataManager.getDocumentRef(collection: collectionName, data: user)
	}
	
	static func fetchById (id: String) async -> User? {
		return await dataManager.fetchDocument(collection: collectionName, id: id)
	}
	
	// Generation
	
	static func generateDummy () -> User {
		
		var dataManager = DataManager.shared
		
		return User(
			id: "EVUYpzqMpbzMjCBwA6Fd",
			name: "Jure",
			biography: "Nimam pojma kaj delam, ampak bom naredil faks.",
			ratings: [
				dataManager.getRatingRefById(id: "0RyE5FDGWWxjyFMg1Pav"),
				dataManager.getRatingRefById(id: "0uOOeFWdyZ7Z6Gfwekuv")
			]
		)
	}
		
//	static func generate () async -> User {
//		
//		let dataManager = DataManager.shared
//		
//		var user = User(
//			name: "Janezek",
//			biography: "Sem Janezek. Živjo!",
//			ratings: []
//		)
//		
//		let ref = await dataManager.addUser(user: user)!
//		
//		for _ in 1...Int.random(in: 1...8) {
//			user.ratings.append(await Rating.generate(userRef: ref))
//		}
//		
//		return user
//	}
	
}
