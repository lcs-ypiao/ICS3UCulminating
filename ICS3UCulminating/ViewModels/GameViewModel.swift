//
//  GameViewModel.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 6/1/26.
//

import Foundation
import Observation

/// Helper struct to keep track of a value and its mathematical string representation.
struct CalculationItem {
    let value: Double
    let expression: String
    /// A normalized version of the expression used to detect duplicates.
    let canonicalForm: String
}

/// The main ViewModel that orchestrates the 24 Game.
/// It delegates heavy logic to HintSolver and CheckAnswer.
@Observable
class GameViewModel {
    
    // MARK: - Stored properties
    
    /// The current round of the game.
    var currentRound: GameRound
    
    /// The text entered by the user representing their mathematical expression.
    var userExpression: String = ""
    
    /// A message to display feedback to the user.
    var message: String = "Enter an expression using all four numbers to get 24."
    
    /// Possible unique solutions for the current round.
    var hints: [String] = []
    
    // MARK: - Initializer
    
    /// Initializes the ViewModel and ensures the first round is solvable.
    init() {
        self.currentRound = GameRound(numbers: [1, 2, 3, 4])
        self.startNewGame()
    }
    
    // MARK: - Functions
    
    /// Starts a new solvable round and resets the UI state.
    func startNewGame() {
        var newRound: GameRound
        repeat {
            newRound = GameRound.generateRandom()
        } while !HintSolver.hasSolution(for: newRound.numbers)
        
        self.currentRound = newRound
        self.userExpression = ""
        self.hints = []
        self.message = "New game started! Find 24."
    }
    
    /// Generates up to two unique hints using the HintSolver.
    func generateHints() {
        self.hints = HintSolver.findUniqueSolutions(for: currentRound.numbers)
        self.message = "Here are some ways to get 24!"
    }
    
    /// Validates the user's answer using the CheckAnswer utility.
    func checkAnswer() {
        let evaluation: (result: Double?, message: String) = CheckAnswer.evaluate(userExpression)
        self.message = evaluation.message
    }
    
    /// Adds a number to the expression string.
    func addNumberToExpression(_ number: Int) {
        if self.userExpression.isEmpty {
            self.userExpression = "\(number)"
        } else {
            self.userExpression += " \(number)"
        }
    }
    
    /// Adds a mathematical operator to the expression string.
    func addOperatorToExpression(_ symbol: String) {
        if self.userExpression.isEmpty {
            self.userExpression = symbol
        } else {
            self.userExpression += " \(symbol)"
        }
    }
    
    /// Clears the current expression.
    func clearExpression() {
        self.userExpression = ""
    }
}
