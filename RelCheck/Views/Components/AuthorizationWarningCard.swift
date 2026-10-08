//
//  AuthorizationWarningCard.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct AuthorizationWarningCard: View {
  @Environment(\.verticalSizeClass) private var verticalSizeClass

  private var isCompact: Bool { verticalSizeClass == .compact }

  var body: some View {
    Section {
      Button {
        NotificationManager.shared.openSettings()
      } label: {
        HStack(alignment: .top, spacing: 12) {
          Image(systemName: "exclamationmark.circle")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: isCompact ? 22 : 38)
          VStack(alignment: .leading) {
            if isCompact {
              Text("contacts.authorizationWarning.contentCompact")
                .font(.subheadline)
            } else {
              Text("contacts.authorizationWarning.title")
                .font(.headline)
                .foregroundStyle(.black.opacity(0.4))
              Text("contacts.authorizationWarning.content")
                .font(.subheadline)
            }
          }
        }
        .foregroundStyle(.black)
      }
      .listRowBackground(
        LinearGradient(
          colors: [.yellow, .yellow.opacity(0.5)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing,
        )
      )
    }
  }
}

#Preview("Regular", traits: .portrait) {
  Form {
    AuthorizationWarningCard()
  }
}

#Preview("Compact", traits: .landscapeLeft) {
  Form {
    AuthorizationWarningCard()
  }
}
