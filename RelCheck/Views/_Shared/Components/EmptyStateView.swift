//
//  EmptyStateView.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/10/2026.
//

import SwiftUI

struct EmptyStateView: View {
  @Environment(AppNavigator.self) private var navigator

  let reason: ContentUnavailableReason

  var body: some View {
    ContentUnavailableView {
      Label(reason.title, systemImage: reason.systemImage)
    } description: {
      Text(reason.description)
    } actions: {
      if let cta = reason.cta {
        Button(cta.label) { cta.action(navigator) }
          .buttonStyle(.borderedProminent)
      }
    }
  }
}

#Preview("Contacts list empty") {
  EmptyStateView(reason: .contactsListEmpty)
    .environment(AppNavigator())
}

#Preview("No overdue contact") {
  EmptyStateView(reason: .noOverdueContact)
    .environment(AppNavigator())
}

#Preview("No recent check-in") {
  EmptyStateView(reason: .noRecentCheckIn)
    .environment(AppNavigator())
}

#Preview("Contact not found") {
  EmptyStateView(reason: .contactNotFound)
    .environment(AppNavigator())
}
