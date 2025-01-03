//
//  ContentView.swift
//  Guess The Number
//
//  Created by Chase Hashiguchi on 12/6/24.
//

import SwiftUI
import AVFoundation

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
        NavigationView {
            ZStack {
                Color.gray.opacity(0.7).ignoresSafeArea()
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
                        .disabled(isGameActive) // Disable if the game is active
                        
                        Button("Medium") {
                                setDifficulty(level: "Medium")
                        }
                        .buttonStyle(DifficultyButtonStyle(color: .orange))
                        .disabled(isGameActive) // Disable if the game is active
                        
                        Button("Hard") {
                                setDifficulty(level: "Hard")
                        }
                        .buttonStyle(DifficultyButtonStyle(color: .red))
                        .disabled(isGameActive) // Disable if the game is active
                    }
                    Spacer()
                    Text("Enter a number between 1 and \(difficultyRange()):")
                        .font(.title2)
                        .bold()
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
                    Button("Start Game") {
                        resetGame()
                        startTimer()
                        SoundManager.shared.playSound(named: "Correct")
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.title2)
                    Text(feedback)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(feedback == "Correct! You guessed it!" ? Color(red: 0.0, green: 0.5, blue: 0.0) : .red)
                    // Navigation link to Instructions view
                    NavigationLink("Game Instructions", destination: InstructionsView())
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title2)
                }
            }
        }
    }
    
    func setDifficulty(level: String) {
        if !isGameActive {
            difficulty = level // updates difficulty level based on user selection
            switch level { // switch is similar to an if else chains but is cleaner to use
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
    }
    
    // Return the range based on difficulty
    func difficultyRange() -> Int {
        switch difficulty {
        case "Easy": return 10 // sets 10, 50, and 100 as the limit for the random number
        case "Medium": return 50
        case "Hard": return 100
        default: return 10 // if difficulty variable conatains a value that isn't present it will return to 10 by default
        }
    }
    
    func resetGame() {
        userGuess = ""
        feedback = ""
        attempts = 0
        isGameActive = false
    }
    
    func startTimer() {
        timer?.invalidate() // stops previously running timers
        isGameActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in // creates timer that goes off in 1 second intervals
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
            SoundManager.shared.playSound(named: "Incorrect")
            return "Too low!"
        } else if userGuess > randomNumber {
            SoundManager.shared.playSound(named: "Incorrect")
            return "Too high!"
        } else {
            stopTimer()
            SoundManager.shared.playSound(named: "Correct")
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

struct InstructionsView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                Text("Game Instructions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Text("1. Guess the correct number within the given time.")
                    .font(.title2)
                Text("2. The difficulty level will change the range of numbers and the time limit.")
                    .font(.title2)
                Text("3. You can press 'Start Game' to reset and begin a new round.")
                    .font(.title2)
                Text("4. The game ends either when the time runs out or the correct number is guessed.")
                    .font(.title2)
                Text("5. Try to guess the number as fast as possible!")
                    .font(.title2)
                Spacer()
            }
        }
    }
}

class SoundManager { // made class to play sounds
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return } // gaurd is a statement that handles situtaions where a condition fails
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
