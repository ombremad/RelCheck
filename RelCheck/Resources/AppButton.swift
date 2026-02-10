//
//  AppButton.swift
//  RelCheck
//
//  Created by Anne Ferret on 14/11/2025.
//


import SwiftUI

struct AppButton: ButtonStyle {
    private var foregroundStyle: Color = .white
    private var paddingVertical: CGFloat = 6
    private var paddingHorizontal: CGFloat = 16
    
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .foregroundStyle(foregroundStyle)
                .padding(.vertical, paddingVertical)
                .padding(.horizontal, paddingHorizontal)
                .contentShape(Capsule())
                .glassEffect(.regular.tint(.accent).interactive())
        } else {
            configuration.label
                .foregroundStyle(foregroundStyle)
                .padding(.vertical, paddingVertical)
                .padding(.horizontal, paddingHorizontal)
                .background(Color.accentColor)
                .clipShape(Capsule())
        }
    }
}
