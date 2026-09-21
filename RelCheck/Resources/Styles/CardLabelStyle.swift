//
//  CardLabelStyle.swift
//  RelCheck
//
//  Created by Anne Ferret on 21/09/2026.
//

import SwiftUI

struct CardLabelStyle: LabelStyle {
  var spacing: CGFloat = 8

  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: spacing) {
      configuration.icon
      configuration.title
    }
  }
}
