//
//  Event.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import Foundation
import MapKit

enum EventType {
	
	case food
	case help
	case entertainment
	case shopping
	case education
	
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
			default:
				return "mappinn"
		}
	}
}

enum Currency {
	
	case eur
	
	func getSymbol () -> String {
		switch self {
			case .eur:
				return "€"
		}
	}
}

struct MonetaryValue {
	let currency: Currency
	let value: Decimal
}

struct Event: Identifiable, Equatable {
	
	let id = UUID()
	let type: EventType
	let author: User
	let title: String
	let description: String
	let payment: MonetaryValue?
	let position: CLLocationCoordinate2D
	let dateInterval: DateInterval
	let postDate: Date
	
	static func == (lhs: Event, rhs: Event) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func generate () -> Event {
		return Event(
			type: .food,
			   author: pickRandomUser(),
			   title: "Kosilo",
			   description: "Želim si družbe pri kosilu. Če te več zanima o meni, si poglej moj profil.",
			   payment: MonetaryValue(currency: .eur, value: 10),
			   position: CLLocationCoordinate2D(latitude: 46.054072, longitude: 14.512543),
			   dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1732280400), end: Date(timeIntervalSince1970: 1732282200)),
			   postDate: Date(timeIntervalSince1970: 1732279985)
		   )
	}
}
