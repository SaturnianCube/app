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
		NavigationLink(destination: EventInfo(event: event)) {
			HStack {
				Image(systemName: event.type.getIcon())
					.resizable()
					.scaledToFit()
					.frame(width: 30, height: 30, alignment: .center)
				VStack {
					
					Text("\(event.title)")
						.fontWeight(.bold)
						.frame(maxWidth: .infinity, alignment: .leading)

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
	EventCard(event: Event.generate())
}
