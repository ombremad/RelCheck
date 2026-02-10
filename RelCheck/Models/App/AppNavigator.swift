//
//  AppNavigator.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI

@Observable
class AppNavigator {
    var path = NavigationPath()
    
    func navigate(to destination: AppDestination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }    
}
