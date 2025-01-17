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
	
	mutating public func create () async -> User? {
		
		let updated = await User.dataManager.addDocument(collection: User.collectionName, data: self)
		
		if let updated = updated {
			self.id = updated.documentID
			return self
		}
		
		return nil
	}
	
	public func update () async -> User? {
		
		let updated = await User.dataManager.updateDocument(collection: User.collectionName, data: self)
		
		if let updated = updated {
			return updated
		}
		
		return nil
	}
	
	mutating public func delete () async -> Bool {
		
		let res = await User.dataManager.deleteDocument(collection: User.collectionName, data: self)
		
		if res {
			self.id = nil
		}
		
		return res
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
	
	static func fetchByRef (ref: DocumentReference) async -> User? {
		return await dataManager.fetchDocumentByRef(collection: collectionName, ref: ref)
	}
	
	// Generation
	
	static func generateDummy () -> User {
		return User(
			id: RandomFactory.randomId(),
			name: "N/A",
			biography: "Nimam pojma kaj delam, ampak bom naredil faks.",
			ratings: [
				Rating.getRefById(id: "0RyE5FDGWWxjyFMg1Pav"),
				Rating.getRefById(id: "0uOOeFWdyZ7Z6Gfwekuv")
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
