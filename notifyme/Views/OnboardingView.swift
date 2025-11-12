//
//  OnboardingView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI

struct Onboarding: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("onboarding.notificationTitle")
                    .font(.title)
                Text("onboarding.notificationExplanation")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            Button("onboarding.button.requestNotificationsAccess") {}
                .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }
}

#Preview {
    Onboarding()
}
