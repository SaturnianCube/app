//
//  UserInfoView.swift
//  Aplikacija
//
//  Created on 22. 10. 24.
//

import SwiftUI

struct UserInfoView: View {
	
	@StateObject private var viewModel: UserInfoViewModel
	
	init (user: User) {
		_viewModel = .init(wrappedValue: .init(user: user))
	}
	
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
					
//					Text("Biografija")
//						.frame(maxWidth: .infinity, alignment: .leading)
//						.font(.title2)
//						.bold()
//						.padding([ .all ], 10)
					
					Text(viewModel.user.biography)
						.padding([ .all ], 10)
						.frame(maxWidth: .infinity, alignment: .leading)
						.background(Color(UIColor.secondarySystemBackground))
						.cornerRadius(10)
						.padding([ .leading, .trailing ], 10)
					
				}
			}
			.padding([ .leading, .trailing ], 20)
			.padding([ .top, .bottom ], 15)
							
			VStack(spacing: 5) {
				
				HStack {
					
					Text("Mnenja drugih")
						.font(.title2)
						.bold()
						.padding(.bottom, 5)
					
					if viewModel.currentUser?.id != viewModel.user.id {
						Button(action: {
							viewModel.showRatingSheet = true
						}) {
							Image(systemName: "plus")
								.resizable()
								.scaledToFit()
								.frame(width: 15, height: 15)
						}
						.buttonStyle(PrimaryIconButtonStyle())
					}
					
					Spacer()
					
					HStack {
						Text("\(viewModel.averageRating)")
						Image(systemName: "star.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 20, height: 20, alignment: .trailing)
					}
				}
				
				if viewModel.ratings.count > 0 {
					ScrollView {
						ForEach(viewModel.sortedRatings) { rating in
							RatingCard(rating: rating)
						}
					}
				} else {
					Text("Ni mnenj")
						.padding([ .top, .bottom ], 60)
						.italic()
				}
				
				Spacer()
			
			}
			.padding([ .leading, .trailing], 10)

		}
		.sheet(isPresented: $viewModel.showRatingSheet) {
			RatingCreatorView(targetUser: viewModel.user, onRatingAdded: {
				viewModel.ratings.append($0)
				viewModel.showRatingSheet = false
			})
		}
		.navigationTitle(viewModel.user.name)
		.onAppear {
			Task {
				await viewModel.fetchRatings()
			}
		}
	}
}

#Preview {
	UserInfoView(user: User.generateDummy())
}
