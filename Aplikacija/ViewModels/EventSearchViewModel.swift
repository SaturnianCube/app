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
				return "Cena naprej"
		}
	}
	
	func getIcon () -> String {
		switch (self) {
			case .startDate:
				return "calendar"
			case .endDate:
				return "calendar.badge.clock"
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
			.sink { [weak self] (events, sortOrder, searchQuery) in
				self?.updateSortedEvents(events: events, sortOrder: sortOrder, searchQuery: searchQuery)
			}
			.store(in: &cancellables)
	}
	
	func updateSortedEvents (events: [Event], sortOrder: EventSortOrder, searchQuery: String) {
		
		let filtered = events.filter { event in
			searchQuery.isEmpty || event.title.localizedCaseInsensitiveContains(searchQuery)
		}
		
		switch sortOrder {
			case .startDate:
				self.sortedEvents = filtered.sorted { $0.dateInterval.start > $1.dateInterval.start }
			case .endDate:
				self.sortedEvents = filtered.sorted { $0.dateInterval.end < $1.dateInterval.end }
			case .price:
				self.sortedEvents = filtered.sorted { ($0.payment?.value ?? 0) > ($1.payment?.value ?? 0) }
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
	
}
