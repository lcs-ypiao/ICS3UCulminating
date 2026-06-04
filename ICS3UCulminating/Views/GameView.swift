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
            
            // Display the four numbers (now clickable)
            HStack(spacing: 15) {
                ForEach(0..<viewModel.currentRound.numbers.count, id: \.self) { index in
                    let number: Int = viewModel.currentRound.numbers[index]
                    
                    Button(action: {
                        viewModel.addNumberToExpression(number)
                    }) {
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
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top)
            
            // Symbol Buttons
            HStack(spacing: 15) {
                let symbols: [String] = ["+", "-", "x", "/"]
                ForEach(symbols, id: \.self) { symbol in
                    Button(action: {
                        viewModel.addOperatorToExpression(symbol)
                    }) {
                        Text(symbol)
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 50, height: 50)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .clipShape(Circle())
                    }
                }
                
                // Brackets
                Button(action: { viewModel.addOperatorToExpression("(") }) {
                    Text("(")
                        .font(.title2)
                        .frame(width: 45, height: 45)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .clipShape(Circle())
                }
                
                Button(action: { viewModel.addOperatorToExpression(")") }) {
                    Text(")")
                        .font(.title2)
                        .frame(width: 45, height: 45)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .clipShape(Circle())
                }
            }
            .padding(.bottom)
            
            // Expression Input
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Hint Button replaces the "Your Expression" label
                    Button(action: {
                        viewModel.generateHints()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "lightbulb.fill")
                            Text("Get Hint")
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button("Clear") {
                        viewModel.clearExpression()
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
                
                TextField("e.g., (7 - 1) * 4", text: $viewModel.userExpression)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // Display up to two hints if they have been generated
                if !viewModel.hints.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Try one of these:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        ForEach(viewModel.hints, id: \.self) { hint in
                            Text(hint)
                                .font(.system(.footnote, design: .monospaced))
                                .foregroundColor(.orange)
                                .padding(6)
                                .background(Color.orange.opacity(0.05))
                                .cornerRadius(4)
                        }
                    }
                    .padding(.top, 4)
                }
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
