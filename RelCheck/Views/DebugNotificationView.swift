//
//  NotificationDebugView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/10/2026.
//

import SwiftUI

struct DebugNotificationView: View {
  @State private var store = DebugNotificationStore()

  var body: some View {
    List(store.items) { item in
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(item.kind.rawValue)
            .font(.caption.bold())
          Spacer()
          if let date = item.date {
            Text(date, format: .dateTime)
              .font(.caption)
          }
        }
        Text(item.title).font(.headline)
        Text(item.body).font(.subheadline)
        Text(item.id).font(.caption2).foregroundStyle(.secondary)
      }
    }
    .navigationTitle("debugnotifications.title")
    .task { await store.refresh() }
    .refreshable { await store.refresh() }
  }
}
