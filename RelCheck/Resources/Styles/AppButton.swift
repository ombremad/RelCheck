//
//  AppButton.swift
//  RelCheck
//
//  Created by Anne Ferret on 14/11/2025.
//

import SwiftUI

struct AppButton: ButtonStyle {
  private var foregroundStyle: Color = .white
  private var vPadding: CGFloat = 6
  private var hPadding: CGFloat = 16

  func makeBody(configuration: Configuration) -> some View {
    let baseView = configuration.label
      .foregroundStyle(foregroundStyle)
      .padding(.vertical, vPadding)
      .padding(.horizontal, hPadding)

    if #available(iOS 26.0, *) {
      return
        baseView
        .contentShape(Capsule())
        .glassEffect(.regular.tint(.accent).interactive())
    } else {
      return
        baseView
        .background(Color.accentColor)
        .clipShape(Capsule())
    }
  }
}
