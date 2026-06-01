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
    
    /// Validates the user's expression.
    /// Note: Full expression parsing will be implemented in a later step.
    func checkAnswer() {
        // This is a placeholder for the logic that will calculate the result
        // of the user's expression and compare it to 24.
        if userExpression.isEmpty {
            self.message = "Please enter an expression."
        } else {
            self.message = "Checking expression..."
            // Logic for evaluation goes here
        }
    }
}
