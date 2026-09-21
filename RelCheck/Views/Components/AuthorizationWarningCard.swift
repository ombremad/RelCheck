//
//  AuthorizationWarningCard.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct AuthorizationWarningCard: View {
  let isVisible: Bool

  var card: some View {
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
    .padding(.vertical, 16)
    .padding(.horizontal, 28)
    .foregroundStyle(.black)
    .background(Color.yellow)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  var body: some View {
    if isVisible {
      card
    } else {
      EmptyView()
    }
  }
}

#Preview {
  AuthorizationWarningCard(isVisible: true)
    .padding()
}
