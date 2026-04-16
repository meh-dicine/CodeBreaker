//
//  CodeBreakerGameViewModel.swift
//  CodeBreaker
//
//  Created by Md Mehedi Hasan on 16/4/26.
//

import Foundation
import Combine

struct GuessResult: Identifiable {
    let id = UUID()
    let guess: String
    let exactMatches: Int
    let partialMatches: Int
}

final class CodeBreakerGameViewModel: ObservableObject {
    @Published var guessResults: [GuessResult] = []
    @Published var remainingGuesses: Int = 8
    @Published var isGameOver: Bool = false
    @Published var didWin: Bool = false
    @Published var endMessage: String? = nil

    private var secretCode: [Int] = []

    init() {
        startNewGame()
    }

    func startNewGame() {
        secretCode = (0..<3).map { _ in Int.random(in: 0...9) }
        guessResults = []
        remainingGuesses = 8
        isGameOver = false
        didWin = false
        endMessage = nil
    }

    func submitGuess(_ guess: String) {
        guard !isGameOver else { return }
        guard guess.count == 3, guess.allSatisfy({ $0.isNumber }) else { return }

        let guessDigits = guess.compactMap { Int(String($0)) }
        let result = evaluateGuess(guessDigits)

        let guessResult = GuessResult(
            guess: guess,
            exactMatches: result.exact,
            partialMatches: result.partial
        )

        guessResults.append(guessResult)
        remainingGuesses -= 1

        if result.exact == 3 {
            didWin = true
            isGameOver = true
            let count = guessResults.count
            endMessage = "You won in \(count) guess\(count == 1 ? "" : "es")!"
        } else if remainingGuesses == 0 {
            didWin = false
            isGameOver = true
            let secret = secretCode.map(String.init).joined()
            endMessage = "You lost. The secret code was \(secret)."
        }
    }

    private func evaluateGuess(_ guess: [Int]) -> (exact: Int, partial: Int) {
        var exact = 0
        var secretRemainder: [Int] = []
        var guessRemainder: [Int] = []

        for i in 0..<3 {
            if guess[i] == secretCode[i] {
                exact += 1
            } else {
                secretRemainder.append(secretCode[i])
                guessRemainder.append(guess[i])
            }
        }

        var frequency: [Int: Int] = [:]

        for digit in secretRemainder {
            frequency[digit, default: 0] += 1
        }

        var partial = 0

        for digit in guessRemainder {
            if let count = frequency[digit], count > 0 {
                partial += 1
                frequency[digit] = count - 1
            }
        }

        return (exact, partial)
    }
}
