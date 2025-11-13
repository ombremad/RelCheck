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
                title: "Reste proche de tes proches 💞",
                message: "Prendre contact avec ceux qu’on aime renforce ton bien-être et ta joie de vivre.",
                imageName: "person.2.fill"
            )
            
            OnboardingCard(
                title: "Un petit geste chaque semaine 🌿",
                message: "Une notification douce te rappellera de créer du lien, un pas à la fois.",
                imageName: "bell.badge.fill"
            )
            
            OnboardingCard(
                title: "Crée des souvenirs durables ✨",
                message: "Partage un message, un appel ou un sourire. Les liens sincères font grandir ton cœur.",
                imageName: "heart.circle.fill"
            )
            
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Prêt à nourrir tes liens ?")
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text("Commencer 🌸")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
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
