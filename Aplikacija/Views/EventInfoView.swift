//
//  EventInfo.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import SwiftUI
import MapKit

struct EventInfoView: View {
	
	@Environment(\.presentationMode) private var presentationMode
	
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
				
			Heading(text: event.title)
			
			VStack {
				
//				HStack {
//					Image(systemName: event.type.getIcon())
//						.resizable()
//						.scaledToFit()
//						.frame(width: 30, height: 30, alignment: .leading)
//					Text(event.title)
//						.frame(maxWidth: .infinity, alignment: .leading)
//						.font(.largeTitle)
//						.bold()
//				}
				
				HStack {
					
					VStack(spacing: 5) {
						
						HStack {
							Image(systemName: "person.crop.circle")
								.font(.system(size: 25))
							NavigationLink(user.name) {
								UserInfoView(user: user)
							}
							.frame(maxWidth: .infinity, alignment: .leading)
						}
						
						HStack {
							Image(systemName: event.type.getIcon())
								.font(.system(size: 20))
							Text(event.type.getName())
								.frame(maxWidth: .infinity, alignment: .leading)

						}
						
						if let payment = event.payment {
							HStack {
								Image(systemName: "banknote")
									.font(.system(size: 20))
								Text(payment.value, format: .currency(code: "EUR"))
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						}
						
					}
					
					Spacer()
					
					VStack(spacing: 5) {
						
						HStack {
							Image(systemName: "calendar")
								.font(.system(size: 25))
							Text(FormatterFactory.dateFormatter.string(from: event.dateInterval.start))
								.frame(maxWidth: 110, alignment: .trailing)
						}
						
						HStack {
							Image(systemName: "clock")
								.font(.system(size: 25))
							Text("\(FormatterFactory.timeIntervalFormatter.string(from: event.dateInterval.start, to: event.dateInterval.end))")
								.frame(maxWidth: 110, alignment: .trailing)
						}
						
					}
					
				}
				
				Text(event.description)
					.padding(7)
					.frame(maxWidth: .infinity, alignment: .leading)
					.background(Color(.systemGroupedBackground))
					.cornerRadius(5)
				
				Map(position: $viewModel.mapCameraPosition) {
					Marker(event.title, systemImage: event.type.getIcon(), coordinate: event.position.asCLLocationCoordinate2D)
				}
				.frame(maxWidth: .infinity, maxHeight: 400)
				.cornerRadius(5)
				
				Button("Sprejmi", systemImage: "checkmark.circle") {
					Task {
						if await viewModel.accept() {
							presentationMode.wrappedValue.dismiss()
						}
					}
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
