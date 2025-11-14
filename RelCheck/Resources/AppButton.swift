//
//  AppButton.swift
//  RelCheck
//
//  Created by Anne Ferret on 14/11/2025.
//


import SwiftUI

struct AppButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .foregroundStyle(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 16)
                .glassEffect(.regular.tint(.accent).interactive())
        } else {
            configuration.label
                .foregroundStyle(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 16)
                .background(.accent)
                .clipShape(.capsule)
        }
    }
}
