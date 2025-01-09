//
//  ContentView.swift
//  Aplikacija
//
//  Created on 10. 10. 24.
//

import SwiftUI
import MapKit

struct ContentView: View {
	
	@ObservedObject var dataManager = DataManager.shared
	
	@State private var isSheetVisible: Bool = true
	@State private var viewingEvent: Event? = nil
	
	var body: some View {
		Map {
			ForEach(dataManager.events) { event in
				Marker(event.title, systemImage: event.type.getIcon(), coordinate: event.position)
			}
		}.sheet(isPresented: $isSheetVisible) {
			VStack {
				
				Text("Iskana pomoč")
					.font(.largeTitle)
					.bold()
					.frame(maxWidth: .infinity, alignment: .leading)
				
				ForEach($dataManager.events) { $event in
					Button {
						viewingEvent = event
					} label: {
						HStack {
							Image(systemName: event.type.getIcon())
								.resizable()
								.scaledToFit()
								.frame(width: 30, height: 30, alignment: .center)
							Text("\(event.title)")
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						.frame(maxWidth: .infinity)
						.padding([ .leading, .trailing ], 15)
						.padding([ .top, .bottom ], 5)
						.background(Color(UIColor.secondarySystemBackground))
						.cornerRadius(5)
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
				.padding([ .top ], 20)
				.padding([ .leading, .trailing ], 15)
				.presentationDetents([ .medium, .large ])
				.interactiveDismissDisabled()
			
			.sheet(item: $viewingEvent) { event in
				EventInfo(event: event)
			}
		}
	}

}

#Preview {
	ContentView()
}
