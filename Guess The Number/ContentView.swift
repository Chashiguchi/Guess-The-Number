//
//  ContentView.swift
//  Guess The Number
//
//  Created by Chase Hashiguchi on 12/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var randomNumber = Int.random(in: 1...10) // Default range for Easy
    @State private var userGuess = ""
    @State private var feedback = ""
    @State private var attempts = 0
    @State private var timer: Timer?
    @State private var timeRemaining = 60 // Default for Easy
    @State private var isGameActive = false
    @State private var difficulty: String = "Easy" // Default difficulty
    var body: some View {
        VStack(spacing: 30) { // Increased spacing for better layout
            Text("Guess the Number!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Difficulty: \(difficulty)")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Attempts: \(attempts)")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Time Remaining: \(timeRemaining) seconds")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(timeRemaining <= 10 ? .red : .black)
            HStack(spacing: 15) {
                Button("Easy") {
                    setDifficulty(level: "Easy")
                }
                .buttonStyle(DifficultyButtonStyle(color: .green))
                
                Button("Medium") {
                    setDifficulty(level: "Medium")
                }
                .buttonStyle(DifficultyButtonStyle(color: .orange))
                
                Button("Hard") {
                    setDifficulty(level: "Hard")
                }
                .buttonStyle(DifficultyButtonStyle(color: .red))
            }
            Spacer()
            Text("Enter a number between 1 and \(difficultyRange()):")
                .font(.title2)
            TextField("Your guess", text: $userGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .font(.title2)
                .onChange(of: userGuess) { newValue in
                    // Allow only numeric input
                    userGuess = newValue.filter { $0.isNumber }
                }
            Button("Submit Guess") {
                if isGameActive, let guess = Int(userGuess) {
                    attempts += 1
                    feedback = checkGuess(guess)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title2)
            Text(feedback)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(feedback == "Correct! You guessed it!" ? .green : .red)
            //Spacer()
            Button("Start Game") {
                resetGame()
                startTimer()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title2)
            //Spacer()
            
        }
    }
    func setDifficulty(level: String) {
        difficulty = level
        switch level {
        case "Easy":
            randomNumber = Int.random(in: 1...10)
            timeRemaining = 60
        case "Medium":
            randomNumber = Int.random(in: 1...50)
            timeRemaining = 45
        case "Hard":
            randomNumber = Int.random(in: 1...100)
            timeRemaining = 30
        default:
            break
        }
        resetGame() // Reset the game when difficulty changes
    }
    
    // Return the range based on difficulty
    func difficultyRange() -> Int {
        switch difficulty {
        case "Easy": return 10
        case "Medium": return 50
        case "Hard": return 100
        default: return 10
        }
    }
    
    func resetGame() {
        userGuess = ""
        feedback = ""
        attempts = 0
        isGameActive = true
    }
    func startTimer() {
        timer?.invalidate()
        isGameActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isGameActive = false
                endGame()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        isGameActive = false
    }
    
    func checkGuess(_ userGuess: Int) -> String {
        if userGuess < randomNumber {
            return "Too low!"
        } else if userGuess > randomNumber {
            return "Too high!"
        } else {
            stopTimer()
            return "Correct! You guessed it!"
        }
    }
    
    
    func endGame() {
        feedback = "Time's Up! The correct number was \(randomNumber)."
    }
}

#Preview {
    ContentView()
}

// Custom button style for difficulty buttons
struct DifficultyButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title3)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
