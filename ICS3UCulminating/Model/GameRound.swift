//
//  GameRound.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 6/1/26.
//

import Foundation

/// Represents a single round of the 24 Game.
struct GameRound {
    
    // MARK: - Stored properties
    
    /// The four integers used in the game.
    let numbers: [Int]
    
    // MARK: - Initializer
    
    /// Initializes a new game round with four numbers.
    /// - Parameter numbers: An array of exactly four integers.
    init(numbers: [Int]) {
        self.numbers = numbers
    }
    
    // MARK: - Functions
    
    /// Generates a new random round of the 24 Game.
    /// - Returns: A GameRound with four random numbers between 1 and 13.
    static func generateRandom() -> GameRound {
        var randomNumbers: [Int] = []
        
        // Keep generating numbers until we have exactly 4
        while randomNumbers.count < 4 {
            let randomValue: Int = Int.random(in: 1...13)
            
            // Count how many times this specific number has already been added
            var occurrences: Int = 0
            for number in randomNumbers {
                if number == randomValue {
                    occurrences += 1
                }
            }
            
            // Only add the number if it appears at most twice (maximum of 2 same numbers)
            if occurrences < 2 {
                randomNumbers.append(randomValue)
            }
        }
        
        return GameRound(numbers: randomNumbers)
    }
}
