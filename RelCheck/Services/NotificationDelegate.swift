//
//  NotificationDelegate.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    var navigator: AppNavigator?
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        guard let action = userInfo["action"] as? String else {
            completionHandler()
            return
        }
        
        switch action {
            case "viewFastCheckIn":
                navigator?.navigate(to: .fastCheckIn)
            case "viewContact":
                if let contactID = userInfo["contactID"] as? String {
                    print("🔗 Navigating to contact: \(contactID)")
                    navigator?.navigate(to: .contact(id: contactID))
                }
        default:
                print("Unknown notification action: \(action)")
                break
        }
        
        completionHandler()
    }
}
