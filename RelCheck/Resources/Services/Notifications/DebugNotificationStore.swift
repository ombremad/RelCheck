//
//  DebugNotificationStore.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/10/2026.
//

import UserNotifications
import Observation

@Observable
@MainActor
final class DebugNotificationStore {
  var items: [DebugNotification] = []

  func refresh() async {
    let center = UNUserNotificationCenter.current()

    let pending = await center.pendingNotificationRequests().map { request in
      let nextFire =
        (request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
        ?? (request.trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate()

      return DebugNotification(
        id: request.identifier,
        kind: .pending,
        title: request.content.title,
        body: request.content.body,
        date: nextFire,
        triggerInfo: String(describing: request.trigger.map { type(of: $0) }),
      )
    }

    let delivered = await center.deliveredNotifications().map { notification in
      DebugNotification(
        id: notification.request.identifier,
        kind: .delivered,
        title: notification.request.content.title,
        body: notification.request.content.body,
        date: notification.date,
        triggerInfo: "delivered",
      )
    }

    items = (pending + delivered).sorted {
      ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture)
    }
  }
}
