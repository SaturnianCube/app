//
//  DataManager.swift
//  Aplikacija
//
//  Created on 9. 1. 25.
//

import Foundation
import MapKit

func pickRandomUser () -> User {
	
	let users = [
		User(name: "Janezek", rating: 1.0, biography: "Sem Janezek. Živjo!", comments: [ Comment.generate() ]),
		User(name: "Eva", rating: 3.6, biography: "Sem prvič na tej aplikaciji. Ž20", comments: [ Comment.generate(), Comment.generate() ]),
		User(name: "Bojan", rating: 5.0, biography: "Sem invalidna oseba. Rad nakupujem.", comments: [ Comment.generate(), Comment.generate(), Comment.generate() ]),
		User(name: "Jure", rating: 2.5, biography: "Nimam pojma kaj delam, ampak bom naredil faks.", comments: [ Comment.generate(), Comment.generate(), Comment.generate(), Comment.generate() ])
	]
	
	return users[Int.random(in: 0..<users.count)]
}

class DataManager: ObservableObject {
	
	static let shared = DataManager()
	
	@Published var events: [Event]
	
	init () {
		self.events = [
			Event(
				type: .food,
				author: pickRandomUser(),
				title: "Kosilo",
				description: "Želim si družbe pri kosilu. Če te več zanima o meni, si poglej moj profil.",
				payment: MonetaryValue(currency: .eur, value: 10),
				position: CLLocationCoordinate2D(latitude: 46.054072, longitude: 14.512543),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1732280400), end: Date(timeIntervalSince1970: 1732282200)),
				postDate: Date(timeIntervalSince1970: 1732279985)
			),
			Event(
				type: .help,
				author: pickRandomUser(),
				title: "Pomoč pri premikanju pohištva",
				description: "Potrebovala bi kakšnega čvrstega moškega za pomoč pri premikanju novega lesenga pohištva :)",
				payment: MonetaryValue(currency: .eur, value: 60),
				position: CLLocationCoordinate2D(latitude: 46.039161, longitude: 14.490042),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1729004400), end: Date(timeIntervalSince1970: 1729011600)),
				postDate: Date(timeIntervalSince1970: 1729005068)
			),
			Event(
				type: .shopping,
				author: pickRandomUser(),
				title: "Pomoč pri nošenju nakupov",
				description: "Potreboval bi pomoč pri nošenju nakupljenega blaga, saj sem invalidna oseba.",
				payment: MonetaryValue(currency: .eur, value: 30),
				position: CLLocationCoordinate2D(latitude: 46.06793, longitude: 14.54191),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1731514500), end: Date(timeIntervalSince1970: 1731519000)),
				postDate: Date(timeIntervalSince1970: 1731481697)
			),
			Event(
				type: .education,
				author: pickRandomUser(),
				title: "Izpit iz programiranja",
				description: "Potreboval bi nekoga, da lahko namesto mene piše izpit iz programiranja, saj nimam pojma kaj delam.",
				payment: MonetaryValue(currency: .eur, value: 200),
				position: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
				dateInterval: DateInterval(start: Date(timeIntervalSince1970: 1733985000), end: Date(timeIntervalSince1970: 1733988600)),
				postDate: Date(timeIntervalSince1970: 1733949762)
			)
		]
	}
	
	
}
