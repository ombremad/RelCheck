//
//  HeroSymbol.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/10/2026.
//

import SwiftUI

struct HeroSymbol: View {
  @ScaledMetric(relativeTo: .largeTitle) private var size = Constants.Layout.heroIconSize

  let systemName: String

  init(_ systemName: String) {
    self.systemName = systemName
  }

  var body: some View {
    Image(systemName: systemName)
      .font(.system(size: size))
      .foregroundStyle(LinearGradient.primary)
  }
}

#Preview {
  HeroSymbol("sparkles")
}
