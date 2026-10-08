//
//  ContactRow.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//

import SwiftUI

struct ContactRow: View {
  @Environment(AppNavigator.self) private var navigator

  let contact: Contact
  var mode: ContactsDisplayMode

  var body: some View {
    Button {
      navigator.showContact(contact.id)
    } label: {
      HStack(spacing: 8) {
        content
        Spacer()
        if mode == .inline {
          Image(systemName: "chevron.forward")
            .foregroundStyle(.quaternary)
        }
      }
      .labeledContentStyle(ContactRowLabels())
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  private var content: some View {
    switch mode {
    case .inline:
      HStack(spacing: 8) {
        Avatar(contact)
        VStack(alignment: .leading) {
          Text(contact.name).font(.headline)
          details
        }
      }
    case .column:
      VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 8) {
          Avatar(contact)
          Text(contact.name).font(.headline)
        }
        details
      }
    }
  }

  @ViewBuilder
  private var details: some View {
    switch mode {
    case .inline:
      HStack(spacing: 16) {
        CheckInFrequency(contact: contact)
        Spacer()
        NextCheckIn(contact: contact)
      }
    case .column:
      VStack(alignment: .leading, spacing: 8) {
        CheckInFrequency(contact: contact)
        NextCheckIn(contact: contact)
      }
    }
  }
}

private struct CheckInFrequency: View {
  let contact: Contact

  var body: some View {
    LabeledContent {
      Text("singleContact.everyXDays \(contact.daysBetweenNotifications)")
    } label: {
      Label("singleContact.checkInFrequency", systemImage: "bolt.fill")
    }
  }
}

private struct NextCheckIn: View {
  let contact: Contact

  var body: some View {
    LabeledContent {
      if let nextNotif = contact.nextUpcomingNotification {
        Text("singleContact.inXDays \(nextNotif.daysLeftUntilDate)")
      } else {
        Text("singleContact.overdue")
          .fontWeight(.bold)
          .padding(.horizontal, 8)
          .background(LinearGradient.destructive)
          .clipShape(Capsule())
      }
    } label: {
      Label("singleContact.nextCheckIn", systemImage: "calendar")
    }
  }
}

#Preview("Inline") {
  @Previewable @State var contact = Preview.contact
  Form {
    ContactRow(contact: contact, mode: .inline)
      .environment(AppNavigator())
  }
}

#Preview("Column") {
  @Previewable @State var contact = Preview.contact
  Form {
    ContactRow(contact: contact, mode: .column)
      .environment(AppNavigator())
  }
}
