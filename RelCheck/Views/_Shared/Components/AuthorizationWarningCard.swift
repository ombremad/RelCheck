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
            Text("authorizationWarning.contentCompact")
              .font(.subheadline)
          } else {
            Text("authorizationWarning.title")
              .font(.headline)
              .foregroundStyle(.black.opacity(0.4))
            Text("authorizationWarning.content")
              .font(.subheadline)
          }
        }
        Spacer(minLength: 0)
      }
      .foregroundStyle(.black)
      .padding()
      .background(
        LinearGradient(
          colors: [.yellow, .yellow.opacity(0.5)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing,
        ),
        in: .rect(cornerRadius: Constants.Layout.cornerRadius),
      )
    }
    .buttonStyle(.plain)
  }
}

#Preview("Regular", traits: .portrait) {
  AuthorizationWarningCard()
    .padding()
}

#Preview("Compact", traits: .landscapeLeft) {
  AuthorizationWarningCard()
    .padding()
}
