# CodeBreaker (iOS App)

CodeBreaker is a simple iOS game built using SwiftUI where the player tries to guess a secret 3-digit code within a limited number of attempts.

---

## Game Overview

* The application generates a random 3-digit code (0–9)
* Digits may repeat
* The player has 8 attempts to correctly guess the code

---

## How It Works

After each guess, the application provides feedback:

* Exact Matches: Correct digit in the correct position
* Partial Matches: Correct digit in the wrong position

### Example

| Secret Code | Guess | Exact | Partial |
| ----------- | ----- | ----- | ------- |
| 112         | 123   | 1     | 1       |
| 112         | 432   | 1     | 0       |

---

## Game Rules

1. Each guess must consist of exactly 3 digits
2. The player has a maximum of 8 guesses
3. Digits may repeat in the secret code
4. The game ends when:

   * The player correctly guesses all digits (Exact = 3), or
   * The player uses all 8 attempts without success

---

## Features

* SwiftUI-based user interface
* Real-time feedback after each guess
* Guess history tracking
* Win and loss detection
* Reset/New Game functionality

---

## Technologies Used

* Swift
* SwiftUI
* Combine
* MVVM Architecture

---

## How to Run

1. Open the project in Xcode
2. Select a simulator (e.g., iPhone 15)
3. Click Run
4. Interact with the application

---

## Compatibility

* iOS 13 and above

---

## Author

Md. Mehedi Hasan Shawon
Texas A&M University - San Antonio
