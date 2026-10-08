//
//  Avatar.swift
//  RelCheck
//
//  Created by Anne Ferret on 21/09/2026.
//

import SwiftUI

struct Avatar: View {
  @ScaledMetric(relativeTo: .body) private var size: CGFloat = 40

  var contact: Contact

  init(_ contact: Contact) {
    self.contact = contact
  }

  var body: some View {
    Circle()
      .foregroundStyle(contact.color)
      .frame(width: size, height: size)
      .overlay(
        contact.icon.image
          .resizable()
          .scaledToFit()
          .foregroundStyle(.white)
          .padding(8)
      )
      .accessibilityHidden(true)
  }
}

#Preview {
  Avatar(Preview.contact)
}
