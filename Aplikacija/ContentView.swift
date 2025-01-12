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
			let _ = print("\(dataManager.events.count)")
			
			MapView()
				.tabItem {
					Label("Zemljevid", systemImage: "mappin.and.ellipse")
				}
				.badge(dataManager.events.count )
			
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

