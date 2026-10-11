//
//  ContactRow.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//

import SwiftUI

struct ContactRow: View {
  @Environment(AppNavigator.self) private var navigator
  @Environment(\.verticalSizeClass) private var verticalSizeClass

  private var isCompact: Bool { verticalSizeClass == .compact }

  let contact: Contact
  var mode: ContactsListMode = .regular

  var body: some View {
    Button {
      navigator.push(.contact(id: contact.id))
    } label: {
      HStack(spacing: 8) {
        if isCompact {
          compactContent
        } else {
          regularContent
        }
        Spacer()
        Image(systemName: "chevron.forward")
          .foregroundStyle(.quaternary)
      }
      .labeledContentStyle(ContactRowLabels())
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }

  private var compactContent: some View {
    HStack(spacing: 8) {
      Avatar(contact, mode: .compactList)
      Text(contact.name).font(.headline)
      details
    }
  }

  private var regularContent: some View {
    HStack(spacing: 8) {
      Avatar(contact)
      VStack(alignment: .leading) {
        Text(contact.name).font(.headline)
        details
      }
    }
  }

  private var details: some View {
    HStack(spacing: 0) {
      firstDetail.lineLimit(1).allowsTightening(true)
      Spacer(minLength: 0)
      secondDetail.lineLimit(1).allowsTightening(true)
    }
  }

  @ViewBuilder
  private var firstDetail: some View {
    switch mode {
    case .recent: LastCheckIn(contact: contact)
    default: CheckInFrequency(contact: contact)
    }
  }

  @ViewBuilder
  private var secondDetail: some View {
    switch mode {
    case .overdue: OverdueFor(contact: contact)
    default: NextCheckIn(contact: contact)
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
        OverdueCapsule()
      }
    } label: {
      Label("singleContact.nextCheckIn", systemImage: "calendar")
    }
  }
}

private struct LastCheckIn: View {
  let contact: Contact

  var body: some View {
    LabeledContent {
      if let lastCheckIn = contact.lastCheckIn {
        let days = Calendar.current.dateComponents([.day], from: lastCheckIn.date, to: .now).day ?? 0
        Text("singleContact.xDaysAgo \(days)")
      } else {
        OverdueCapsule()
      }
    } label: {
      Label("singleContact.lastCheckIn", systemImage: "checkmark")
    }
  }
}

private struct OverdueFor: View {
  let contact: Contact

  var body: some View {
    LabeledContent {
      if let overdueNotif = contact.overdueNotification {
        let days = Calendar.current.dateComponents([.day], from: overdueNotif.date, to: .now).day ?? 0
        Text("singleContact.forXDays \(days)")
      } else {
        OverdueCapsule()
      }
    } label: {
      Label("singleContact.overdueLabel", systemImage: "clock")
    }
  }
}

private struct OverdueCapsule: View {
  var body: some View {
    Text("singleContact.overdue")
      .fontWeight(.bold)
      .padding(.horizontal, 8)
      .background(LinearGradient.destructive)
      .clipShape(.rect(cornerRadius: Constants.Layout.cornerRadius))
  }
}

#Preview("Regular") {
  @Previewable @State var contact = Preview.contact
  Form {
    ContactRow(contact: contact)
      .environment(AppNavigator())
  }
}

#Preview("Overdue") {
  @Previewable @State var contact = Preview.contact
  Form {
    ContactRow(contact: contact, mode: .overdue)
      .environment(AppNavigator())
  }
}

#Preview("History") {
  @Previewable @State var contact = Preview.contact
  Form {
    ContactRow(contact: contact, mode: .recent)
      .environment(AppNavigator())
  }
}
