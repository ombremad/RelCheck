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
    
    @Query private var settings: [Settings]
            
    var body: some View {
        if let settings = settings.first {
            @Bindable var settings = settings
            Form {
                Toggle(isOn: $settings.fastCheckIn) {
                    VStack(alignment: .leading) {
                        Text("settings.fastCheckIn.label")
                        Text("settings.fastCheckIn.subtitle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
