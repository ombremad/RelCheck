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
        NavigationStack {
            Form {
                if let settings = settings.first {
                    Toggle(isOn:  Binding(
                        get: { settings.dailyRecap },
                        set: { settings.dailyRecap = $0 }
                    )) {
                        Text("settings.dailyRecap.label")
                        Text("settings.dailyRecap.subtitle")
                    }
                }
            }
            
            .navigationTitle("settings.title")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    SettingsView()
}
