//
//  OnboardingCard.swift
//  notifyme
//
//  Created by Dembo on 13/11/2025.
//

import SwiftUI

struct OnboardingCard: View {
  var title: LocalizedStringKey
  var message: LocalizedStringKey
  var imageName: String

  var body: some View {
    VStack(spacing: 30) {
      HeroSymbol(imageName)
        .padding(.top, 60)

      Text(title)
        .font(.title)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Text(message)
        .font(.body)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .foregroundStyle(.secondary)

      Spacer()
    }
    .padding()
  }
}
