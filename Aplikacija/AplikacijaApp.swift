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
				.onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}

extension UIApplication {
	func addTapGestureRecognizer() {
		
		guard let window = windows.first else {
			return
		}
		
		let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
		tapGesture.requiresExclusiveTouchType = false
		tapGesture.cancelsTouchesInView = false
		tapGesture.delegate = self
		window.addGestureRecognizer(tapGesture)
	}
}

extension UIApplication: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
