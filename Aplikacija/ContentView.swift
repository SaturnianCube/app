//
//  ContentView.swift
//  Aplikacija
//
//  Created on 10. 10. 24.
//

import SwiftUI
import MapKit

struct ContentView: View {
	
	@State var events: [Event]
	
	@State private var isSheetVisible: Bool = true
	@State private var viewingEvent: Event? = nil
	
	var body: some View {
		Map {
			ForEach(events) { event in
				Marker(event.title, systemImage: event.type.getIcon(), coordinate: event.position)
			}
		}.sheet(isPresented: $isSheetVisible) {
			VStack {
				
				Text("Iskana pomoč")
					.font(.largeTitle)
					.bold()
					.frame(maxWidth: .infinity, alignment: .leading)
				
				ForEach($events) { $event in
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
	ContentView(events: Event.generateList())
}


//let albumSize = UIScreen.main.bounds.width / 2
//
//struct ContentView: View {
//
//	@StateObject var manager = Library()
//
//	var body: some View {
//		NavigationSplitView {
//			ScrollView {
//				if !manager.albums.isEmpty {
//					LazyVGrid(columns: [ GridItem(.flexible()), GridItem(.flexible()) ]) {
//						ForEach(manager.albums) { album in
//							VStack {
//								if let artworkUrl = album.artworkUrl {
//									AsyncImage(url: artworkUrl) { phase in
//										switch phase {
//										case .success(let image):
//											image
//												.resizable()
//												.scaledToFit()
//												.aspectRatio(contentMode: .fit)
//												.cornerRadius(5)
//												.onTapGesture {
//													Task {
//														await manager.play(album: album)
//													}
//												}
//										default:
//											Image(systemName: "music.note")
//												.resizable()
//												.scaledToFit()
//												.frame(height: albumSize)
//												.aspectRatio(contentMode: .fit)
//												.cornerRadius(5)
//												.onTapGesture {
//													Task {
//														await manager.play(album: album)
//													}
//												}
//										}
//									}
//								} else {
//									Image(systemName: "music.note")
//										.resizable()
//										.scaledToFit()
//										.frame(height: albumSize)
//										.aspectRatio(contentMode: .fit)
//										.cornerRadius(5)
//										.onTapGesture {
//											Task {
//												await manager.play(album: album)
//											}
//										}
//								}
//								Text(album.title)
//									.multilineTextAlignment(.leading)
//									.frame(maxWidth: .infinity, alignment: .leading)
//									.lineLimit(1)
//									.truncationMode(.tail)
//								Text(album.artist)
//									.foregroundStyle(.secondary)
//									.multilineTextAlignment(.leading)
//									.frame(maxWidth: .infinity, alignment: .leading)
//									.lineLimit(1)
//									.truncationMode(.tail)
//							}
//							.padding(.all, 8)
//						}
//					}
//				} else {
//					Text("Empty library")
//				}
//			}
//			.navigationTitle("Library")
//		} detail: {
//			
//		}
//		.onAppear {
//			Task {
//				await manager.load()
//			}
//		}
//	}
//}
//
//#Preview {
//    ContentView()
//}
