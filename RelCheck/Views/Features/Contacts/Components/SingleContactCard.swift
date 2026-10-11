//
//  SingleContactCard.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct SingleContactCard: View {
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  private var isCompact: Bool { verticalSizeClass == .compact }

  let contact: Contact

  init(_ contact: Contact) {
    self.contact = contact
  }

  var body: some View {
    Section {
      if isCompact {
        compactLayout
      } else {
        stackedLayout
      }
    }
  }

  private var compactLayout: some View {
    HStack(spacing: 0) {
      header
        .containerRelativeFrame(.horizontal, alignment: .leading) { width, _ in width / 3 }
      details
        .padding(24)
        .frame(maxWidth: .infinity)
    }
    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
  }

  @ViewBuilder
  private var stackedLayout: some View {
    header
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    details
  }

  var header: some View {
    VStack {
      Avatar(contact, mode: isCompact ? .compactContact : .contact)
      Text(contact.name)
        .font(.title)
        .fontWeight(.heavy)
        .lineLimit(1)
    }
    .foregroundStyle(Color.contactCardForeground)
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient.highlight(contact.color.color))
  }

  var details: some View {
    VStack(spacing: 16) {
      LabeledContent {
        if let nextNotif = contact.nextUpcomingNotification {
          Text("singleContact.inXDays \(nextNotif.daysLeftUntilDate)")
        } else {
          Text("singleContact.overdue")
            .fontWeight(.bold)
            .padding(.horizontal, 12)
            .padding(.vertical, 2)
            .background(LinearGradient.destructive)
            .clipShape(.rect(cornerRadius: Constants.Layout.cornerRadius))
        }
      } label: {
        Label("singleContact.nextCheckIn", systemImage: "calendar")
      }

      LabeledContent {
        Text("singleContact.everyXDays \(contact.daysBetweenNotifications)")
      } label: {
        Label("singleContact.checkInFrequency", systemImage: "bolt.fill")
      }
    }
    .labeledContentStyle(SingleContactLabels())
  }
}

#Preview() {
  Form {
    SingleContactCard(Preview.contact)
  }
}
