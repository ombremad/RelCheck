//
//  SingleContactLabels.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct SingleContactLabels: LabeledContentStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
        .labelStyle(.iconOnly)
        .frame(width: Constants.Layout.labelIconWidth, alignment: .center)
      configuration.label
        .labelStyle(.titleOnly)
        .font(.callout)
      Spacer()
      configuration.content
        .foregroundStyle(.secondary)
        .fontWeight(.medium)
    }
  }
}
