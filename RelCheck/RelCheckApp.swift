//
//  RelCheckApp.swift
//  RelCheck
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftData
import SwiftUI

@main struct RelCheckApp: App {
  private let navigator: AppNavigator
  private let notificationDelegate: NotificationDelegate
  private let container: ModelContainer

  init() {
    let navigator = AppNavigator()
    let notificationDelegate = NotificationDelegate()
    notificationDelegate.navigator = navigator

    UNUserNotificationCenter.current().delegate = notificationDelegate

    do {
      #if DEBUG
        if Screenshots.isEnabled {
          container = try Screenshots.makeContainer()
        } else {
          container = try Self.makeContainer()
        }
      #else
        container = try Self.makeContainer()
      #endif
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }

    NotificationManager.shared.modelContext = container.mainContext

    self.navigator = navigator
    self.notificationDelegate = notificationDelegate
  }

  private static func makeContainer() throws -> ModelContainer {
    try ModelContainer(
      for: CheckIn.self,
      Contact.self,
      Notification.self,
      Settings.self,
    )
  }

  var body: some Scene {
    WindowGroup { RootView().environment(navigator) }.modelContainer(container)
  }
}
