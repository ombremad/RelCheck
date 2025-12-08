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
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContactsView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [CheckIn.self, Contact.self, Notification.self, Settings.self])
    }
}
