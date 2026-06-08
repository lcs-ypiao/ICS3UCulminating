//
//  HintSolver.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 6/1/26.
//

import Foundation

/// A specialized engine to find mathematical solutions for the 24 Game.
struct HintSolver {
    
    // MARK: - Functions
    
    /// Finds up to two unique, meaningfully different solutions for the given numbers.
    /// - Parameter numbers: An array of 4 integers.
    /// - Returns: An array of unique solution strings.
    static func findUniqueSolutions(for numbers: [Int]) -> [String] {
        var initialItems: [CalculationItem] = []
        for number in numbers {
            initialItems.append(CalculationItem(value: Double(number), expression: "\(number)", canonicalForm: "\(number)"))
        }
        
        let allSolutions: [CalculationItem] = solve(items: initialItems)
        
        var uniqueSolutions: [String] = []
        var seenCanonicals: Set<String> = []
        
        for sol in allSolutions {
            if !seenCanonicals.contains(sol.canonicalForm) {
                seenCanonicals.insert(sol.canonicalForm)
                uniqueSolutions.append(sol.expression)
            }
            if uniqueSolutions.count >= 2 { break }
        }
        
        return uniqueSolutions
    }
    
    /// Checks if a set of numbers has at least one valid solution.
    static func hasSolution(for numbers: [Int]) -> Bool {
        var initialItems: [CalculationItem] = []
        for number in numbers {
            initialItems.append(CalculationItem(value: Double(number), expression: "\(number)", canonicalForm: "\(number)"))
        }
        return !solve(items: initialItems).isEmpty
    }
    
    /// Internal recursive solver.
    private static func solve(items: [CalculationItem]) -> [CalculationItem] {
        if items.count == 1 {
            if abs(items[0].value - 24.0) < 0.0001 {
                return [items[0]]
            }
            return []
        }
        
        var foundSolutions: [CalculationItem] = []
        
        for i in 0..<items.count {
            for j in 0..<items.count {
                if i == j { continue }
                
                let a: CalculationItem = items[i]
                let b: CalculationItem = items[j]
                
                var remaining: [CalculationItem] = []
                for k in 0..<items.count {
                    if k != i && k != j {
                        remaining.append(items[k])
                    }
                }
                
                var possibleResults: [CalculationItem] = []
                
                // Addition
                let addCanon: String = a.canonicalForm < b.canonicalForm ? "(\(a.canonicalForm)+\(b.canonicalForm))" : "(\(b.canonicalForm)+\(a.canonicalForm))"
                possibleResults.append(CalculationItem(value: a.value + b.value, expression: "(\(a.expression) + \(b.expression))", canonicalForm: addCanon))
                
                // Multiplication
                let multCanon: String = a.canonicalForm < b.canonicalForm ? "(\(a.canonicalForm)*\(b.canonicalForm))" : "(\(b.canonicalForm)*\(a.canonicalForm))"
                possibleResults.append(CalculationItem(value: a.value * b.value, expression: "(\(a.expression) * \(b.expression))", canonicalForm: multCanon))
                
                // Subtraction
                possibleResults.append(CalculationItem(value: a.value - b.value, expression: "(\(a.expression) - \(b.expression))", canonicalForm: "(\(a.canonicalForm)-\(b.canonicalForm))"))
                
                // Division
                if abs(b.value) > 0.0001 {
                    possibleResults.append(CalculationItem(value: a.value / b.value, expression: "(\(a.expression) / \(b.expression))", canonicalForm: "(\(a.canonicalForm)/\(b.canonicalForm))"))
                }
                
                for result in possibleResults {
                    var nextItems: [CalculationItem] = remaining
                    nextItems.append(result)
                    let solutions: [CalculationItem] = solve(items: nextItems)
                    foundSolutions.append(contentsOf: solutions)
                    
                    if foundSolutions.count > 50 { break }
                }
                if foundSolutions.count > 50 { break }
            }
            if foundSolutions.count > 50 { break }
        }
        
        return foundSolutions
    }
}
