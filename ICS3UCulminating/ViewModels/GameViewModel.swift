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
    /// A normalized version of the expression used to detect duplicates (e.g., "3+4" and "4+3" become the same).
    let canonicalForm: String
}

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
    
    /// Possible solutions for the current round.
    var hints: [String] = []
    
    // MARK: - Initializer
    
    /// Initializes the ViewModel with a random game round.
    init() {
        // Create an initial placeholder
        self.currentRound = GameRound(numbers: [1, 2, 3, 4])
        // Generate a real solvable round
        self.startNewGame()
    }
    
    // MARK: - Functions
    
    /// Starts a new round of the game by generating new numbers and resetting the UI state.
    /// This ensures that every round is solvable.
    func startNewGame() {
        var newRound: GameRound
        var solvable: Bool = false
        
        // Loop until we find a set of numbers that can actually reach 24
        repeat {
            newRound = GameRound.generateRandom()
            
            // Check solvability using our internal logic
            var initialItems: [CalculationItem] = []
            for number in newRound.numbers {
                initialItems.append(CalculationItem(value: Double(number), expression: "\(number)", canonicalForm: "\(number)"))
            }
            
            let solutions: [CalculationItem] = solveFor24(items: initialItems)
            if !solutions.isEmpty {
                solvable = true
            }
        } while !solvable
        
        self.currentRound = newRound
        self.userExpression = ""
        self.hints = []
        self.message = "New game started! Find 24."
    }
    
    /// Logic to find solutions for the current numbers.
    func generateHints() {
        // Prepare the initial list of numbers as expressions
        var initialNumbers: [CalculationItem] = []
        for number in currentRound.numbers {
            initialNumbers.append(CalculationItem(value: Double(number), expression: "\(number)", canonicalForm: "\(number)"))
        }
        
        // Find all solutions using the helper function
        let allSolutions: [CalculationItem] = solveFor24(items: initialNumbers)
        
        // Filter to ensure we only have unique "canonical" forms
        var uniqueSolutions: [String] = []
        var seenCanonicals: Set<String> = []
        
        for sol in allSolutions {
            if !seenCanonicals.contains(sol.canonicalForm) {
                seenCanonicals.insert(sol.canonicalForm)
                uniqueSolutions.append(sol.expression)
            }
            // Stop once we have 2 unique solutions
            if uniqueSolutions.count >= 2 { break }
        }
        
        self.hints = uniqueSolutions
        self.message = "Here are some ways to get 24!"
    }
    
    /// Private helper to recursively find solutions.
    private func solveFor24(items: [CalculationItem]) -> [CalculationItem] {
        // If only one item is left, check if it's 24
        if items.count == 1 {
            if abs(items[0].value - 24.0) < 0.0001 {
                return [items[0]]
            }
            return []
        }
        
        var foundSolutions: [CalculationItem] = []
        
        // Try combining every pair of items
        for i in 0..<items.count {
            for j in 0..<items.count {
                if i == j { continue }
                
                let a: CalculationItem = items[i]
                let b: CalculationItem = items[j]
                
                // Keep track of items not used in this pair
                var remaining: [CalculationItem] = []
                for k in 0..<items.count {
                    if k != i && k != j {
                        remaining.append(items[k])
                    }
                }
                
                // Define the 4 operations with normalization for commutative ones (+, *)
                var possibleResults: [CalculationItem] = []
                
                // Addition: (a + b) is same as (b + a), so we sort canonicals
                let addCanon: String = a.canonicalForm < b.canonicalForm ? "(\(a.canonicalForm)+\(b.canonicalForm))" : "(\(b.canonicalForm)+\(a.canonicalForm))"
                possibleResults.append(CalculationItem(value: a.value + b.value, expression: "(\(a.expression) + \(b.expression))", canonicalForm: addCanon))
                
                // Multiplication: (a * b) is same as (b * a)
                let multCanon: String = a.canonicalForm < b.canonicalForm ? "(\(a.canonicalForm)*\(b.canonicalForm))" : "(\(b.canonicalForm)*\(a.canonicalForm))"
                possibleResults.append(CalculationItem(value: a.value * b.value, expression: "(\(a.expression) * \(b.expression))", canonicalForm: multCanon))
                
                // Subtraction: order matters
                possibleResults.append(CalculationItem(value: a.value - b.value, expression: "(\(a.expression) - \(b.expression))", canonicalForm: "(\(a.canonicalForm)-\(b.canonicalForm))"))
                
                // Division: order matters and avoid division by zero
                if abs(b.value) > 0.0001 {
                    possibleResults.append(CalculationItem(value: a.value / b.value, expression: "(\(a.expression) / \(b.expression))", canonicalForm: "(\(a.canonicalForm)/\(b.canonicalForm))"))
                }
                
                // Recurse with the new combined item
                for result in possibleResults {
                    var nextItems: [CalculationItem] = remaining
                    nextItems.append(result)
                    let solutions: [CalculationItem] = solveFor24(items: nextItems)
                    foundSolutions.append(contentsOf: solutions)
                    
                    // Optimization: if we just need a few unique ones, we don't need to find thousands
                    if foundSolutions.count > 50 { break }
                }
                if foundSolutions.count > 50 { break }
            }
            if foundSolutions.count > 50 { break }
        }
        
        return foundSolutions
    }
    
    /// Adds a number to the expression string.
    func addNumberToExpression(_ number: Int) {
        if self.userExpression.isEmpty {
            self.userExpression = "\(number)"
        } else {
            // Add a space before the number for readability
            self.userExpression += " \(number)"
        }
    }
    
    /// Adds a mathematical operator to the expression string.
    func addOperatorToExpression(_ symbol: String) {
        if self.userExpression.isEmpty {
            self.userExpression = symbol
        } else {
            // Add spaces around operators
            self.userExpression += " \(symbol)"
        }
    }
    
    /// Clears the current expression.
    func clearExpression() {
        self.userExpression = ""
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
