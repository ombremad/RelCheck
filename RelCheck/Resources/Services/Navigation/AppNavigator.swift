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

  var paths: [AppDestination: [AppDestination]] = [:]

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

  func select(_ section: AppDestination) {
    if selectedSection == section {
      path = []
    } else {
      selectedSection = section
    }
  }

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
