//
//  EventInfoViewModel.swift
//  Aplikacija
//
//  Created on 18. 1. 25.
//

import Foundation
import SwiftUI
import MapKit

@MainActor
class EventInfoViewModel: ObservableObject {
	
	@ObservedObject private var dataManager: DataManager = .shared
	
	// Inputs
	let event: Event
	
	// State
	@Published var user: User = User.generateDummy()
	@Published var mapCameraPosition: MapCameraPosition = .camera(
		MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1)
	)
	
	init (event: Event) {
		self.event = event
	}
		
	func fetchUser () async {
		let user = await User.fetchByRef(ref: event.user)
		if let user = user {
			self.user = user
		}
	}

	func updatePosition () {
		mapCameraPosition = .camera(MapCamera(
			centerCoordinate: event.position.asCLLocationCoordinate2D,
			distance: 500
		))
	}
	
	func accept () async -> Bool {
		
		let event = self.event
				
		if await event.delete() {
			await MainActor.run {
				dataManager.removeEvent(event: event)
			}
			return true
		}
		
		return false
	}
	
}
