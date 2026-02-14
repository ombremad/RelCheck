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
            navigator.navigate(to: .singleContact(id: contact.id.uuidString))
        } label: {
            HStack(spacing: 8) {
                Image(systemName: contact.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.secondary)
                    .frame(width: 28, height: 28)
                
                VStack(alignment: .leading) {
                    Text(contact.name)
                        .font(.headline)
                    Text("contacts.everyXDays \(contact.daysBetweenNotifications)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                if let nextNotification = contact.nextUpcomingNotification {
                    Text(String(localized: "contacts.nextCheckInDays \(nextNotification.daysLeftUntilDate)").uppercased())
                        .font(.caption2.bold())
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(LinearGradient.primary)
                        .cornerRadius(12)
                } else {
                    Text("contacts.nextCheckInOverdue")
                        .font(.caption2.bold())
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(LinearGradient.destructive)
                        .cornerRadius(12)
                }
                
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.quaternary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
