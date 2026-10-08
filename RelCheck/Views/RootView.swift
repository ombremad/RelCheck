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
        pickLayout
      } else {
        OnboardingView(completeOnboarding: { navigator.completeOnboarding() })
      }
    }
    .preferredColorScheme(theme.colorScheme)
  }

  @ViewBuilder
  private var pickLayout: some View {
    switch horizontalSizeClass {
    case .compact: compactLayout
    case .regular: wideLayout
    default: wideLayout
    }
  }

  @ViewBuilder
  private var wideLayout: some View {
    NavigationSplitView {
      ContactsView(mode: .column)
    } detail: {
      mainStack
    }
  }

  @ViewBuilder
  private var compactLayout: some View {
    mainStack
  }
}
