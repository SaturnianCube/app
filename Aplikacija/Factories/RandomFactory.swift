//
//  RandomFactory.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import Foundation

struct RandomFactory {
	
	static func randomId () -> String {
		let symbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<20).map { _ in
			return symbols.randomElement()!
		})
	}
	
}
