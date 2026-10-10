//
//  Settings.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftData
import SwiftUI

enum UserTheme: String, Codable, CaseIterable {
  case auto, light, dark

  var colorScheme: ColorScheme? {
    switch self {
    case .auto: nil
    case .light: .light
    case .dark: .dark
    }
  }

  var title: LocalizedStringKey {
    switch self {
    case .auto: "settings.theme.auto"
    case .light: "settings.theme.light"
    case .dark: "settings.theme.dark"
    }
  }
}

@Model class Settings {
  var fastCheckIn: Bool = false
  var fastCheckInHour: Int = Constants.FastCheckIn.defaultHour
  var themeName: String = UserTheme.auto.rawValue

  @Transient var theme: UserTheme {
    get { UserTheme(rawValue: themeName) ?? .auto }
    set { themeName = newValue.rawValue }
  }

  init(
    fastCheckIn: Bool = false,
    fastCheckInHour: Int = Constants.FastCheckIn.defaultHour,
    theme: UserTheme = .auto,
  ) {
    self.fastCheckIn = fastCheckIn
    self.fastCheckInHour = fastCheckInHour
    self.themeName = theme.rawValue
  }
}
