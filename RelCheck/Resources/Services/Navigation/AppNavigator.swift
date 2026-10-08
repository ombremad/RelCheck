//
//  AppNavigator.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI

@Observable
final class AppNavigator {
  var path = NavigationPath()

  private(set) var hasSeenOnboarding: Bool {
    didSet {
      UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
    }
  }

  init() {
    self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
  }

  func push(_ destination: AppDestination) {
    path.append(destination)
  }

  func replace(_ destination: AppDestination) {
    path = NavigationPath([destination])
  }

  func back() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  func completeOnboarding() {
    hasSeenOnboarding = true
  }

  func resetOnboarding() {
    hasSeenOnboarding = false
  }
}
