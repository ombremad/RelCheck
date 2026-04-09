//
//  FastCheckInContactRow.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//

import SwiftUI

struct FastCheckInContactRow: View {
  let contact: Contact
  let isSelected: Bool
  let onTap: () -> Void

  var body: some View {
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
