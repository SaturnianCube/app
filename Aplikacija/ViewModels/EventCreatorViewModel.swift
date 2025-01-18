//
//  EventCreatorViewModel.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import SwiftUI
import MapKit

@MainActor
class EventCreatorViewModel: CreatorViewModel {

	@Environment(\.presentationMode) private var presentationMode
	@ObservedObject private var dataManager: DataManager = DataManager.shared
		
	// UI Inputs
	@State var inputTitle: String = ""
	@State var inputDescription: String = ""
	@State var inputType: EventType = .help
	@State var inputPayment: UInt = 0
	@State var inputStartDate: Date = Date()
	@State var inputEndDate: Date = Date().advanced(by: TimeInterval(10 * 60))
	
	func submit () async {
		
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
		
		isLoading = true

		var event = Event(
			type: inputType,
			user: User.getRefById(id: currentUser.id!),
			title: inputTitle,
			description: inputDescription,
			payment: inputPayment > 0
				? MonetaryValue(currency: .eur, value: Decimal(inputPayment))
				: nil,
			position: Coordinate(coordinate: CLLocationCoordinate2D()),
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
