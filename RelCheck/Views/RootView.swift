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
  @Environment(\.scenePhase) private var scenePhase
  @Query private var settingsArray: [Settings]
  @Query(sort: \Contact.name) private var contacts: [Contact]

  @State private var permissionGranted = false
  @State private var hasReconciledNotifications = false

  private var theme: UserTheme {
    settingsArray.first?.theme ?? .auto
  }

  var body: some View {
    Group {
      if navigator.hasSeenOnboarding {
        pickLayout
          .task {
            checkPermission()

            // Reconcile notifications
            if !hasReconciledNotifications {
              NotificationManager.shared.reconcileNotifications(contacts: contacts)
              hasReconciledNotifications = true
            }
          }

          // Refresh permission status when coming back from Settings
          .onChange(of: scenePhase) { _, phase in
            if phase == .active { checkPermission() }
          }
      } else {
        OnboardingView(completeOnboarding: { navigator.completeOnboarding() })
      }
    }
    .preferredColorScheme(theme.colorScheme)
  }

  private func checkPermission() {
    NotificationManager.shared.requestPermission { granted in
      permissionGranted = granted
    }
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
    @Bindable var navigator = navigator

    NavigationSplitView {
      MainMenuView(permissionGranted: permissionGranted)
    } detail: {
      NavigationStack(path: $navigator.path) {
        if let section = navigator.selectedSection {
          NavigationDestinationView(destination: section)
            .navigationDestination(for: AppDestination.self) { destination in
              NavigationDestinationView(destination: destination)
            }
        }
      }
    }
  }

  @ViewBuilder
  private var compactLayout: some View {
    @Bindable var navigator = navigator

    TabView(selection: $navigator.selectedSection) {
      ForEach(AppDestination.mainMenuItems, id: \.self) { section in
        NavigationStack(path: path(for: section)) {
          Group {
            switch section {
            case .home: HomeView(showsPermissionWarning: !permissionGranted)
            default: NavigationDestinationView(destination: section)
            }
          }
          .navigationDestination(for: AppDestination.self) { destination in
            NavigationDestinationView(destination: destination)
          }
        }
        .tabItem { Label(section.menuTitle, systemImage: section.menuIcon) }
        .tag(section as AppDestination?)
      }
    }
  }

  private func path(for section: AppDestination) -> Binding<[AppDestination]> {
    Binding(
      get: { navigator.paths[section] ?? [] },
      set: { navigator.paths[section] = $0 },
    )
  }
}
