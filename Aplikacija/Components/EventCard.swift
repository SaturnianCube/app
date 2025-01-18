//
//  EventCard.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI
import MapKit

struct EventCard: View {
	
	@State var event: Event

	private let dateFormatter = FormatterFactory.dateFormatter
	private let timeFormatter = FormatterFactory.timeFormatter
	private let timeIntervalFormatter = FormatterFactory.timeIntervalFormatter	
	
    var body: some View {
		NavigationLink(destination: EventInfoView(event: event)) {
			HStack {
				
				Image(systemName: event.type.getIcon())
					.resizable()
					.scaledToFit()
					.frame(width: 30, height: 30, alignment: .center)
				
				VStack {
					Text("\(event.title)")
						.fontWeight(.bold)
						.frame(maxWidth: .infinity, alignment: .leading)
						.multilineTextAlignment(.leading)
				}
				
				Spacer()
				
				if let payment = event.payment {
					HStack {
						Image(systemName: "banknote")
							.resizable()
							.scaledToFit()
							.frame(width: 25, height: 25)
						Text(payment.value, format: .currency(code: "EUR"))
					}
				}
				
			}
			.frame(maxWidth: .infinity)
			.padding([ .leading, .trailing ], 15)
			.padding([ .top, .bottom ], 5)
			.background(Color(UIColor.secondarySystemBackground))
			.cornerRadius(5)
		}
	}
}

#Preview {
	EventCard(event: Event.generateDummy())
}
