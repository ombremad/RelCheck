//
//  ContactContext.swift
//  RelCheck
//
//  Created by Anne Ferret on 11/04/2026.
//

import SwiftUI

struct ContactContext: View {
  var contact: Contact

  var body: some View {
    LabeledContent {
      Text("singleContact.everyXDays \(contact.daysBetweenNotifications)")
    } label: {
      Label("singleContact.checkInFrequency", systemImage: "bolt.fill")
    }
    Spacer()
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

#Preview {
  @Previewable @State var contact = PreviewData().contact
  Form {
    Section {
      HStack {
        ContactContext(contact: contact)
          .labeledContentStyle(ContactRowLabels())
      }
    }
    Section {
      VStack {
        ContactContext(contact: contact)
          .labeledContentStyle(SingleContactLabels())
      }
    }
  }
}
