//
//  HomeView.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppNavigator.self) private var navigator

  @Query private var settingsArray: [Settings]
  @Query(sort: \Contact.name) private var contacts: [Contact]

  @State private var permissionGranted = false
  @State private var hasReconciledNotifications = false

  var body: some View {
    Form {
      if !permissionGranted {
        AuthorizationWarningCard()
      }

      HomeFocusCard(card: .overdue, contacts: contacts)
      HomeFocusCard(card: .next, contacts: contacts)

      Section {
        HomeActionCards()
      }
    }
    .listSectionSpacing(.custom(16))
    .scrollBounceBehavior(.basedOnSize)
    .animation(.easeInOut, value: permissionGranted)

    .navigationTitle("app.title")
    .navigationBarTitleDisplayMode(.inline)

    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          navigator.push(.settings)
        } label: {
          Label("button.settings", systemImage: "gear")
        }
      }
      #if DEBUG
        ToolbarItem(placement: .primaryAction) {
          Button {
            navigator.push(.debug)
          } label: {
            Label("button.debug", systemImage: "ant")
          }
        }
      #endif
    }

    .task {
      // Check notifications permissions
      NotificationManager.shared.requestPermission { granted in
        permissionGranted = granted
      }

      // Reconcile notifications
      if !hasReconciledNotifications {
        NotificationManager.shared.reconcileNotifications(contacts: contacts)
        hasReconciledNotifications = true
      }
    }
  }
}

#Preview("Regular", traits: .portrait) {
  NavigationStack {
    HomeView()
      .modelContainer(Preview.Container.contacts)
      .environment(AppNavigator())
  }
}

#Preview("Compact", traits: .landscapeRight) {
  NavigationStack {
    HomeView()
      .modelContainer(Preview.Container.contacts)
      .environment(AppNavigator())
  }
}
