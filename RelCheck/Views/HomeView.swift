//
//  HomeView.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppNavigator.self) private var navigator
  
  @Query private var settingsArray: [Settings]
  @Query(sort: \Contact.name) private var contacts: [Contact]
  
  @State private var permissionGranted = false
  @State private var hasReconciledNotifications = false

  var body: some View {
    VStack {
      Button("home.allContacts") {
        navigator.navigate(to: .contacts)
      }
      
      AuthorizationWarningCard(isVisible: !permissionGranted)
    }
    
    .padding()
    
    .navigationTitle("app.title")
    
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          navigator.navigate(to: .settings)
        } label: {
          Label("button.settings", systemImage: "gear")
        }
      }
    }
    
    .task {
      // Check notifications permissions
      NotificationManager.shared.requestPermission { granted in permissionGranted = granted }
      
      // Reconcile notifications
      if !hasReconciledNotifications {
        NotificationManager.shared.reconcileNotifications(contacts: contacts)
        hasReconciledNotifications = true
      }
    }
  }
}

#Preview {
  let container = try! ModelContainer(
    for: Contact.self, Settings.self, configurations: .init(isStoredInMemoryOnly: true))
  
  container.mainContext.insert(
    Contact(
      name: "Anne",
      daysBetweenNotifications: 3,
      icon: .bicycle,
      color: .coral,
    ))
  container.mainContext.insert(
    Contact(
      name: "Roger",
      daysBetweenNotifications: 7,
      icon: .heartFill,
      color: .honey,
    ))
  container.mainContext.insert(
    Contact(
      name: "Marcel",
      daysBetweenNotifications: 14,
      icon: .starFill,
      color: .teal,
    ))
  
  return HomeView().modelContainer(container).environment(AppNavigator())
}
