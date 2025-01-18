//
//  EventInfo.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import SwiftUI
import MapKit

struct EventInfoView: View {
	
	@ObservedObject private var viewModel: EventInfoViewModel
	
	init (event: Event) {
		_viewModel = .init(wrappedValue: .init(event: event))
	}
	
	var event: Event {
		return viewModel.event
	}
	
	var user: User {
		return viewModel.user
	}
	
	var body: some View {
		NavigationStack {
				
//			Heading(text: "Objava")
			
			VStack {
				
				HStack {
					Image(systemName: event.type.getIcon())
						.resizable()
						.scaledToFit()
						.frame(width: 30, height: 30, alignment: .leading)
					Text(event.title)
						.frame(maxWidth: .infinity, alignment: .leading)
						.font(.largeTitle)
						.bold()
				}
				
				HStack {
					Image(systemName: "person.crop.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25, alignment: .leading)
					NavigationLink(user.name) {
						UserInfoView(user: user)
					}
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				HStack {
					Image(systemName: "calendar")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25, alignment: .leading)
					Text(FormatterFactory.dateFormatter.string(from: event.dateInterval.start))
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				HStack {
					Image(systemName: "clock")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25, alignment: .leading)
					Text("\(FormatterFactory.timeIntervalFormatter.string(from: event.dateInterval.start, to: event.dateInterval.end))")
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				if let payment = event.payment {
					HStack {
						Image(systemName: "banknote")
							.resizable()
							.scaledToFit()
							.frame(width: 25, height: 25, alignment: .leading)
						Text(payment.value, format: .currency(code: "EUR"))
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				
				Text(event.description)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				Map(position: $viewModel.mapCameraPosition) {
					Marker(event.title, systemImage: event.type.getIcon(), coordinate: event.position.asCLLocationCoordinate2D)
				}
				.frame(maxWidth: .infinity, maxHeight: 400)
				.cornerRadius(5)
				
				Button("Sprejmi", systemImage: "checkmark.circle") {
					
				}
					.buttonStyle(PrimaryButtonStyle())
					.padding([.top ], 30)
				
				Spacer()
			}
				.frame(width: .infinity)
				.padding([ .top ], 20)
				.padding([ .leading, .trailing ], 15)
				.presentationDragIndicator(.visible)
				.onChange(of: event, initial: true) {
					viewModel.updatePosition()
				}
				.navigationDestination(for: User.self) { user in
					UserInfoView(user: user)
				}
		}.onAppear {
			Task {
				await viewModel.fetchUser()
			}
		}
	}
	
}

#Preview {
	EventInfoView(event: Event.generateDummy())
}
