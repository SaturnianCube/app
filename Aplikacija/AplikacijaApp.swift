//
//  AplikacijaApp.swift
//  Aplikacija
//
//  Created on 22. 11. 24.
//

import SwiftUI

@main
struct AplikacijaApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
    var body: some Scene {
        WindowGroup {
			ContentView()
        }
    }
}
