//
//  NotificationDelegate.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
  weak var navigator: AppNavigator?
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter, willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) { completionHandler([.banner, .sound, .badge]) }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    let action = userInfo["action"] as? String
    let contactID = userInfo["contactID"] as? String
    
    DispatchQueue.main.async { [weak self] in
      switch action {
        case "viewFastCheckIn":
          self?.navigator?.navigate(to: .fastCheckIn)
        case "viewContact":
          if let contactID { self?.navigator?.navigate(to: .singleContact(id: contactID)) }
        default:
          break
      }
      completionHandler()
    }
  }
}
