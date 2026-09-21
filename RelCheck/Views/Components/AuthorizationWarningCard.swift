//
//  AuthorizationWarningCard.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct AuthorizationWarningCard: View {
  var body: some View {
    Section {
      Button {
        NotificationManager.shared.openSettings()
      } label: {
        HStack(alignment: .top, spacing: 12) {
          Image(systemName: "exclamationmark.circle")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 38)
          VStack(alignment: .leading) {
            Text("contacts.authorizationWarning.title")
              .font(.headline)
              .foregroundStyle(.black.opacity(0.4))
            Text("contacts.authorizationWarning.content")
              .font(.subheadline)
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

#Preview {
  Form {
    AuthorizationWarningCard()
  }
}
