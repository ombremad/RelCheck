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
            Image(systemName: contact.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(isSelected ? .white : .secondary)
                .frame(width: 28, height: 28)
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
