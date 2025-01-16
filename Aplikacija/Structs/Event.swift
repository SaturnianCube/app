//
//  Event.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import Foundation
import MapKit
import SwiftUI
import FirebaseFirestore

enum EventType: CaseIterable, Codable {
	
	case food
	case help
	case entertainment
	case shopping
	case education
	
	func getName () -> String {
		switch self {
			case .food:
				return "Hrana"
			case .help:
				return "Pomoč"
			case .entertainment:
				return "Zabava"
			case .shopping:
				return "Nakupovanje"
			case .education:
				return "Izobraževanje"
		}
	}
	
	func getIcon () -> String {
		switch self {
			case .food:
				return "fork.knife"
			case .help:
				return "figure.wave"
			case .entertainment:
				return "entertainment"
			case .shopping:
				return "bag.fill"
			case .education:
				return "graduationcap.fill"
		}
	}
	
	func getColor () -> Color {
		switch self {
			case .food:
				return .green
			case .help:
				return .blue
			case .entertainment:
				return .black
			case .shopping:
				return .yellow
			case .education:
				return .orange
		}
	}
	
}

enum Currency: Codable {
	
	case eur
	
	func getSymbol () -> String {
		switch self {
			case .eur:
				return "€"
		}
	}
}

struct MonetaryValue: Codable {
	let currency: Currency
	let value: Decimal
}

struct Coordinate: Codable {
	
	var latitude: Double
	var longitude: Double
	
	init (coordinate: CLLocationCoordinate2D) {
		self.latitude = coordinate.latitude
		self.longitude = coordinate.longitude
	}
	
	var asCLLocationCoordinate2D: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
	}
	
}

struct Event: Identifiable, IdentifiableStruct, Equatable, Codable {
		
	@DocumentID var id: String?
	var type: EventType
	var user: User
	var title: String
	var description: String
	var payment: MonetaryValue?
	var position: Coordinate
	var dateInterval: DateInterval
	var postDate: Date
	
	static func == (lhs: Event, rhs: Event) -> Bool {
		return lhs.id == rhs.id
	}
	
//	static func generate () -> Event {
//		return Event(
//			type: .food,
//			user: User.generate(),
//			title: "Kosilo",
//			description: "Želim si družbe pri kosilu. Če te več zanima o meni, si poglej moj profil.",
//			payment: MonetaryValue(currency: .eur, value: 10),
//			position: Coordinate(coordinate: CLLocationCoordinate2D(latitude: 46.054072, longitude: 14.512543)),
//			dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1732280400), end: Date(timeIntervalSince1970: 1732282200)),
//			postDate: Date(timeIntervalSince1970: 1732279985)
//	   )
//	}
}
