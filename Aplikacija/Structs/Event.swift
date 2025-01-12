//
//  Event.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import Foundation
import MapKit

enum EventType: CaseIterable {
	
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
	
	private static var ID_COUNTER: UInt = 1
	
	let id: UInt
	let type: EventType
	let user: User
	let title: String
	let description: String
	let payment: MonetaryValue?
	let position: CLLocationCoordinate2D
	let dateInterval: DateInterval
	let postDate: Date
	
	init (
		type: EventType,
		user: User,
		title: String,
		description: String,
		payment: MonetaryValue?,
		position: CLLocationCoordinate2D,
		dateInterval: DateInterval,
		postDate: Date
	) {
		
		self.id = Event.ID_COUNTER
		Event.ID_COUNTER += 1
		
		self.type = type
		self.user = user
		self.title = title
		self.description = description
		self.payment = payment
		self.position = position
		self.dateInterval = dateInterval
		self.postDate = postDate
	}
	
	static func == (lhs: Event, rhs: Event) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func generate () -> Event {
		return Event(
			type: .food,
			user: pickRandomUser(),
			title: "Kosilo",
			description: "Želim si družbe pri kosilu. Če te več zanima o meni, si poglej moj profil.",
			payment: MonetaryValue(currency: .eur, value: 10),
			position: CLLocationCoordinate2D(latitude: 46.054072, longitude: 14.512543),
			dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1732280400), end: Date(timeIntervalSince1970: 1732282200)),
			postDate: Date(timeIntervalSince1970: 1732279985)
	   )
	}
}
