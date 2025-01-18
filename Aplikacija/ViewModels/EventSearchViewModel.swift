//
//  EventSearchViewModel.swift
//  Aplikacija
//
//  Created on 18. 1. 25.
//

import Foundation
import Combine
import SwiftUI

enum EventSortOrder: CaseIterable {
	
	case startDate
	case endDate
	case price
	
	func getLabel () -> String {
		switch (self) {
			case .startDate:
				return "Začetek naprej"
			case .endDate:
				return "Konec naprej"
			case .price:
				return "Nagrada naprej"
		}
	}
	
	func getIcon () -> String {
		switch (self) {
			case .startDate:
				return "clock"
			case .endDate:
				return "clock.badge.exclamationmark"
			case .price:
				return "eurosign"
		}
	}
}

class EventSearchViewModel: ObservableObject {
	
	@ObservedObject var dataManager: DataManager = .shared
	
	// State
	@Published var sortedEvents: [Event] = []
		
	// UI State
	@Published var navigation: Int? = 0
	@Published var sortOrder: EventSortOrder = .startDate
	@Published var searchQuery: String = ""
	
	private var cancellables = Set<AnyCancellable>()
	
	init () {
		dataManager.$events
			.combineLatest($sortOrder, $searchQuery)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] (events, sortOrder, searchQuery) in
				self?.updateSortedEvents(events: events, sortOrder: sortOrder, searchQuery: searchQuery)
			}
			.store(in: &cancellables)
	}
	
	func updateSortedEvents (events: [Event], sortOrder: EventSortOrder, searchQuery: String) {
				
		let filtered = events.filter { event in
			searchQuery.isEmpty || event.title.localizedCaseInsensitiveContains(searchQuery)
		}
		
		var sorted: [Event]
		
		switch sortOrder {
			case .startDate:
				sorted = filtered.sorted { $0.dateInterval.start > $1.dateInterval.start }
			case .endDate:
				sorted = filtered.sorted { $0.dateInterval.end < $1.dateInterval.end }
			case .price:
				sorted = filtered.sorted { ($0.payment?.value ?? 0) > ($1.payment?.value ?? 0) }
		}
		
		withAnimation {
			self.sortedEvents = sorted
		}
	}
	
	func toggleSortOrder () {
		
		var i = 1
		
		for sortOrder in EventSortOrder.allCases {
						
			if self.sortOrder == sortOrder {
				break
			}

			i += 1
		}
		
		if i >= EventSortOrder.allCases.count {
			i = 0
		}
		
		self.sortOrder = EventSortOrder.allCases[i]
	}
	
	func fetchEvents () async {
		await dataManager.fetchEvents()
	}
	
}
