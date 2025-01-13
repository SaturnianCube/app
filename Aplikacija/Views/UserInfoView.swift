//
//  UserInfoView.swift
//  Aplikacija
//
//  Created on 22. 10. 24.
//

import SwiftUI

struct UserInfoView: View {
	
	@State var user: User
	
    var body: some View {
		VStack {
			
			HStack {
				Image(systemName: "person.crop.circle")
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 100, alignment: .leading)
				VStack {
					
//					Text(user.name)
//						.frame(maxWidth: .infinity, alignment: .leading)
//						.font(.largeTitle)
//						.bold()
					
					HStack {
						Image(systemName: "star.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 25, height: 25, alignment: .leading)
						Text("\(user.rating)")
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					
				}
			}
			.padding([ .leading, .trailing ], 20)
			.padding([ .top, .bottom ], 15)
			
//			Text("Biografija")
//				.frame(maxWidth: .infinity, alignment: .leading)
//				.font(.title2)
//				.bold()
//				.padding([ .all ], 10)
			
			Text(user.biography)
				.padding([ .all ], 10)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(Color(UIColor.secondarySystemBackground))
				.cornerRadius(10)
				.padding([ .leading, .trailing ], 10)
							
			VStack(spacing: 5) {
				
				Text("Mnenja drugih")
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.title2)
					.bold()
					.padding([ .bottom ], 5)
				
				ForEach(user.comments) { comment in
					VStack {
						
						HStack {
							HStack {
								Image(systemName: "person.crop.circle")
									.resizable()
									.scaledToFit()
									.frame(width: 20, height: 20, alignment: .leading)
								NavigationLink(user.name, value: user)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
							HStack {
								Image(systemName: "star.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 20, height: 20, alignment: .trailing)
								Text("\(comment.rating)")
							}
						}
							.padding([ .leading, .top, .trailing ], 10)
						
						Text(comment.content)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding([ .leading, .trailing, .bottom ], 10)
					}
					.background(Color(UIColor.secondarySystemBackground))
					.cornerRadius(5)
				}
				
				Button("Dodaj mnenje", systemImage: "plus") {
					
				}
					.buttonStyle(PrimaryButtonStyle())
			
			}
			.padding([ .leading, .trailing], 10)
			
			Spacer()
		}
		.navigationTitle(user.name)
	}
}

#Preview {
	UserInfoView(user: User.generate())
}
