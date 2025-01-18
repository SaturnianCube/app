//
//  EventCreatorView.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI
import MapKit

struct EventCreatorView: View {
		
	@StateObject private var viewModel: EventCreatorViewModel
	@StateObject private var mapModel: MapViewModel = .init()
	@Environment(\.dismiss) private var dismiss
	
	init (onEventAdded: @escaping ((Event) -> Void)) {
		_viewModel = .init(wrappedValue: .init(onEventAdded: onEventAdded))
	}
	
    var body: some View {
		ZStack {
			
			Color(.systemGroupedBackground)
				.edgesIgnoringSafeArea(.all)
			
			Heading(text: "Dodaj objavo")
			
			VStack {
				
				Form {
					
					TextField("Naslov objave", text: $viewModel.inputTitle)
					
					TextField("Kratek opis", text: $viewModel.inputDescription, axis: .vertical)
						.lineLimit(1...5)

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
				.padding(.bottom, 5)
				.alert(isPresented: $viewModel.shouldShowError) {
					Alert(title: Text("Napaka"), message: Text(viewModel.errorMessage))
				}
				
				Map(coordinateRegion: $mapModel.mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none)
					.padding([ .leading, .trailing], 20)
					.frame(maxWidth: .infinity, maxHeight: 180)
					.cornerRadius(5)
				
				Button("Objavi", systemImage: "plus") {
					Task {
						if await viewModel.submit(mapModel: mapModel) {
							dismiss()
						}
					}
				}
				.buttonStyle(PrimaryButtonStyle())
				
			}
			.disabled(viewModel.isLoading)
			.ignoresSafeArea(.keyboard)
			
			if viewModel.isLoading {
				LoadingBuffer()
			}
		}
		.onAppear {
			
		}
	}
}

#Preview {
	EventCreatorView(onEventAdded: { _ in })
}
