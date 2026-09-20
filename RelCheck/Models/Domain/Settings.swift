//
//  Settings.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftData

@Model class Settings {
  var fastCheckIn: Bool = false
  var fastCheckInHour: Int = 20

  init(
    fastCheckIn: Bool = false,
    fastCheckInHour: Int = 20,
  ) {
    self.fastCheckIn = fastCheckIn
    self.fastCheckInHour = fastCheckInHour
  }
}
