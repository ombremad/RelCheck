//
//  OnboardingCard.swift
//  notifyme
//
//  Created by Dembo on 13/11/2025.
//

import SwiftUI

struct OnboardingCard: View {
    var title: String
    var message: String
    var imageName: String
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(.purple)
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
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
    }
}
