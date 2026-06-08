//
//  GameButton.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 6/1/26.
//

import SwiftUI

/// A reusable button component for the 24 Game UI.
struct GameButton: View {
    
    // MARK: - Stored properties
    
    let label: String
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    // MARK: - Computed properties
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: label.count > 2 ? 18 : 24, weight: .bold, design: .rounded))
                .frame(width: width, height: height)
                .background(color.opacity(0.1))
                .foregroundColor(color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    HStack {
        GameButton(label: "7", color: .blue, width: 70, height: 90) {}
        GameButton(label: "+", color: .orange, width: 50, height: 50) {}
    }
}
