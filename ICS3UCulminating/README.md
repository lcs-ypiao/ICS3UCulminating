# 24 Game - SwiftUI Edition

A competitive arithmetical game built with Swift and SwiftUI using the **MVVM (Model-View-ViewModel)** architecture. This project was developed as part of the Grade 11 Intro to Computer Science culminating task.

## 🎮 How the Game Works

The goal of the 24 Game is to manipulate four integers (ranging from 1 to 13) using basic arithmetic operators ($+$, $-$, $\times$, $\div$) and parentheses to reach a final result of exactly **24**.

### Core Rules
1. **Four Numbers:** You are given 4 numbers per round.
2. **Exactly Once:** You must use each of the 4 numbers exactly one time.
3. **Interactive UI:** Tap number buttons and symbol buttons to build your expression.
4. **Target 24:** Your expression must evaluate to exactly 24.0.

---

## 🏗️ Architecture (MVVM)

The app is organized into three distinct layers to ensure the code is clean, organized, and easy to maintain.

### 1. The Model (`Model/`)
*   **`GameRound.swift`**: This is the data structure. It **declares** the `numbers` array and contains the logic to **populate** it with 4 random integers (1-13). 
*   **Constraint Logic**: It ensures that no single number appears more than twice in a single round.

### 2. The ViewModel (`ViewModels/`)
The ViewModel acts as the "brain" of the app, connecting the raw data to the user interface.
*   **`GameViewModel.swift`**: Orchestrates the game state. It uses the `@Observable` framework to notify the View whenever the user types something or a new game starts.
*   **`CheckAnswer.swift`**: A specialized utility that uses `NSExpression` to calculate the mathematical result of the user's input string.
*   **`HintSolver.swift`**: The most complex part of the app. It uses **Recursion** to try thousands of combinations of the current numbers until it finds a way to get 24.
*   **Solvability Guarantee**: Every time a new round is generated, the ViewModel checks it against the `HintSolver`. If a round is impossible to solve, it immediately discards it and generates a new one, ensuring the player is never stuck with an impossible puzzle.

### 3. The View (`Views/`)
*   **`GameView.swift`**: Defines the layout of the app (the screen). It displays the numbers, the expression field, and the feedback messages.
*   **`GameButton.swift`**: A **custom subview** created to reduce code repetition. It defines the style for all interactive buttons in the game.

---

## 💡 Key Programming Concepts Used

### Arrays
Arrays are used throughout the app to store lists of items:
- `[Int]` for the four game numbers.
- `[String]` for the hints shown to the player.
- `[CalculationItem]` for the internal math engine.

### Sequence, Selection, and Iteration
1.  **Sequence**: The specific order of events, such as populating numbers *before* showing them on the screen.
2.  **Selection**: Using `if` and `repeat-while` statements to make decisions (e.g., checking if a result equals 24).
3.  **Iteration**: Using `for` and `while` loops to go through the array of numbers to build buttons or search for solutions.

### Recursion
The **Hint Solver** uses recursion. This means a function calls itself with a simplified version of the problem (moving from 4 numbers to 3, then 2, then 1) until it finds a solution.

### Normalization (Canonical Forms)
To ensure hints aren't just rearranged versions of the same math (like $3+4$ and $4+3$), the app uses "Canonical Forms" to standardize math expressions and only show truly unique hints.

---

## 🚀 Example Session
1. **App Starts**: The Model populates the array with `[6, 4, 3, 2]`.
2. **ViewModel**: Verifies that $(6 \times 4) \times (3 - 2) = 24$ is possible.
3. **Player**: Taps **6**, **x**, **4**. The View updates instantly.
4. **Player**: Taps **Check Answer**.
5. **Feedback**: The screen displays "Correct! 6 x 4 = 24".
