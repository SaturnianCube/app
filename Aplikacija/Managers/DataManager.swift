//
//  DataManager.swift
//  Aplikacija
//
//  Created on 9. 1. 25.
//

import Foundation
import MapKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore

class DataManager: ObservableObject {
	
	static let shared: DataManager = DataManager()
		
	@Published var events: [Event] = []
	@Published var currentUser: User? = nil

	// State
	
	func addEvent (event: Event) {
		events.append(event)
	}
	
	// DB
	
	private let db: Firestore = Firestore.firestore()
	
	func getDocumentRefById (collection: String, id: String) -> DocumentReference {
		return db.collection(collection).document(id)
	}
	
	func getDocumentRef<T> (collection: String, data: T) -> DocumentReference? where T: Codable, T: IdentifiableStruct {
		
		if let id = data.id {
			
			let ref = db.collection(collection).document(id)
			
			return ref
		}
		
		return nil
	}
	
	func addDocument<T: Codable> (collection: String, data: T) async -> DocumentReference? {
		
		let coll = db.collection(collection)
		
		do {
			let newRef = try coll.addDocument(from: data)
			return newRef
		} catch {
			print("Error while adding to /\(collection): \(error.localizedDescription)")
			return nil
		}
	}
	
	func fetchDocument<T: Codable> (collection: String, id: String) async -> T? {
		
		let ref = db.collection(collection).document(id)
		
		return await withCheckedContinuation { continuation in
			ref.getDocument(as: T.self) { result in
				switch result {
					case .success(let data):
						continuation.resume(returning: data)
					case .failure(let error):
						print("Error while fetching from /\(collection): \(error.localizedDescription)")
						continuation.resume(returning: nil)
				}
			}
		}
	}
	
	func fetchDocumentByRef<T: Codable> (collection: String, ref: DocumentReference) async -> T? {
		return await fetchDocument(collection: collection, id: ref.documentID)
	}
	
	func fetchDocumentsByRefs<T> (refs: [DocumentReference]) async -> [T] where T: Codable {
		return await withCheckedContinuation { continuation in
			
			var data: [T] = []
			let dispatchGroup = DispatchGroup()
					
			for ref in refs {
				dispatchGroup.enter()
				ref.getDocument(as: T.self) { result in
					switch result {
						case .success(let _data):
							data.append(_data)
						case .failure(let error):
							print("Error while fetching reference: \(error.localizedDescription)")
					}
					dispatchGroup.leave()
				}
			}
			
			dispatchGroup.notify(queue: .main) {
				continuation.resume(returning: data)
			}
		}
	 }
	
	func fetchAllDocuments<T> (collection: String) async -> [T] where T: Codable {
		do {
			
			let snapshot = try await db.collection(collection).getDocuments()
			
			return snapshot.documents.compactMap { document -> T? in
				return try? document.data(as: T.self)
			}
			
		} catch {
			print("Error while fetching all \(collection): \(error.localizedDescription)")
		}

		return []
	}
	
	func updateDocument<T> (collection: String, data: T) async -> T? where T: Codable, T: IdentifiableStruct {
		return await withCheckedContinuation { continuation in
			
			if let id = data.id {
				
				let ref = db.collection(collection).document(id)
				
				do {
					try ref.setData(from: data)
					continuation.resume(returning: data)
				} catch {
					print("Error while updating /\(collection): \(error.localizedDescription)")
				}
				
			}
			
			continuation.resume(returning: nil)
		}
	}
	
	func deleteDocument<T> (collection: String, data: T) async -> Bool where T: Codable, T: IdentifiableStruct {
		return await withCheckedContinuation { continuation in
			if let id = data.id {
				
				let ref = db.collection(collection).document(id)
				
				ref.delete() { error in
					if let error = error {
						print("Error while deleting /\(collection): \(error.localizedDescription)")
					} else {
						continuation.resume(returning: true)
					}
				}
				
			}
			
			continuation.resume(returning: false)
		}
	}
		
}
