//
//  OnboardingView .swift
//  notifyme
//
//  Created by Dembo on 13/11/2025.
//
import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        TabView {
            OnboardingCard(
                title: String(localized: "onboardingCard.01.title"),
                message: String(localized: "onboardingCard.01.message"),
                imageName: "person.2.fill"
            )
            OnboardingCard(
                title: String(localized: "onboardingCard.02.title"),
                message: String(localized: "onboardingCard.02.message"),
                imageName: "bell.badge.fill"
            )
            OnboardingCard(
                title: String(localized: "onboardingCard.03.title"),
                message: String(localized: "onboardingCard.03.message"),
                imageName: "heart.circle.fill"
            )
            
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(LinearGradient.primary)
                
                Text("onboarding.ready")
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("onboarding.button.start")
                            .font(.headline)
                            .padding(6)
                        Spacer()
                    }
                }
                .buttonStyle(.glassProminent)
                .padding(.horizontal)
            }
            .padding()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    OnboardingView()
}
