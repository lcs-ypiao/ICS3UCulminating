//
//  CheckAnswer.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 6/1/26.
//

import Foundation

/// A utility to evaluate mathematical expressions entered by the user.
struct CheckAnswer {
    
    // MARK: - Functions
    
    /// Evaluates a string expression and returns the result and a feedback message.
    /// - Parameter expressionString: The raw string from the user (e.g., "(7 - 1) x 4").
    /// - Returns: A tuple containing the numeric result (if valid) and a feedback message.
    static func evaluate(_ expressionString: String) -> (result: Double?, message: String) {
        if expressionString.isEmpty {
            return (nil, "Please enter an expression.")
        }
        
        // Clean the expression: replace 'x' with '*' for calculation
        let cleanedExpression: String = expressionString.replacingOccurrences(of: "x", with: "*")
        
        // Use NSExpression to evaluate the mathematical string
        let expression: NSExpression = NSExpression(format: cleanedExpression)
        
        // Attempt to calculate the result
        if let result: Double = expression.expressionValue(with: nil, context: nil) as? Double {
            if result == 24.0 {
                return (result, "Correct! \(expressionString) = 24")
            } else {
                // Formatting the result to remove .0 if it's an integer
                let resultString: String = String(format: "%.1f", result).replacingOccurrences(of: ".0", with: "")
                return (result, "Try again. Your result was \(resultString).")
            }
        } else {
            return (nil, "Invalid expression. Use +, -, *, / and ( ).")
        }
    }
}
