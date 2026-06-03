//
//  GameViewModel.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 6/1/26.
//

import Foundation
import Observation

/// The ViewModel that manages the state and logic for the 24 Game.
@Observable
class GameViewModel {
    
    // MARK: - Stored properties
    
    /// The current round of the game.
    var currentRound: GameRound
    
    /// The text entered by the user representing their mathematical expression.
    var userExpression: String = ""
    
    /// A message to display feedback to the user (e.g., "Correct!", "Try again").
    var message: String = "Enter an expression using all four numbers to get 24."
    
    // MARK: - Initializer
    
    /// Initializes the ViewModel with a random game round.
    init() {
        // Generate the first round of numbers
        self.currentRound = GameRound.generateRandom()
    }
    
    // MARK: - Functions
    
    /// Starts a new round of the game by generating new numbers and resetting the UI state.
    func startNewGame() {
        self.currentRound = GameRound.generateRandom()
        self.userExpression = ""
        self.message = "New game started! Find 24."
    }
    
    /// Validates the user's expression and checks if it equals 24.
    func checkAnswer() {
        if userExpression.isEmpty {
            self.message = "Please enter an expression."
            return
        }
        
        // Clean the expression: replace 'x' or '*' with '*' for calculation
        let cleanedExpression: String = userExpression.replacingOccurrences(of: "x", with: "*")
        
        // Use NSExpression to evaluate the mathematical string
        let expression: NSExpression = NSExpression(format: cleanedExpression)
        
        // Attempt to calculate the result
        if let result: Double = expression.expressionValue(with: nil, context: nil) as? Double {
            if result == 24.0 {
                self.message = "Correct! \(userExpression) = 24"
            } else {
                // Formatting the result to remove .0 if it's an integer
                let resultString: String = String(format: "%.1f", result).replacingOccurrences(of: ".0", with: "")
                self.message = "Try again. Your result was \(resultString)."
            }
        } else {
            self.message = "Invalid expression. Use +, -, *, / and ( )."
        }
    }
}
