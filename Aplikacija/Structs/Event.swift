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
	var type: EventType
	let author: User
	var title: String
	var description: String
	var payment: MonetaryValue?
	var position: CLLocationCoordinate2D
	var dateInterval: DateInterval
	var postDate: Date
	
	static func generate () -> Event {
		return Event(
			type: .education,
			author: User.generate(),
			title: "Izpit iz programiranja",
			description: "Potreboval bi nekoga, da lahko namesto mene piše izpit iz programiranja, saj nimam pojma kaj delam.",
			payment: MonetaryValue(currency: .eur, value: 200),
			position: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
			dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1733985000), end: Date(timeIntervalSince1970: 1733988600)),
			postDate: Date(timeIntervalSince1970: 1733949762)
	   )
	}
	
	static func generateList () -> [Event] {
		return [
			Event(
				type: .food,
				author: User.generate(),
				title: "Kosilo",
				description: "Želim si družbe pri kosilu. Če te več zanima o meni, si poglej moj profil.",
//				payment: MonetaryValue(currency: .eur, value: 10),
				position: CLLocationCoordinate2D(latitude: 46.054072, longitude: 14.512543),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1732280400), end: Date(timeIntervalSince1970: 1732282200)),
				postDate: Date(timeIntervalSince1970: 1732279985)
			),
			Event(
				type: .help,
				author: User.generate(),
				title: "Pomoč pri premikanju pohištva",
				description: "Potrebovala bi kakšnega čvrstega moškega za pomoč pri premikanju novega lesenga pohištva :)",
				payment: MonetaryValue(currency: .eur, value: 60),
				position: CLLocationCoordinate2D(latitude: 46.039161, longitude: 14.490042),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1729004400), end: Date(timeIntervalSince1970: 1729011600)),
				postDate: Date(timeIntervalSince1970: 1729005068)
			),
			Event(
				type: .shopping,
				author: User.generate(),
				title: "Pomoč pri nošenju nakupov",
				description: "Potreboval bi pomoč pri nošenju nakupljenega blaga, saj sem invalidna oseba.",
				payment: MonetaryValue(currency: .eur, value: 30),
				position: CLLocationCoordinate2D(latitude: 46.06793, longitude: 14.54191),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1731514500), end: Date(timeIntervalSince1970: 1731519000)),
				postDate: Date(timeIntervalSince1970: 1731481697)
			),
			Event(
				type: .education,
				author: User.generate(),
				title: "Izpit iz programiranja",
				description: "Potreboval bi nekoga, da lahko namesto mene piše izpit iz programiranja, saj nimam pojma kaj delam.",
				payment: MonetaryValue(currency: .eur, value: 200),
				position: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1733985000), end: Date(timeIntervalSince1970: 1733988600)),
				postDate: Date(timeIntervalSince1970: 1733949762)
			)
		]
	}
	
	static func == (lhs: Event, rhs: Event) -> Bool {
		return lhs.id == rhs.id
	}
}
