//
//  EventCard.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI

struct EventCard: View {
	
	let dateFormatter = FormatterFactory.dateFormatter
	let timeFormatter = FormatterFactory.timeFormatter
	let timeIntervalFormatter = FormatterFactory.timeIntervalFormatter
	
	@State var event: Event
	
    var body: some View {
		Button {
			
		} label: {
			HStack {
				Image(systemName: event.type.getIcon())
					.resizable()
					.scaledToFit()
					.frame(width: 30, height: 30, alignment: .center)
				VStack {
					
					Text("\(event.title)")
						.fontWeight(.bold)
						.frame(maxWidth: .infinity, alignment: .leading)
					
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
					
					HStack {
						
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
    EventCard()
}
