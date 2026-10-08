//
//  HomeActionCards.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/10/2026.
//

import SwiftUI

struct HomeActionCards: View {
  @Environment(AppNavigator.self) private var navigator
  @Environment(\.verticalSizeClass) private var verticalSizeClass

  private var isCompact: Bool { verticalSizeClass == .compact }

  private enum Card: CaseIterable {
    case fastCheckIn, addContact, allContacts

    var title: LocalizedStringKey {
      switch self {
      case .addContact: return "home.button.addContact.title"
      case .allContacts: return "home.button.allContacts.title"
      case .fastCheckIn: return "home.button.fastCheckIn.title"
      }
    }

    var icon: String {
      switch self {
      case .addContact: return "plus.circle"
      case .allContacts: return "person.3"
      case .fastCheckIn: return "hare"
      }
    }

    var color: Color {
      switch self {
      case .addContact: return .indigo
      case .allContacts: return .pink
      case .fastCheckIn: return .purple
      }
    }

    var destination: AppDestination {
      switch self {
      case .addContact: return .newContact
      case .allContacts: return .contactList
      case .fastCheckIn: return .fastCheckIn
      }
    }

    var gradient: LinearGradient {
      LinearGradient(
        colors: [color, color.opacity(0.5)],
        startPoint: .center,
        endPoint: .bottomTrailing,
      )
    }
  }

  private var contentLayout: AnyLayout {
    isCompact
      ? AnyLayout(HStackLayout(spacing: 8))
      : AnyLayout(VStackLayout(spacing: 8))
  }

  var body: some View {
    HStack(spacing: 8) {
      ForEach(Card.allCases, id: \.self) { card in
        button(for: card)
      }
    }
    .listRowInsets(EdgeInsets())
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
  }

  private func button(for card: Card) -> some View {
    Button {
      navigator.push(card.destination)
    } label: {
      contentLayout {
        Image(systemName: card.icon)
          .font(.title2)
        Text(card.title)
          .font(.headline)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
      }
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity, minHeight: isCompact ? 56 : 96)
      .padding(.horizontal, 8)
      .background(
        card.gradient,
        in: .rect(cornerRadius: Constants.Layout.cornerRadius),
      )
    }
    .buttonStyle(.borderless)
  }
}

#Preview("Regular", traits: .portrait) {
  Form {
    Section {
      HomeActionCards()
    }
  }
  .environment(AppNavigator())
}

#Preview("Compact", traits: .landscapeLeft) {
  Form {
    Section {
      HomeActionCards()
    }
  }
  .environment(AppNavigator())
}
