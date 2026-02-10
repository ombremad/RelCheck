//
//  RootView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext
    @Environment(AppNavigator.self) private var navigator
    
    var body: some View {
        @Bindable var navigator = navigator
        
        if hasCompletedOnboarding {
            NavigationStack(path: $navigator.path) {
                ContactsView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        NavigationDestinationView(destination: destination)
                    }
            }
        } else {
            OnboardingView(onComplete: {
                hasCompletedOnboarding = true
            })
        }
    }    
}
