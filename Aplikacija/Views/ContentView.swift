//
//  ContentView.swift
//  Aplikacija
//
//  Created on 10. 10. 24.
//

import SwiftUI
import MapKit

struct ContentView: View {
	
	@ObservedObject private var dataManager = DataManager.shared
	
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
			
		}.onAppear {			
			Task {
				dataManager.currentUser = await User.fetchById(id: "EVUYpzqMpbzMjCBwA6Fd")
				dataManager.events = await Event.fetchAll()
			}
		}
	}

}

#Preview {
	ContentView()
}
