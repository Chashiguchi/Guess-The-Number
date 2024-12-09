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
        
        func resetGame() {
            userGuess = ""
            feedback = ""
            attempts = 0
            isGameActive = true
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
