//
//  Avatar.swift
//  RelCheck
//
//  Created by Anne Ferret on 21/09/2026.
//

import SwiftUI

struct Avatar: View {
  enum AvatarMode { case list, compactList, contact, compactContact }

  let contact: Contact
  let mode: AvatarMode

  @ScaledMetric private var size: CGFloat

  init(_ contact: Contact, mode: AvatarMode = .list) {
    self.contact = contact
    self.mode = mode

    let baseSize: CGFloat =
      switch mode {
      case .list: 40
      case .compactList: 24
      case .contact: 120
      case .compactContact: 60
      }
    _size = ScaledMetric(wrappedValue: baseSize, relativeTo: .body)
  }

  private var padding: CGFloat {
    switch mode {
    case .list: 8
    case .compactList: 2
    case .contact: 24
    case .compactContact: 12
    }
  }

  private var opacity: CGFloat {
    switch mode {
    case .contact, .compactContact: 0.25
    default: 1
    }
  }

  private var circleColor: Color {
    switch mode {
    case .contact, .compactContact: .primary
    default: contact.color.color
    }
  }

  var body: some View {
    Circle()
      .foregroundStyle(circleColor)
      .frame(width: size, height: size)
      .opacity(opacity)
      .overlay(
        contact.icon.image
          .resizable()
          .scaledToFit()
          .foregroundStyle(.white)
          .padding(padding)
      )
      .accessibilityHidden(true)
  }
}

#Preview {
  Avatar(Preview.contact)
}
