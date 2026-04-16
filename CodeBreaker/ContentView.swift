//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Md Mehedi Hasan on 16/4/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var game = CodeBreakerGameViewModel()
    @State private var currentGuess = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                headerSection
                inputSection
                statusSection
                historySection
                Spacer()
                resetButton
            }
            .padding()
            .navigationBarTitle("Code Breaker", displayMode: .inline)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Break the Secret 3-Digit Code")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Digits can repeat. You have 8 guesses.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    private var inputSection: some View {
        VStack(spacing: 12) {
            TextField("Enter 3 digits", text: $currentGuess)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardType(.numberPad)
                .disabled(game.isGameOver)
                .onReceive(Just(currentGuess)) { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue || filtered.count > 3 {
                        self.currentGuess = String(filtered.prefix(3))
                    }
                }

            Button(action: {
                self.submitGuess()
            }) {
                Text("Submit Guess")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((currentGuess.count == 3 && !game.isGameOver) ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(currentGuess.count != 3 || game.isGameOver)
        }
    }

    private var statusSection: some View {
        VStack(spacing: 8) {
            Text("Guesses Left: \(game.remainingGuesses)")
                .font(.headline)

            if game.endMessage != nil {
                Text(game.endMessage ?? "")
                    .font(.headline)
                    .foregroundColor(game.didWin ? .green : .red)
                    .multilineTextAlignment(.center)
            } else {
                Text("Make your guess")
                    .foregroundColor(.gray)
            }
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Guess History")
                .font(.headline)

            if game.guessResults.isEmpty {
                Text("No guesses yet.")
                    .foregroundColor(.gray)
            } else {
                List(game.guessResults) { result in
                    HStack {
                        Text(result.guess)
                            .font(.system(size: 22, weight: .medium, design: .monospaced))
                            .frame(width: 80, alignment: .leading)

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Exact: \(result.exactMatches)")
                            Text("Partial: \(result.partialMatches)")
                        }
                        .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 300)
            }
        }
    }

    private var resetButton: some View {
        Button(action: {
            self.game.startNewGame()
            self.currentGuess = ""
        }) {
            Text("New Game")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }

    private func submitGuess() {
        game.submitGuess(currentGuess)
        currentGuess = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
