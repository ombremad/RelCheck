//
//  DebugNotification.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/10/2026.
//

import UserNotifications

struct DebugNotification: Identifiable {
  enum Kind { case pending, delivered }

  let id: String
  let kind: Kind
  let title: String
  let body: String
  let date: Date?
  let triggerInfo: String
}
