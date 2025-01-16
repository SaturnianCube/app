//
//  RatingView.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import SwiftUI

struct RatingView: View {
	
	@StateObject private var viewModel: RatingViewModel
	
	init (rating: Rating) {
		_viewModel = .init(wrappedValue: .init(rating: rating))
	}
	
    var body: some View {
		VStack {
			
			HStack {
				HStack {
					Image(systemName: "person.crop.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 20, height: 20, alignment: .leading)
					if let user = viewModel.user {
						NavigationLink(user.name) {
							UserInfoView(user: user)
						}
							.frame(maxWidth: .infinity, alignment: .leading)
					} else {
						Text("N/A")
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
			}
			.padding([ .leading, .top, .trailing ], 10)
			
			Text(viewModel.rating.comment)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding([ .leading, .trailing, .bottom ], 10)
		}
		.background(Color(UIColor.secondarySystemBackground))
		.cornerRadius(5)
		.onAppear {
			Task {
				await viewModel.fetchRatingUser()
			}
		}
    }
}

#Preview {
//    RatingView()
}
