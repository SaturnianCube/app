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

//func pickRandomUser () -> User {
//	
//	let users = [
//		User(name: "Janezek", rating: 1.0, biography: "Sem Janezek. Živjo!", comments: [ Comment.generate() ]),
//		User(name: "Eva", rating: 3.6, biography: "Sem prvič na tej aplikaciji. Ž20", comments: [ Comment.generate(), Comment.generate() ]),
//		User(name: "Bojan", rating: 5.0, biography: "Sem invalidna oseba. Rad nakupujem.", comments: [ Comment.generate(), Comment.generate(), Comment.generate() ]),
//		User(name: "Jure", rating: 2.5, biography: "Nimam pojma kaj delam, ampak bom naredil faks.", comments: [ Comment.generate(), Comment.generate(), Comment.generate(), Comment.generate() ])
//	]
//	
//	return users[Int.random(in: 0..<users.count)]
//}

class DataManager: ObservableObject {
	
	static let shared = DataManager()
	
	private let db = Firestore.firestore()
	
	@Published var events: [Event]
	@Published var currentUser: Optional<User>
	
	init () {
		
		self.events = []
		self.currentUser = nil
		
//		self.currentUser = User.generate()
//		
//		self.events = [
//			Event(
//				type: .food,
//				user: pickRandomUser(),
//				title: "Skupno kosilo",
//				description: "Želim si družbe pri kosilu. Če te več zanima o meni, si poglej moj profil.",
//				payment: MonetaryValue(currency: .eur, value: 10),
//				position: CLLocationCoordinate2D(latitude: 46.054072, longitude: 14.512543),
//				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1732280400), end: Date(timeIntervalSince1970: 1732282200)),
//				postDate: Date(timeIntervalSince1970: 1732279985)
//			),
//			Event(
//				type: .help,
//				user: pickRandomUser(),
//				title: "Pomoč pri premikanju pohištva",
//				description: "Potrebovala bi kakšnega čvrstega moškega za pomoč pri premikanju novega lesenga pohištva :)",
//				payment: MonetaryValue(currency: .eur, value: 60),
//				position: CLLocationCoordinate2D(latitude: 46.039161, longitude: 14.490042),
//				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1729004400), end: Date(timeIntervalSince1970: 1729011600)),
//				postDate: Date(timeIntervalSince1970: 1729005068)
//			),
//			Event(
//				type: .shopping,
//				user: pickRandomUser(),
//				title: "Pomoč pri nošenju nakupov",
//				description: "Potreboval bi pomoč pri nošenju nakupljenega blaga, saj sem invalidna oseba.",
//				payment: MonetaryValue(currency: .eur, value: 30),
//				position: CLLocationCoordinate2D(latitude: 46.06793, longitude: 14.54191),
//				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1731514500), end: Date(timeIntervalSince1970: 1731519000)),
//				postDate: Date(timeIntervalSince1970: 1731481697)
//			),
//			Event(
//				type: .education,
//				user: pickRandomUser(),
//				title: "Lov na Sašo",
//				description: "Potreboval bi nekoga, da mi pomaga najdet Sašo na faksu. Imam resen za opravit zelo resen pogovor z njim.",
//				payment: MonetaryValue(currency: .eur, value: 200),
//				position: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
//				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1733985000), end: Date(timeIntervalSince1970: 1733988600)),
//				postDate: Date(timeIntervalSince1970: 1733949762)
//			)
//		]

	}
	
	func getDocumentRefById (collection: String, id: String) -> DocumentReference {
		return db.collection(collection).document(id)
	}
	
	func getDocumentRef<T> (collection: String, data: T) -> DocumentReference? where T: Codable, T: IdentifiableStruct {
		
		if let id = data.id {
			
			let docRef = db.collection(collection).document(id)
			
			return docRef
		}
		
		return nil
	}
	
	func addDocument<T: Codable> (collection: String, data: T) async -> DocumentReference? {
		
		let collRef = db.collection(collection)
		
		do {
			let newDocRef = try collRef.addDocument(from: data)
			return newDocRef
		} catch {
			print("Error while adding to /\(collection): \(error.localizedDescription)")
			return nil
		}
	}
	
	func fetchDocument<T: Codable> (collection: String, id: String) async -> T? {
		
		let docRef = db.collection(collection).document(id)
		
		return await withCheckedContinuation { continuation in
			docRef.getDocument(as: T.self) { result in
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
	
	func fetchDocumentsByRefs<T> (docRefs: [DocumentReference]) async -> [T] where T: Codable {
		
		var data: [T] = []
		
		return await withCheckedContinuation { continuation in
			
			let dispatchGroup = DispatchGroup()
					
			for docRef in docRefs {
				dispatchGroup.enter()
				docRef.getDocument(as: T.self) { result in
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
	
	func updateDocument<T> (collection: String, data: T) async -> T? where T: Codable, T: IdentifiableStruct {
		return await withCheckedContinuation { continuation in
			
			if let id = data.id {
				
				let docRef = db.collection(collection).document(id)
				
				do {
					try docRef.setData(from: data)
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
				
				let docRef = db.collection(collection).document(id)
				
				docRef.delete() { error in
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
