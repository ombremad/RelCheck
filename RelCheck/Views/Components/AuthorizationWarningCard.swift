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
          Button("contacts.authorizationWarning.openSettings") {
            NotificationManager.shared.openSettings()
          }
          .buttonStyle(AppButton())
        }
      }
      .foregroundStyle(.black)
    }
    .listRowBackground(Color.yellow)
  }
}

#Preview {
  Form {
    AuthorizationWarningCard()
  }
}
