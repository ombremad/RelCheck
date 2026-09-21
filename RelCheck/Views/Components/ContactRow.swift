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

  var body: some View {
    Button {
      navigator.navigate(
        to: .singleContact(id: contact.id)
      )
    } label: {
      HStack(spacing: 8) {
        Avatar(contact)

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
  @Previewable @State var contact = Preview.contact
  Form {
    ContactRow(contact: contact).environment(AppNavigator())
  }
}
