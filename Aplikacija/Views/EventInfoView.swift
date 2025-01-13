//
//  EventInfo.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import SwiftUI
import MapKit

struct EventInfoView: View {
	
	@State var event: Event
	@State private var position: MapCameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1))
	
	private let dateFormatter = DateFormatter()
	private let timeFormatter = DateComponentsFormatter()
	private let timeIntervalFormatter = DateIntervalFormatter()
	
	init (event: Event) {
		
		self.event = event
		
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		
		timeFormatter.unitsStyle = .abbreviated
		timeFormatter.allowedUnits = [ .hour, .minute ]
		
		timeIntervalFormatter.dateStyle = .none
		timeIntervalFormatter.timeStyle = .short
	}

	func updatePosition () {
		position = .camera(MapCamera(
			centerCoordinate: event.position,
			distance: 500
		))
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
					NavigationLink(event.user.name, value: event.user)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				HStack {
					Image(systemName: "calendar")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25, alignment: .leading)
					Text(dateFormatter.string(from: event.dateInterval.start))
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				HStack {
					Image(systemName: "clock")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25, alignment: .leading)
					Text("\(timeIntervalFormatter.string(from: event.dateInterval.start, to: event.dateInterval.end)) (\(timeFormatter.string(from: event.dateInterval.duration) ?? "?"))")
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
				
				Map(position: $position) {
					Marker(event.title, systemImage: event.type.getIcon(), coordinate: event.position)
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
					updatePosition()
				}
				.navigationDestination(for: User.self) { user in
					UserInfoView(user: user)
				}
		}
	}
	
}

#Preview {
	EventInfoView(event: Event.generate())
}
