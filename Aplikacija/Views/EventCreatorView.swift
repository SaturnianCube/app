//
//  EventCreatorView.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI
import MapKit

struct EventCreatorView: View {
	
	let dataManager = DataManager.shared
	
	@Environment(\.presentationMode) var presentationMode
	
	@State var inputTitle: String = ""
	@State var inputDescription: String = ""
	@State var inputType: EventType = .help
	@State var inputPayment: UInt = 0
	@State var inputStartDate: Date = Date()
	@State var inputEndDate: Date = Date()
	
	@State var errorMessage: String = "" {
		didSet { shouldShowError = !errorMessage.isEmpty }
	}
	@State var shouldShowError: Bool = false
	@State var isLoading: Bool = false
	
    var body: some View {
		ZStack {
			
			VStack {
				
				Heading(text: "Dodaj objavo")
				
				List {
					Picker("Tip pomoči", selection: $inputType) {
						ForEach(EventType.allCases, id: \.self) { eventType in
							Text(eventType.getName()).tag(eventType)
						}
					}
					TextField("Naslov objave", text: $inputTitle)
					TextField("Opis", text: $inputDescription)
					HStack {
						Text("Cena")
						TextField("Cena", value: $inputPayment, format: .number)
							.keyboardType(.numberPad)
							.multilineTextAlignment(.trailing)
						Text(Currency.eur.getSymbol())
					}
					DatePicker(
						"Začetni datum",
						selection: $inputStartDate,
						displayedComponents: [ .date, .hourAndMinute ]
					)
					DatePicker(
						"Končni datum",
						selection: $inputEndDate,
						displayedComponents: [ .date, .hourAndMinute ]
					)
				}.alert(isPresented: $shouldShowError) {
					Alert(title: Text("Napaka"), message: Text(errorMessage))
				}
				
				Button("Objavi", systemImage: "plus") {
					
					guard let user = dataManager.currentUser else {
						errorMessage = "Za ustvarjanje objav morate biti prijavljeni"
						return
					}
					
					if inputTitle.isEmpty {
						errorMessage = "Naslov objave ne sme biti prazen"
						return
					}
					
					if inputDescription.isEmpty {
						errorMessage = "Opis ne sme biti prazen"
						return
					}
					
					if inputStartDate < Date() {
						errorMessage = "Začetni datum mora biti v prihodnosti"
						return
					}
					
					if inputEndDate < (inputStartDate.addingTimeInterval(60 * 10)) {
						errorMessage = "Interval trajanja mora biti vsaj 10 minut"
						return
					}
					
					isLoading = true

					Task {
						
						let result = await dataManager.addEvent(event: Event(
							type: inputType,
							user: user,
							title: inputTitle,
							description: inputDescription,
							payment: inputPayment > 0
							? MonetaryValue(currency: .eur, value: Decimal(inputPayment))
							: nil,
							position: CLLocationCoordinate2D(),
							dateInterval: DateInterval(start: inputStartDate, end: inputEndDate),
							postDate: Date()
						))
						
						isLoading = false
						
						if result {
							presentationMode.wrappedValue.dismiss()
						} else {
							errorMessage = "Objava ni bila uspešno objavljena"
						}
					}
				}
			}.disabled(isLoading)
			
			if isLoading {
				LoadingBuffer()
			}
		}
	}
}

#Preview {
    EventCreatorView()
}
