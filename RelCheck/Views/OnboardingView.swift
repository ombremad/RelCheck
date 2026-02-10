//
//  OnboardingView .swift
//  notifyme
//
//  Created by Dembo on 13/11/2025.
//
import SwiftUI

struct OnboardingView: View {
    @State private var lastScreen: Bool = false
    let completeOnboarding: () -> Void

    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button {
                    completeOnboarding()
                } label: {
                    Text("onboarding.skip")
                }
                .buttonStyle(AppButton())
            }
            
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
                    
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("onboarding.button.start")
                            .font(.headline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 32)
                    }
                    .buttonStyle(AppButton())
                }
            }
        }
        .padding()
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color(.systemGroupedBackground))
    }
}

//#Preview {
//    OnboardingView()
//}
