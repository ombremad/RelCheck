//
//  OnboardingView.swift
//  RelCheck
//
//  Created by Dembo on 13/11/2025.
//

import SwiftUI

struct OnboardingView: View {
  @State private var showSkipAlert = false

  let completeOnboarding: () -> Void

  private static let cards: [OnboardingCard] = [
    OnboardingCard(
      title: "onboardingCard.01.title",
      message: "onboardingCard.01.message",
      imageName: "person.line.dotted.person.fill",
    ),
    OnboardingCard(
      title: "onboardingCard.02.title",
      message: "onboardingCard.02.message",
      imageName: "person.fill.badge.plus",
    ),
    OnboardingCard(
      title: "onboardingCard.03.title",
      message: "onboardingCard.03.message",
      imageName: "bell.badge.fill",
    ),
    OnboardingCard(
      title: "onboardingCard.04.title",
      message: "onboardingCard.04.message",
      imageName: "checkmark.message.fill",
    ),
    OnboardingCard(
      title: "onboardingCard.05.title",
      message: "onboardingCard.05.message",
      imageName: "hare.fill",
    ),
  ]

  private var finalPage: some View {
    VStack(spacing: 20) {
      Image(systemName: "sparkles")
        .font(.system(size: 60))
        .foregroundStyle(LinearGradient.primary)

      Text("onboarding.ready")
        .font(.title)
        .fontWeight(.bold)

      Button {
        completeOnboarding()
      } label: {
        Text("onboarding.button.start")
          .font(.headline)
          .padding(.vertical, 6)
          .padding(.horizontal, 32)
      }
      .buttonStyle(GlassButton())
    }
    .padding(.horizontal)
  }

  var body: some View {
    NavigationStack {
      VStack {
        TabView {
          ForEach(Array(Self.cards.enumerated()), id: \.offset) { _, card in
            card.padding(.horizontal)
          }

          finalPage
        }
      }
      .tabViewStyle(.page)
      .indexViewStyle(.page(backgroundDisplayMode: .always))
      .background(Color(.systemGroupedBackground))

      .alert(isPresented: $showSkipAlert) {
        Alert(
          title: Text("onboarding.skipAlert.title"),
          message: Text("onboarding.skipAlert.message"),
          primaryButton: .default(Text("button.cancel")),
          secondaryButton: .destructive(
            Text("button.ok"),
            action: completeOnboarding,
          ),
        )
      }

      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button {
            showSkipAlert.toggle()
          } label: {
            Label("onboarding.skip", systemImage: "xmark")
          }
        }
      }
    }
  }
}

#Preview {
  OnboardingView(completeOnboarding: {})
}
