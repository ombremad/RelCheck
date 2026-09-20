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
  
  init() {
    let navigator = AppNavigator()
    let notificationDelegate = NotificationDelegate()
    notificationDelegate.navigator = navigator
    
    UNUserNotificationCenter.current().delegate = notificationDelegate
    
    self.navigator = navigator
    self.notificationDelegate = notificationDelegate
  }
  
  var body: some Scene {
    WindowGroup { RootView().environment(navigator) }.modelContainer(for: [
      CheckIn.self, Contact.self, Notification.self, Settings.self,
    ])
  }
}
