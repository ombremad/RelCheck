//
//  SettingsView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppNavigator.self) private var navigator
  @Environment(\.locale) private var locale

  @Query private var settings: [Settings]

  private func hourLabel(_ hour: Int) -> String {
    let components = DateComponents(hour: hour, minute: 0)
    guard let date = Calendar.current.date(from: components) else {
      return "\(hour):00"
    }
    return date.formatted(.dateTime.hour().minute().locale(locale))
  }

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
                Text(hourLabel(hour)).tag(hour)
              }
            }
          }
        }

        Section {
          Picker("settings.theme.label", selection: $settings.theme) {
            ForEach(UserTheme.allCases, id: \.self) { theme in
              Text(theme.title)
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
            navigator.push(.about)
          } label: {
            Label("settings.about.label", systemImage: "questionmark.text.page")
          }
        }

        #if DEBUG
          Section {
            Button {
              navigator.push(.debug)
            } label: {
              Label("Debug", systemImage: "ant")
            }
          }
        #endif

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

#Preview("24-hour format") {
  NavigationStack {
    SettingsView()
      .environment(AppNavigator())
      .modelContainer(Preview.Container.settings)
      .environment(\.locale, Locale(identifier: "en_UK"))
  }
}

#Preview("12-hour format") {
  NavigationStack {
    SettingsView()
      .environment(AppNavigator())
      .modelContainer(Preview.Container.settings)
      .environment(\.locale, Locale(identifier: "en_US"))
  }
}
