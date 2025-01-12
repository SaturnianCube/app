//
//  FormatterFactory.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import Foundation

struct FormatterFactory {
	
	static let dateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale.init(identifier: "sl-si")
		return dateFormatter
	}()
	
	static let timeFormatter = {
		let timeFormatter = DateComponentsFormatter()
		timeFormatter.unitsStyle = .abbreviated
		timeFormatter.allowedUnits = [ .hour, .minute ]
		return timeFormatter
	}()
	
	static let timeIntervalFormatter = {
		let timeIntervalFormatter = DateIntervalFormatter()
		timeIntervalFormatter.dateStyle = .none
		timeIntervalFormatter.timeStyle = .short
		timeIntervalFormatter.locale = Locale.init(identifier: "sl-si")
		return timeIntervalFormatter
	}()

}
