//
//  SingleContactCard.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct SingleContactCard: View {
  let contact: Contact

  var body: some View {
    Section {
      HStack {
        Spacer()
        VStack {
          Circle()
            .frame(width: 120, height: 120)
            .opacity(0.25)
            .overlay(
              contact.icon.image
                .resizable()
                .scaledToFit()
                .padding(24)
            )
          Text(contact.name)
            .font(.title)
            .fontWeight(.heavy)
            .lineLimit(1)
        }
        .foregroundStyle(.background)
        .padding(24)
        Spacer()
      }
      .background(contact.color)
      .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

      VStack(spacing: 16) {
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

        LabeledContent {
          Text("singleContact.everyXDays \(contact.daysBetweenNotifications)")
        } label: {
          Label("singleContact.checkInFrequency", systemImage: "bolt.fill")
        }
      }
      .labeledContentStyle(LabelStyle())
    }
  }
}

#Preview() {
  Form {
    SingleContactCard(
      contact: Contact(
        name: "Anne",
        daysBetweenNotifications: 7,
        icon: .bicycle,
        color: .coral
      ))
  }
}
