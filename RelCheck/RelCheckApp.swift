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
    var body: some Scene {
        WindowGroup {
            ContactsView()
        }
        .modelContainer(for: [Contact.self, Notification.self])
    }
}
