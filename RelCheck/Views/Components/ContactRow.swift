//
//  ContactRow.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//

import SwiftUI

struct ContactRow: View {
  let contact: Contact
  @Environment(AppNavigator.self) private var navigator

  var body: some View {
    Button {
      navigator.navigate(
        to: .singleContact(id: contact.id)
      )
    } label: {
      HStack(spacing: 8) {
        Circle()
          .foregroundStyle(contact.color)
          .frame(width: 40, height: 40)
          .overlay(
            contact.icon.image
              .resizable()
              .scaledToFit()
              .foregroundStyle(.white)
              .padding(8)
          )

        VStack(alignment: .leading) {
          Text(contact.name).font(.headline)

          HStack(spacing: 16) {
            ContactContext(contact: contact)
          }
          .labeledContentStyle(ContactRowLabels())
        }

        Spacer()

        Image(systemName: "chevron.forward")
          .foregroundStyle(.quaternary)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  @Previewable @State var contact = Contact(
    name: "Anne",
    daysBetweenNotifications: 7,
    icon: .bicycle,
    color: .coral,
  )
  Form {
    ContactRow(contact: contact).environment(AppNavigator())
  }
}
