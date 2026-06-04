# 24 Game - SwiftUI Edition

A competitive arithmetical game built with Swift and SwiftUI using the MVVM (Model-View-ViewModel) architecture.

## How the Game Works
The objective is simple: use four given integers and basic arithmetic operators ($+$, $-$, $\times$, $\div$) to reach the number **24**. Each of the four numbers must be used **exactly once**.

### The Rules
1. **Four Numbers:** You are given 4 random numbers between 1 and 13.
2. **Operations:** You can use Addition, Subtraction, Multiplication, and Division.
3. **Grouping:** Use parentheses `(` and `)` to define the order of operations.
4. **Target:** The final result of your mathematical expression must equal **24**.

---

## Example Game Session

Let's walk through a typical round step-by-step:

### 1. The Setup
The game starts and displays four numbers:
**[ 4, 7, 8, 8 ]**

### 2. The Strategy
The player looks at the numbers and thinks: 
*"I know that $6 \times 4 = 24$. Can I use 7, 8, and 8 to make a 6?"*
*   $8 \div 8 = 1$
*   $7 - 1 = 6$
*   $6 \times 4 = 24$

### 3. Entering the Expression
Instead of typing, the player uses the interactive buttons:
1. Tap the **(** button.
2. Tap the **7** button.
3. Tap the **-** button.
4. Tap the **(** button.
5. Tap the **8** button.
6. Tap the **/** button.
7. Tap the **8** button.
8. Tap the **)** button.
9. Tap the **)** button.
10. Tap the **x** button.
11. Tap the **4** button.

The expression field now shows: `(7 - (8 / 8)) x 4`

### 4. Checking the Answer
The player taps **"Check Answer"**.
*   The **View** tells the **ViewModel** to validate.
*   The **ViewModel** calculates: $(7 - 1) \times 4 = 6 \times 4 = 24$.
*   The screen displays: **"Correct! (7 - (8 / 8)) x 4 = 24"**

---

## Technical Overview (MVVM)

- **Model (`GameRound.swift`):** Manages the data. It contains the logic to generate 4 random numbers while ensuring no number appears more than twice.
- **ViewModel (`GameViewModel.swift`):** The engine. It holds the current game state, builds the expression string as buttons are clicked, and evaluates the math using `NSExpression`.
- **View (`GameView.swift`):** The user interface. It displays the buttons and text, reacting instantly to any changes in the ViewModel thanks to the `@Observable` framework.
