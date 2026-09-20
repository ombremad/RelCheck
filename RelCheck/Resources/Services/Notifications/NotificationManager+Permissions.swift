//
//  NotificationManager+Permissions.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import SwiftUI

extension NotificationManager {
  // Request permission to send notifications
  func requestPermission(completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      granted, error in
      if let error = error { print("Error requesting permission: \(error)") }
      DispatchQueue.main.async { completion(granted) }
    }
  }
  
  // Request permission again through settings if first time was dismissed
  func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
  }
}
