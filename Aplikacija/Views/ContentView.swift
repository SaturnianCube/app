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
	
	var body: some View {
		TabView {
						
			MapView()
				.tabItem {
					Label("Zemljevid", systemImage: "mappin.and.ellipse")
				}
				.badge(dataManager.events.count)
			
			EventSearchView()
				.tabItem {
					Label("Iskalnik", systemImage: "magnifyingglass")
				}
			
			ProfileView()
				.tabItem {
					Label("Profil", systemImage: "person")
				}
			
		}
	}

}

#Preview {
	ContentView()
}


/*
 
 //	@State private var isSheetVisible: Bool = true
 //	@State private var viewingEvent: Event? = nil
 
 .sheet(isPresented: $isSheetVisible) {
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
		 .presentationDetents([ .fraction(0.1), .medium, .large ])
		 .interactiveDismissDisabled()
	 
	 .sheet(item: $viewingEvent) { event in
		 EventInfo(event: event)
	 }
 }
 */
