//
//  EventSearchView.swift
//  Aplikacija
//
//  Created on 10. 1. 25.
//

import SwiftUI

struct EventSearchView: View {
	
	@StateObject private var viewModel: EventSearchViewModel = .init()
	
	var body: some View {
		NavigationStack {

			Heading(text: "Iskalnik")

			HStack {
				
				Spacer()
				
				Button(action: {
					viewModel.toggleSortOrder()
				}) {
					
					Text(viewModel.sortOrder.getLabel())
					
					Image(systemName: viewModel.sortOrder.getIcon())
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25)
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
				
				
				NavigationLink(destination: EventCreatorView(), tag: 1, selection: $viewModel.navigation) {
					EmptyView()
				}
			}
			.padding([ .leading, .top, .trailing ], 10)
		}
	}
}

#Preview {
	EventSearchView()
}
