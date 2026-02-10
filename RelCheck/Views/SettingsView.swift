//
//  SettingsView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI
import SwiftData

@MainActor
struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppNavigator.self) private var navigator
    
    @Query private var settings: [Settings]
            
    var body: some View {
        if let settings = settings.first {
            @Bindable var settings = settings
            Form {
                Section {
                    Toggle(isOn: $settings.fastCheckIn) {
                        VStack(alignment: .leading) {
                            Text("settings.fastCheckIn.label")
                            Text("settings.fastCheckIn.subtitle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Section {
                    Button {
                        navigator.resetOnboarding()
                    } label: {
                        Label("settings.seeOnboardingAgain.label", systemImage: "rectangle.stack")
                    }
                    Button {
                        navigator.navigate(to: .about)
                    } label: {
                        Label("settings.about.label", systemImage: "questionmark.text.page")
                    }
                }
            }
            .navigationTitle("settings.title")
            .navigationBarTitleDisplayMode(.inline)

            .onChange(of: settings.fastCheckIn) {
                if settings.fastCheckIn {
                    let _ = NotificationManager.shared.scheduleFastCheckInNotification()
                } else {
                    NotificationManager.shared.deleteNotification(identifier: "fast-check-in")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
