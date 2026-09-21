//
//  RootView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
  @Environment(AppNavigator.self) private var navigator
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Query private var settingsArray: [Settings]

  private var theme: UserTheme {
    settingsArray.first?.theme ?? .auto
  }

  private var mainStack: some View {
    @Bindable var navigator = navigator

    return NavigationStack(path: $navigator.path) {
      HomeView().navigationDestination(for: AppDestination.self) { destination in
        NavigationDestinationView(destination: destination)
      }
    }
  }

  var body: some View {
    Group {
      if navigator.hasSeenOnboarding {
        if horizontalSizeClass == .regular {
          NavigationSplitView {
            ContactsView(onSelect: { contact in
              navigator.navigate(to: .singleContact(id: contact.id))
            })
            .navigationSplitViewColumnWidth(min: 280, ideal: 320, max: 400)
          } detail: {
            mainStack
          }
        } else {
          mainStack
        }
      } else {
        OnboardingView(completeOnboarding: { navigator.completeOnboarding() })
      }
    }
    .preferredColorScheme(theme.colorScheme)
  }
}
