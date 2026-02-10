//
//  BigRoundButton.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//


import SwiftUI

struct BigRoundButton: ButtonStyle {
    private var foregroundStyle: Color = .white
    private var buttonSize: CGFloat = 48
    
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .frame(width: buttonSize, height: buttonSize)
                .foregroundStyle(foregroundStyle)
                .contentShape(Circle())
                .glassEffect(.regular.tint(.accent).interactive())
        } else {
            configuration.label
                .frame(width: buttonSize, height: buttonSize)
                .foregroundStyle(foregroundStyle)
                .background(Color.accentColor)
                .clipShape(Circle())
        }
    }
}
