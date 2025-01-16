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
	@State var inputEndDate: Date = Date().advanced(by: TimeInterval(10 * 60))
	
	@State var errorMessage: String = "" {
		didSet { shouldShowError = !errorMessage.isEmpty }
	}
	@State var shouldShowError: Bool = false
	@State var isLoading: Bool = false
	
    var body: some View {
		ZStack {
			
			VStack {
				
				Heading(text: "Dodaj objavo")
				
				Form {
					
					TextField("Naslov objave", text: $inputTitle)
					
					TextField("Kratek opis", text: $inputDescription)

					HStack {
						Picker("Kategorija", selection: $inputType) {
							ForEach(EventType.allCases, id: \.self) { eventType in
								Text(eventType.getName()).tag(eventType)
							}
						}
					}
					
					HStack {
						Text("Nagrada")
						Spacer()
						TextField("Nagrada", value: $inputPayment, format: .number)
							.keyboardType(.numberPad)
							.multilineTextAlignment(.trailing)
						Text(Currency.eur.getSymbol())
					}
					
					Section(header: Text("Datum in čas")) {
						DatePicker(
							"Začetek",
							selection: $inputStartDate,
							displayedComponents: [ .date, .hourAndMinute ]
						)
						DatePicker(
							"Konec",
							selection: $inputEndDate,
							displayedComponents: [ .date, .hourAndMinute ]
						)
					}
					
				}
				.alert(isPresented: $shouldShowError) {
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
						errorMessage = "Datum in čas začetka ne smeta biti v preteklosti"
						return
					}
					
					if inputEndDate < inputStartDate.addingTimeInterval(10 * 60) {
						errorMessage = "Interval trajanja mora biti vsaj 10 minut"
						return
					}
					
					isLoading = true
						
//					let result = dataManager.addEvent(event: Event(
//						type: inputType,
//						user: user,
//						title: inputTitle,
//						description: inputDescription,
//						payment: inputPayment > 0
//							? MonetaryValue(currency: .eur, value: Decimal(inputPayment))
//							: nil,
//						position: Coordinate(coordinate: CLLocationCoordinate2D()),
//						dateInterval: DateInterval(start: inputStartDate, end: inputEndDate),
//						postDate: Date()
//					))
//					
//					isLoading = false
//					
//					if result {
//						presentationMode.wrappedValue.dismiss()
//					} else {
//						errorMessage = "Objava ni bila uspešno ustvarjena"
//					}
				}
				.buttonStyle(PrimaryButtonStyle())
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
