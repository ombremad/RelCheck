//
//  OnboardingView .swift
//  notifyme
//
//  Created by Dembo on 13/11/2025.
//
import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void

    var body: some View {
        TabView {
            OnboardingCard(
                title: String(localized: "onboardingCard.01.title"),
                message: String(localized: "onboardingCard.01.message"),
                imageName: "person.line.dotted.person.fill"
            )
            OnboardingCard(
                title: String(localized: "onboardingCard.02.title"),
                message: String(localized: "onboardingCard.02.message"),
                imageName: "person.fill.badge.plus"
            )
            OnboardingCard(
                title: String(localized: "onboardingCard.03.title"),
                message: String(localized: "onboardingCard.03.message"),
                imageName: "bell.badge.fill"
            )
            OnboardingCard(
                title: String(localized: "onboardingCard.04.title"),
                message: String(localized: "onboardingCard.04.message"),
                imageName: "checkmark.message.fill"
            )
            OnboardingCard(
                title: String(localized: "onboardingCard.05.title"),
                message: String(localized: "onboardingCard.05.message"),
                imageName: "hare.fill"
            )
            
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(LinearGradient.primary)
                
                Text("onboarding.ready")
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {
                    onComplete()
                }) {
                    HStack {
                        Spacer()
                        Text("onboarding.button.start")
                            .font(.headline)
                            .padding(6)
                        Spacer()
                    }
                }
                .buttonStyle(AppButton())
                .padding(.horizontal)
            }
            .padding()
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color(.systemGroupedBackground))
    }
}

//#Preview {
//    OnboardingView()
//}
