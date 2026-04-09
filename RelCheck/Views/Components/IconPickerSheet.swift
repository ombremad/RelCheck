//
//  IconPickerSheet.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/04/2026.
//

import SwiftUI

struct IconPickerSheet: View {
  @Binding var selectedIcon: ContactIcon
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
          ForEach(ContactIcon.allCases, id: \.self) { icon in
            icon.image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundStyle(selectedIcon == icon ? .accent : .primary)
              .frame(width: 36, height: 36)
              .onTapGesture {
                selectedIcon = icon
                dismiss()
              }
          }
        }
        .padding(.horizontal).padding(.vertical, 32)
      }
    }
  }
}
