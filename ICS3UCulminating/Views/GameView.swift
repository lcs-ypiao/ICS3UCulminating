//
//  GameView.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 6/1/26.
//

import SwiftUI

/// The main View for the 24 Game.
struct GameView: View {
    
    // MARK: - Stored properties
    
    /// The ViewModel that drives this view.
    /// In SwiftUI with the Observation framework, we can use @State for reference types
    /// when the view owns the object.
    @State private var viewModel: GameViewModel = GameViewModel()
    
    // MARK: - Computed properties
    
    /// The user interface layout.
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("24 Game")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Instructions/Feedback
            Text(viewModel.message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: 60)
            
            // Display the four numbers
            HStack(spacing: 15) {
                // Using indices to handle potential duplicate numbers correctly
                ForEach(0..<viewModel.currentRound.numbers.count, id: \.self) { index in
                    let number: Int = viewModel.currentRound.numbers[index]
                    
                    Text("\(number)")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .frame(width: 70, height: 90)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
            }
            .padding(.vertical)
            
            // Expression Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Expression:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("e.g., (7 - 1) * 4", text: $viewModel.userExpression)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal)
            
            // Action Buttons
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.checkAnswer()
                }) {
                    Text("Check Answer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.startNewGame()
                }) {
                    Text("New Game")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    GameView()
}
