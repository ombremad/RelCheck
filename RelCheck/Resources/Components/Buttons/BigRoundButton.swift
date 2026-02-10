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
        let baseView = configuration.label
            .frame(width: buttonSize, height: buttonSize)
            .foregroundStyle(foregroundStyle)
            .labelStyle(.iconOnly)
        
        if #available(iOS 26.0, *) {
            return baseView
                .contentShape(Circle())
                .glassEffect(.regular.tint(.accent).interactive())
        } else {
            return baseView
                .contentShape(Circle())
                .background(Color.accentColor)
                .clipShape(Circle())
        }
    }
}
