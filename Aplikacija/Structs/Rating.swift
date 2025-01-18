//
//  Rating.swift
//  Aplikacija
//
//  Created on 23. 11. 24.
//

import Foundation
import FirebaseFirestore

struct Rating: Identifiable, Hashable, Codable, IdentifiableStruct {
	
	private static let dataManager: DataManager = DataManager.shared
	private static let collectionName: String = "ratings"
	
	@DocumentID var id: String?
	var user: DocumentReference
	var rating: Decimal
	var comment: String
	
	// Methods
	
	mutating public func create (forUser: User) async -> Rating? {
		
		let updated = await Rating.dataManager.addDocument(collection: Rating.collectionName, data: self)
		
		if let updated = updated {
			
			self.id = updated.documentID
			
			if let ref = Rating.getRef(rating: self) {
				var _forUser = forUser
				_forUser.ratings.append(ref)
				let _ = await _forUser.update()
			}
			
			return self
		}
		
		return nil
	}
	
	public func update () async -> Rating? {
		
		let updated = await Rating.dataManager.updateDocument(collection: Rating.collectionName, data: self)
		
		if let updated = updated {
			return updated
		}
		
		return nil
	}
	
	mutating public func delete () async -> Bool {
		
		let res = await Rating.dataManager.deleteDocument(collection: Rating.collectionName, data: self)
		
		if res {
			self.id = nil
		}
		
		return res
	}
	
	// Static
	
	static func getRefById (id: String) -> DocumentReference {
		return dataManager.getDocumentRefById(collection: collectionName, id: id)
	}
	
	static func getRef (rating: Rating) -> DocumentReference? {
		return dataManager.getDocumentRef(collection: collectionName, data: rating)
	}
	
	static func fetchById (id: String) async -> Rating? {
		return await dataManager.fetchDocument(collection: collectionName, id: id)
	}
	
	static func fetchByRefs (refs: [DocumentReference]) async -> [Rating] {
		return await dataManager.fetchDocumentsByRefs(refs: refs)
	}
	
	// Generation
	
	static func generateDummy (forUser: User) -> Rating {
		return Rating(
			id: RandomFactory.randomId(),
			user: User.getRefById(id: forUser.id!),
			rating: Decimal(Int.random(in: 1..<51) / 10),
			comment: "Test comment test comment 42"
		)
	}
	
//	static func generate (userRef: DocumentReference) async -> DocumentReference {
//
//		let dataManager = DataManager.shared
//		
//		let rating = Rating(
//			user: userRef,
//			rating: Decimal(Int.random(in: 1..<51) / 10),
//			comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
//		)
//		
//		return await dataManager.addRating(rating: rating)!
//	}
}
