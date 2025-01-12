//
//  EventSearchView.swift
//  Aplikacija
//
//  Created on 10. 1. 25.
//

import SwiftUI

struct EventSearchView: View {
	
	@ObservedObject var dataManager = DataManager.shared
	
	var body: some View {
		NavigationView {
			VStack {
				
				HStack {
					Text("Iskalnik").font(.largeTitle).fontWeight(.bold)
					Spacer()
				}
				
				ScrollView {
					VStack {
						ForEach($dataManager.events) { $event in
							EventCard(event: event)
						}
					}
				}
				
				Spacer()
				
				Button("Dodaj", systemImage: "plus") {
					
				}
					.buttonStyle(.borderedProminent)
					.font(.system(size: 25))
					.fontWeight(.bold)
					.padding([.top ], 30)
				
			}
			.padding([ .leading, .top, .trailing ], 10)
		}
	}
}

#Preview {
	EventSearchView()
}
