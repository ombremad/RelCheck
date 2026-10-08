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
      container = try ModelContainer(
        for: CheckIn.self,
        Contact.self,
        Notification.self,
        Settings.self,
      )
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }

    // Share the main context so notification scheduling reads the same settings as the views
    NotificationManager.shared.modelContext = container.mainContext

    self.navigator = navigator
    self.notificationDelegate = notificationDelegate
  }

  var body: some Scene {
    WindowGroup { RootView().environment(navigator) }.modelContainer(container)
  }
}
