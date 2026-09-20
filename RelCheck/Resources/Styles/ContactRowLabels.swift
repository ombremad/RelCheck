//
//  ContactRowLabels.swift
//  RelCheck
//
//  Created by Anne Ferret on 11/04/2026.
//

import SwiftUI

struct ContactRowLabels: LabeledContentStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
        .labelStyle(.iconOnly)
        .frame(width: 8, alignment: .center)
      configuration.content
        .foregroundStyle(.secondary)
        .fontWeight(.medium)
    }
    .font(.caption)
  }
}
