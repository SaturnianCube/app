//
//  MapView.swift
//  Aplikacija
//
//  Created on 10. 1. 25.
//

import SwiftUI
import MapKit

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	
	var locationManager: CLLocationManager?
	
	@Published var mapRegion: MKCoordinateRegion
	
	override init () {
		self.mapRegion = MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
			span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
		)
	}
	
	var binding: Binding<MKCoordinateRegion> {
		Binding {
			self.mapRegion
		} set: { newRegion in
			self.mapRegion = newRegion
		}
	}
	
	func checkLocationEnabled () {
		if CLLocationManager.locationServicesEnabled() {
			locationManager = CLLocationManager()
			locationManager?.desiredAccuracy = kCLLocationAccuracyBest
			locationManager!.delegate = self
		}
	}
	
	func locationManagerDidChangeAuthorization (_ manager: CLLocationManager) {
		let previousAuthorizationStatus = manager.authorizationStatus
		manager.requestWhenInUseAuthorization()
		if manager.authorizationStatus != previousAuthorizationStatus {
			checkLocationAuthorization()
		}
	}

	private func checkLocationAuthorization () {
		
		guard let location = locationManager else {
			return
		}

		switch location.authorizationStatus {
		case .notDetermined:
			print("Location authorization is not determined.")
		case .restricted:
			print("Location is restricted.")
		case .denied:
			print("Location permission denied.")
		case .authorizedAlways, .authorizedWhenInUse:
			if let location = location.location {
				mapRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
			}

		default:
			break
		}
	}
	
}

struct MapView: View {
	
	@ObservedObject var dataManager = DataManager.shared
	
	@StateObject var viewModel = ContentViewModel()
	
	var body: some View {
		Map {
			ForEach(dataManager.events) { event in
				Marker(event.title, systemImage: event.type.getIcon(), coordinate: event.position)
			}
		}
	}
}

#Preview {
    MapView()
}
