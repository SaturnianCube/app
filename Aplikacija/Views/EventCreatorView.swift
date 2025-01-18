//
//  EventCreatorView.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI
import MapKit

struct EventCreatorView: View {
		
	@StateObject private var viewModel: EventCreatorViewModel = .init()
		
    var body: some View {
		ZStack {
			
			VStack {
				
				Heading(text: "Dodaj objavo")
				
				Form {
					
					TextField("Naslov objave", text: $viewModel.inputTitle)
					
					TextField("Kratek opis", text: $viewModel.inputDescription)

					HStack {
						Picker("Kategorija", selection: $viewModel.inputType) {
							ForEach(EventType.allCases, id: \.self) { eventType in
								Text(eventType.getName()).tag(eventType)
							}
						}
					}
					
					HStack {
						Text("Nagrada")
						Spacer()
						TextField("Nagrada", value: $viewModel.inputPayment, format: .number)
							.keyboardType(.numberPad)
							.multilineTextAlignment(.trailing)
						Text(Currency.eur.getSymbol())
					}
					
					Section(header: Text("Datum in čas")) {
						DatePicker(
							"Začetek",
							selection: $viewModel.inputStartDate,
							displayedComponents: [ .date, .hourAndMinute ]
						)
						DatePicker(
							"Konec",
							selection: $viewModel.inputEndDate,
							displayedComponents: [ .date, .hourAndMinute ]
						)
					}
					
				}
				.alert(isPresented: $viewModel.shouldShowError) {
					Alert(title: Text("Napaka"), message: Text(viewModel.errorMessage))
				}
				
				Button("Objavi", systemImage: "plus") {
					
				}
				.buttonStyle(PrimaryButtonStyle())
			}.disabled(viewModel.isLoading)
			
			if viewModel.isLoading {
				LoadingBuffer()
			}
		}
	}
}

#Preview {
    EventCreatorView()
}
