//
//  HomeActionCard.swift
//  RelCheck
//
//  Created by Anne Ferret on 21/09/2026.
//

import SwiftUI

struct HomeActionCard: View {
  @Environment(AppNavigator.self) private var navigator

  var card: ActionCardType

  init(_ card: ActionCardType) {
    self.card = card
  }

  enum ActionCardType {
    case addContact, allContacts, fastCheckIn

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
      case .allContacts: return .contacts
      case .fastCheckIn: return .fastCheckIn
      }
    }
  }

  var body: some View {
    Button {
      navigator.push(card.destination)
    } label: {
      Label {
        Text(card.title)
          .font(.headline)
          .lineLimit(1)
      } icon: {
        Image(systemName: card.icon)
          .font(.title2)
      }
      .labelStyle(CardLabelStyle())
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity, minHeight: 64)
      .padding(.horizontal)
    }
    .buttonStyle(.borderless)
    .listRowSeparator(.hidden)
    .listRowInsets(EdgeInsets())
    .listRowBackground(
      LinearGradient(
        colors: [card.color, card.color.opacity(0.5)],
        startPoint: .center,
        endPoint: .bottomTrailing,
      )
    )
  }
}

#Preview {
  Form {
    Section {
      HomeActionCard(.addContact)
      HomeActionCard(.fastCheckIn)
      HomeActionCard(.allContacts)
    }
  }
  .environment(AppNavigator())
}
