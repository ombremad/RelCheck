//
//  HomeFocusSection.swift
//  RelCheck
//
//  Created by Anne Ferret on 21/09/2026.
//

import SwiftUI

struct HomeFocusCard: View {
  @Environment(AppNavigator.self) private var navigator
  @Environment(\.verticalSizeClass) private var verticalSizeClass

  @ScaledMetric(relativeTo: .body) private var cellWidth: CGFloat = 92
  private static let edgeInset: CGFloat = 32

  var card: FocusCardType
  let contacts: [Contact]

  private var isCompact: Bool { verticalSizeClass == .compact }

  enum FocusCardType {
    case overdue, next, history

    var title: LocalizedStringKey {
      switch self {
      case .overdue: "home.overdue.title"
      case .next: "home.next.title"
      case .history: "home.history.title"
      }
    }

    var subtitle: LocalizedStringKey {
      switch self {
      case .overdue: "home.overdue.subtitle"
      case .next: "home.next.subtitle"
      case .history: "home.history.subtitle"
      }
    }

    var icon: String {
      switch self {
      case .overdue: "clock"
      case .next: "arrow.turn.down.right"
      case .history: "list.bullet.indent"
      }
    }

    var color: Color {
      switch self {
      case .overdue: .red
      case .next: .green
      case .history: .cyan
      }
    }
  }

  private var edgeFade: some View {
    HStack(spacing: 0) {
      LinearGradient(
        colors: [.clear, .black],
        startPoint: .leading,
        endPoint: .trailing,
      )
      .frame(width: Self.edgeInset)

      Color.black

      LinearGradient(
        colors: [.black, .clear],
        startPoint: .leading,
        endPoint: .trailing,
      )
      .frame(width: Self.edgeInset)
    }
  }

  private var header: some View {
    HStack {
      Image(systemName: card.icon)
        .font(.title2)
        .accessibilityHidden(true)
      Spacer()
      VStack(alignment: .trailing) {
        Text(card.title)
          .font(.headline)
        if !isCompact {
          Text(card.subtitle)
            .font(.subheadline)
        }
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityAddTraits(.isHeader)
    .listRowBackground(
      LinearGradient(
        colors: [card.color, card.color.opacity(0.25)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing,
      )
    )
  }

  private var contactList: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 6) {
        ForEach(contacts) { contact in
          contactButton(contact)
        }
      }
      .padding(.horizontal, 6)
    }
    .scrollIndicators(.hidden)
    .scrollBounceBehavior(.basedOnSize)
    .mask { edgeFade }
    .fixedSize(horizontal: false, vertical: true)
    .padding(.vertical)
    .listRowInsets(EdgeInsets())
    .listRowBackground(Color(.secondarySystemGroupedBackground))
  }

  private func contactButton(_ contact: Contact) -> some View {
    Button {
      navigator.showContact(contact.id)
    } label: {
      VStack(spacing: isCompact ? 6 : 12) {
        Avatar(contact)
          .accessibilityHidden(true)

        VStack(spacing: 0) {
          Text(contact.name)
            .font(.headline)
            .lineLimit(1)
            .foregroundStyle(Color.primary)

          if !isCompact {
            Text("TBC")
              .font(.subheadline)
              .lineLimit(1)
              .foregroundStyle(Color.secondary)
          }
        }
      }
      .frame(width: cellWidth)
    }
    .buttonStyle(.borderless)
  }

  var body: some View {
    Section {
      header
      contactList
    }
  }
}

#Preview("Regular", traits: .portrait) {
  @Previewable @State var contacts = Preview.contacts

  Form {
    HomeFocusCard(
      card: .overdue,
      contacts: contacts,
    )
    HomeFocusCard(
      card: .next,
      contacts: contacts,
    )
    HomeFocusCard(
      card: .history,
      contacts: contacts,
    )
  }
  .environment(AppNavigator())
}

#Preview("Compact", traits: .landscapeLeft) {
  @Previewable @State var contacts = Preview.contacts

  Form {
    HomeFocusCard(
      card: .overdue,
      contacts: contacts,
    )
    HomeFocusCard(
      card: .next,
      contacts: contacts,
    )
    HomeFocusCard(
      card: .history,
      contacts: contacts,
    )
  }
  .environment(AppNavigator())
}
