//
//  DebugView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/10/2026.
//

import SwiftData
import SwiftUI

struct DebugView: View {
  @State private var store = DebugNotificationStore()
  @Query(filter: #Predicate<Contact> { $0.name == "Elliot" }, sort: \Contact.name)
  private var elliots: [Contact]

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
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      Button("debugNotifications.scheduleElliot", systemImage: "bell.badge") {
        guard let elliot = elliots.first else { return }
        _ = NotificationManager.shared.scheduleContactNotificationAtDate(
          date: .now.addingTimeInterval(15),
          contact: elliot,
        )
      }
      .disabled(elliots.isEmpty)
    }
    .task { await store.refresh() }
    .refreshable { await store.refresh() }
  }
}
