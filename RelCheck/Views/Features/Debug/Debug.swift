//
//  DebugView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/10/2026.
//

import SwiftUI

struct DebugView: View {
  @State private var store = DebugNotificationStore()

  var body: some View {
    List(store.items) { item in
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(item.kind.hashValue.description)
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
    .navigationTitle("debugNotifications.title")
    .task { await store.refresh() }
    .refreshable { await store.refresh() }
  }
}
