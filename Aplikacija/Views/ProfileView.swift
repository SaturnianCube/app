//
//  ProfileView.swift
//  Aplikacija
//
//  Created on 12. 1. 25.
//

import SwiftUI

struct ProfileView: View {
    
	@ObservedObject var dataManager = DataManager.shared
	
	var body: some View {
		NavigationStack {
			if let currentUser = dataManager.currentUser {
				UserInfoView(user: currentUser)
			} else {
				VStack {
					Text("Niste prijavljeni")
					Button("Prijava") {
						//
					}
					.buttonStyle(PrimaryButtonStyle())
				}
			}
		}
    }
}

#Preview {
    ProfileView()
}
