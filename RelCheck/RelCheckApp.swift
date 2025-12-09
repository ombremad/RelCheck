//
//  notifymeApp.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

@main
struct RelCheckApp: App {
    @State private var navigator = AppNavigator()
    private let notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        notificationDelegate.navigator = navigator
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(navigator)
        }
        .modelContainer(for: [CheckIn.self, Contact.self, Notification.self, Settings.self])
    }
}
