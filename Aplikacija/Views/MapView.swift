//
//  MapView.swift
//  Aplikacija
//
//  Created on 10. 1. 25.
//

import SwiftUI
import MapKit

struct MapView: View {
	
	@StateObject var viewModel: MapViewModel = .init()
	
	var body: some View {
		NavigationStack {
			Map(coordinateRegion: viewModel.binding, showsUserLocation: true, annotationItems: viewModel.events) { event in
				MapAnnotation(coordinate: event.position.asCLLocationCoordinate2D) {
					Button(action: {
						viewModel.selectedEvent = event
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
		}
		.sheet(item: $viewModel.selectedEvent, onDismiss: viewModel.dismissEventSheet) { event in
			EventInfoView(event: event)
		}
	}
}

#Preview {
    MapView()
}
