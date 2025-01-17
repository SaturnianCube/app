//
//  CreatorViewModel.swift
//  Aplikacija
//
//  Created on 17. 1. 25.
//

import SwiftUI

class CreatorViewModel: ObservableObject {
    
	@Published public var shouldShowError: Bool = false
	@Published public var errorMessage: String = "" { didSet { shouldShowError = !errorMessage.isEmpty } }
	@Published public var isLoading: Bool = false
	
}
