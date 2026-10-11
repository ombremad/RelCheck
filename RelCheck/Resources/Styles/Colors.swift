//
//  Colors.swift
//  notifyme
//
//  Created by Anne Ferret on 13/11/2025.
//

import SwiftUI

extension Color {
  static let warningForeground = Color.black
  static let warningTitle = Color.black.opacity(0.4)
  static let contactCardForeground = Color.white.opacity(0.85)
}

extension LinearGradient {
  static func fade(_ color: Color, to opacity: Double, from start: UnitPoint, to end: UnitPoint) -> LinearGradient {
    LinearGradient(colors: [color, color.opacity(opacity)], startPoint: start, endPoint: end)
  }

  static let warning = fade(.yellow, to: 0.5, from: .topLeading, to: .bottomTrailing)

  static func highlight(_ color: Color) -> LinearGradient {
    fade(color, to: 0.6, from: .center, to: .topTrailing)
  }

  static func subtleBackground(_ color: Color) -> LinearGradient {
    LinearGradient(
      stops: [
        .init(color: color.opacity(0.3), location: 0),
        .init(color: Color(.systemGroupedBackground), location: 0.4),
      ],
      startPoint: .top,
      endPoint: .bottomLeading,
    )
  }

  static let primary = LinearGradient(
    colors: [.indigo, .mint],
    startPoint: .top,
    endPoint: .bottom,
  )
  static let destructive = LinearGradient(
    colors: [.orange, .red],
    startPoint: .top,
    endPoint: .bottom,
  )
}
