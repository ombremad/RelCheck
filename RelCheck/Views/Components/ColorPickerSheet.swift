//
//  ColorPickerSheet.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct ColorPickerSheet: View {
  @Binding var selectedColor: ContactColor
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
        ForEach(ContactColor.allCases, id: \.self) { color in
          ZStack {
            Circle()
              .foregroundStyle(selectedColor == color ? .accent : .clear)
              .frame(width: 42, height: 42)
            Circle()
              .foregroundStyle(color)
              .frame(width: 32, height: 32)
          }
          .onTapGesture {
            selectedColor = color
            dismiss()
          }
        }
      }
      .padding()
    }
  }
}
