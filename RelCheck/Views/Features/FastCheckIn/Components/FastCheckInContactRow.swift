//
//  FastCheckInContactRow.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//

import SwiftUI

struct FastCheckInContactRow: View {
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  private var isCompact: Bool { verticalSizeClass == .compact }

  let contact: Contact
  let isSelected: Bool
  let onTap: () -> Void

  var body: some View {
    HStack(spacing: 8) {
      Avatar(contact, mode: isCompact ? .compactList : .list)
      Text(contact.name)
        .font(.headline)
        .foregroundStyle(isSelected ? .white : .primary)
      Spacer()
    }
    .contentShape(Rectangle())
    .listRowBackground(isSelected ? Color.accentColor : nil)
    .onTapGesture(perform: onTap)
  }
}
