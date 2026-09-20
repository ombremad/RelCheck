//
//  SettingsView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftData
import SwiftUI

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
              Text("settings.dailyFastCheckIn.label")
              Text("settings.dailyFastCheckIn.subtitle")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }
          
          if settings.fastCheckIn {
            Picker("settings.fastCheckInHour.label", selection: $settings.fastCheckInHour) {
              ForEach(0..<24, id: \.self) { hour in
                Text(String(format: "%02d:00", hour)).tag(hour)
              }
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
      .navigationTitle("settings.title").navigationBarTitleDisplayMode(.inline)

      .onChange(of: settings.fastCheckIn) {
        NotificationManager.shared.scheduleFastCheckInNotifications()
      }
      .onChange(of: settings.fastCheckInHour) {
        NotificationManager.shared.scheduleFastCheckInNotifications()
      }
    }
  }
}

#Preview { SettingsView().environment(AppNavigator()) }
