//
//  AppNavigator.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI

@Observable
final class AppNavigator {
  var path: [AppDestination] = [] {
    didSet {
      if !path.contains(.contact) { selectedContactID = nil }
    }
  }

  private(set) var selectedContactID: UUID?

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

  func back() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  func showContact(_ id: UUID) {
    // Go back to the contact page if anything is on top of it
    while path.contains(.contact) && path.last != .contact { back() }

    if path.last != .contact { path.append(.contact) }
    withAnimation { selectedContactID = id }
  }

  func completeOnboarding() {
    hasSeenOnboarding = true
  }

  func resetOnboarding() {
    hasSeenOnboarding = false
  }
}
