//
//  MapViewModel.swift
//  Aplikacija
//
//  Created on 16. 1. 25.
//

import Foundation
import SwiftUI
import MapKit

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	
	@ObservedObject private var dataManager = DataManager.shared
	
	// Map Manager
	private var locationManager: CLLocationManager?
	@Published var userLocation: CLLocationCoordinate2D?
	@Published var mapRegion = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
		span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
	)
	
	// UI State
	@Published var selectedEvent: Event?
	
	var events: [Event] {
		return dataManager.events
	}
	
	var binding: Binding<MKCoordinateRegion> {
		Binding {
			self.mapRegion
		} set: { newRegion in
			self.mapRegion = newRegion
		}
	}
	
	override init () {
		self.mapRegion = MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
			span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
		)
		super.init()
		checkLocationEnabled()
	}
	
	// Map Manager methods
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkLocationAuthorization()
	}

	private func checkLocationEnabled() {
		
		guard CLLocationManager.locationServicesEnabled() else {
			print("Location services are not enabled.")
			return
		}
				locationManager = CLLocationManager()
		locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		locationManager?.delegate = self
		locationManager?.requestWhenInUseAuthorization()
	}

	private func checkLocationAuthorization() {

		guard let locationManager = locationManager else {
			return
		}
		
		DispatchQueue.main.async { [weak self] in
			switch locationManager.authorizationStatus {
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .restricted:
				print("Location access is restricted.")
				
			case .denied:
				print("Location access was denied.")
				
			case .authorizedAlways, .authorizedWhenInUse:
				if let location = locationManager.location {
					self?.userLocation = location.coordinate
					self?.mapRegion = MKCoordinateRegion(
						center: location.coordinate,
						span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
					)
				}
				
			@unknown default:
				print("Unknown authorization status.")
			}
		}
	}
	
	// UI Methods
	
	func dismissEventSheet () {
		selectedEvent = nil
	}

	
}
