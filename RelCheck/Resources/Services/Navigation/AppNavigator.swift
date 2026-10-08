//
//  AppNavigator.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import Foundation

@Observable
final class AppNavigator {
  var selectedSection: AppDestination? = .home

  // One navigation stack per section
  var paths: [AppDestination: [AppDestination]] = [:]

  // Stack of the selected section
  var path: [AppDestination] {
    get { paths[selectedSection ?? .home, default: []] }
    set { paths[selectedSection ?? .home] = newValue }
  }

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

  // Main menu tap: switch section, or go back to its root if it's already selected
  func select(_ section: AppDestination) {
    if selectedSection == section {
      path = []
    } else {
      selectedSection = section
    }
  }

  // Back to Home's first screen, closing whatever is open in the current section
  func goHome() {
    path = []
    selectedSection = .home
    path = []
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
