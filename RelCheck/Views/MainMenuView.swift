//
//  MainMenuView.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/10/2026.
//

import SwiftUI

struct MainMenuView: View {
  @Environment(AppNavigator.self) private var navigator

  var permissionGranted: Bool

  var body: some View {
    List(
      selection: Binding(
        get: { navigator.selectedSection },
        set: { if let section = $0 { navigator.select(section) } },
      )
    ) {
      ForEach(AppDestination.mainMenuItems, id: \.self) { item in
        NavigationLink(value: item) {
          Label(item.menuTitle, systemImage: item.menuIcon)
        }
      }
      if !permissionGranted {
        AuthorizationWarningCard()
          .listRowInsets(EdgeInsets())
          .listRowBackground(Color.clear)
          .animation(.easeInOut, value: permissionGranted)
      }
    }
    .navigationTitle("app.title")
  }
}

#Preview("Sidebar") {
  NavigationSplitView {
    MainMenuView(permissionGranted: false)
  } detail: {
    Text("Detail")
  }
  .environment(AppNavigator())
}
