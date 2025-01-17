//
//  EventSearchView.swift
//  Aplikacija
//
//  Created on 10. 1. 25.
//

import SwiftUI

struct EventSearchView: View {
	
	@Environment(\.presentationMode) private var presentationMode
	@StateObject private var viewModel: EventSearchViewModel = .init()
	
	var body: some View {
		NavigationStack {

			Heading(text: "Iskalnik")
			
//			TextField("Išči...", text: $viewModel.searchQuery)
//				.padding([ .top, .bottom ], 8)
//				.padding([ .leading, .trailing ], 8)
//				.background(Color.gray.opacity(0.1))
//				.cornerRadius(10)
//				.padding([ .leading, .bottom, .trailing ], 10)

			HStack {
				
//				Text("Sortiraj po")
				
				Spacer()
				
				Button(action: {
					viewModel.toggleSortOrder()
				}) {
					HStack {

						Text(viewModel.sortOrder.getLabel())
						
						Image(systemName: viewModel.sortOrder.getIcon())
							.font(.system(size: 20))
					}
				}
				
			}
			.padding([ .leading, .trailing ], 10)
				
			VStack {
				ZStack {
					
					ScrollView {
						VStack {
							if viewModel.sortedEvents.count > 0 {
								ForEach(viewModel.sortedEvents) { event in
									EventCard(event: event)
								}
							} else {
								Text("Trenutno ni nobene objave")
							}
						}
					}
					
					VStack {
						Spacer()
						Button("Dodaj objavo", systemImage: "plus") {
							viewModel.navigation = 1
						}
						.buttonStyle(PrimaryButtonStyle())
						.padding(.bottom, 10)
					}
				}
			}
			.padding([ .leading, .trailing ], 10)
			.padding(.top, 5)
			.refreshable {
				await viewModel.fetchEvents()
			}
			
			NavigationLink(
				destination: EventCreatorView(onEventAdded: { _ in
					viewModel.navigation = 0
					presentationMode.wrappedValue.dismiss()
				}),
				tag: 1,
				selection: $viewModel.navigation
			) {
				EmptyView()
			}
			
		}
		.searchable(text: $viewModel.searchQuery, prompt: "Išči")
		.onChange(of: viewModel.sortedEvents) { newSortedEvents in
			print("Posodobil se je seznam: \(newSortedEvents.map { $0.title })")
		}
		.onDisappear {
			print("Nisem več aktiven")
		}
		.onAppear {
			print("Aktiven sem")
		}
	}
}

#Preview {
	EventSearchView()
}
