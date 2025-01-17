//
//  EventSearchView.swift
//  Aplikacija
//
//  Created on 10. 1. 25.
//

import SwiftUI

struct EventSearchView: View {
	
	@ObservedObject private var dataManager = DataManager.shared
	
	@State private var navigation: Int? = 0
	
	var body: some View {
		NavigationStack {
			VStack {
				
				Heading(text: "Iskalnik")
								
				ScrollView {
					VStack {
						ForEach($dataManager.events) { $event in
							EventCard(event: event)
						}
					}
				}
				
				Spacer()
				
				NavigationLink(destination: EventCreatorView(), tag: 1, selection: $navigation) {
					EmptyView()
				}
				
				Button("Dodaj objavo", systemImage: "plus") {
					navigation = 1
				}
				.buttonStyle(PrimaryButtonStyle())
				
			}
			.padding([ .leading, .top, .trailing ], 10)
		}
	}
}

#Preview {
	EventSearchView()
}
