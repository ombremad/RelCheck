//
//  AuthorizationWarningCard.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct AuthorizationWarningCard: View {
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  @Environment(\.scenePhase) private var scenePhase

  @State private var permissionGranted: Bool?

  private var isCompact: Bool { verticalSizeClass == .compact }

  var body: some View {
    Group {
      if permissionGranted == false {
        card
      } else {
        Color.clear.frame(width: 0, height: 0)
      }
    }
    .animation(.easeInOut, value: permissionGranted)
    .task { checkPermission() }

    .onChange(of: scenePhase) { _, phase in
      if phase == .active { checkPermission() }
    }
  }

  private var card: some View {
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
              .foregroundStyle(Color.warningTitle)
            Text("authorizationWarning.content")
              .font(.subheadline)
          }
        }
        Spacer(minLength: 0)
      }
      .foregroundStyle(Color.warningForeground)
      .padding()
      .background(
        LinearGradient.warning,
        in: .rect(cornerRadius: Constants.Layout.cornerRadius),
      )
    }
    .buttonStyle(.plain)
  }

  private func checkPermission() {
    NotificationManager.shared.requestPermission { granted in
      permissionGranted = granted
    }
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
