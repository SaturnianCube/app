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
	@Published var userLocation: CLLocationCoordinate2D?
	
	override init () {
		self.mapRegion = MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
			span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
		)
		super.init()
		checkLocationEnabled()
	}
	
	var binding: Binding<MKCoordinateRegion> {
		Binding {
			self.mapRegion
		} set: { newRegion in
			self.mapRegion = newRegion
		}
	}
	
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

	
}

struct MapView: View {
	
	@ObservedObject var dataManager = DataManager.shared
	
	@StateObject var viewModel = ContentViewModel()
	
	@State private var selectedEvent: Event?
	@State var mapRegion = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 46.050152, longitude: 14.468941),
		   span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
	   )
	
	var body: some View {
		NavigationStack {
			Map(coordinateRegion: viewModel.binding, showsUserLocation: true, annotationItems: dataManager.events) { event in
				MapAnnotation(coordinate: event.position.asCLLocationCoordinate2D) {
					Button(action: {
						selectedEvent = event
					}) {
						ZStack {
							Circle()
								.fill(event.type.getColor())
								.frame(width: 40, height: 40)
							Image(systemName: event.type.getIcon())
								.resizable()
								.foregroundColor(.white)
								.aspectRatio(contentMode: .fit)
								.frame(width: 25, height: 25)
						}
					}
					.buttonStyle(ScaleEffectButtonStyle())
				}
			}
			.ignoresSafeArea([ .container ], edges: .top)
			
//			if let userLocation = viewModel.userLocation {
//				MapAnnotation(coordinate: userLocation) {
//					ZStack {
//						Circle()
//							.fill(Color.blue)
//							.frame(width: 40, height: 40)
//						Image(systemName: "location.fill")
//							.resizable()
//							.foregroundColor(.white)
//							.aspectRatio(contentMode: .fit)
//							.frame(width: 25, height: 25)
//					}
//				}
//			}
		}
		.sheet(item: $selectedEvent, onDismiss: dismissEventSheet) { event in
			EventInfoView(event: event)
		}
	}

	func dismissEventSheet () {
		selectedEvent = nil
	}
}

#Preview {
    MapView()
}
