//
//  EventCreatorViewModel.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import SwiftUI
import MapKit

class EventCreatorViewModel: CreatorViewModel {

	@Environment(\.presentationMode) private var presentationMode
	@ObservedObject private var dataManager: DataManager = .shared
		
	// UI Inputs
	@Published var inputTitle: String = ""
	@Published var inputDescription: String = ""
	@Published var inputType: EventType = .help
	@Published var inputPayment: UInt = 0
	@Published var inputStartDate: Date = Date()
	@Published var inputEndDate: Date = Date().advanced(by: TimeInterval(10 * 60))
	
	func submit (mapModel: MapViewModel) async {
		
		guard let currentUser = dataManager.currentUser else {
			errorMessage = "Niste prijavljeni"
			return
		}
		
		guard !inputTitle.isEmpty else {
			errorMessage = "Naslov objave ne sme biti prazen"
			return
		}
		
		guard !inputDescription.isEmpty else {
			errorMessage = "Opis ne sme biti prazen"
			return
		}
		
		guard inputStartDate >= Date() else {
			errorMessage = "Datum in čas začetka ne smeta biti v preteklosti"
			return
		}
		
		guard inputEndDate >= inputStartDate.addingTimeInterval(10 * 60) else {
			errorMessage = "Interval trajanja mora biti vsaj 10 minut"
			return
		}
		
		guard let userLocation = mapModel.userLocation else {
			errorMessage = "Lokacija ni izbrana"
			return
		}
		
		isLoading = true

		var event = Event(
			type: inputType,
			user: User.getRefById(id: currentUser.id!),
			title: inputTitle,
			description: inputDescription,
			payment: inputPayment > 0
				? MonetaryValue(currency: .eur, value: Decimal(inputPayment))
				: nil,
			position: Coordinate(coordinate: userLocation),
			dateInterval: DateInterval(start: inputStartDate, end: inputEndDate)
		)
		
		let res = await event.create()		

		isLoading = false

		if let res = res {
			dataManager.addEvent(event: res)
			presentationMode.wrappedValue.dismiss()
		} else {
			errorMessage = "Nekaj je šlo narobe pri ustvarjanju objave"
		}
		
	}

}
