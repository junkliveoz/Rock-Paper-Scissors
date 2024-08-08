//
//  ContentView.swift
//  Rock, Paper, Scissors
//
//  Created by Adam Sayer on 22/7/2024.
//

import SwiftUI

struct TextStyleModifier: ViewModifier {
    let fontSize: CGFloat
    let isTitle: Bool // Flag to differentiate between title and body styles

    func body(content: Content) -> some View {
        content
            .font(.custom("Chalkboard SE Bold", size: fontSize)) // Use passed-in fontSize
            .font(isTitle ? .largeTitle : .title2)  // Adjust style based on isTitle
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func textStyle(size: CGFloat, isTitle: Bool = false) -> some View {
        modifier(TextStyleModifier(fontSize: size, isTitle: isTitle))
    }
}

struct BorderedButton: View {
    let label: String
    let color: Color
    let action: () -> Void // Closure for the button action

    var body: some View {
        Button(label) {
            action()
        }
        .frame(width: 100, height: 50)
        .foregroundStyle(color)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.1)) // Adjust opacity for the fill
                .stroke(color, lineWidth: 4) // Use the passed-in color
        )
    }
}

struct answers: View {
    var answer: String
    
    var body: some View {
        Image(answer)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var gameOptions = ["rock", "paper", "scissors"].shuffled()
    @State private var computerAnswer = Int.random(in: 0...2)
    @State private var playerAnswer: Int?
    @State private var correctAnswer: Bool = false
    @State private var showingAlert = false
    @State private var scoreTitle = ""
    @State private var score = ""
    @State private var totalQuestions = 10
    @State private var questionsLeft = 10
    @State private var currentScore = 0
    
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            HStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Text("Rock Paper Scissors")
                        .textStyle(size: 35, isTitle: true)
                    Text("Round \(totalQuestions - questionsLeft) of \(totalQuestions)")
                        .textStyle(size: 15)
                   
                    answers(answer: gameOptions[computerAnswer])
                    Text("Computer")
                        .textStyle(size: 25)
                    
                    Text("Vs")
                        .foregroundStyle(.red)
                        .textStyle(size: 35)
                    
                    if let unwrappedPlayerAnswer = playerAnswer { // Unwrap if not nil
                        answers(answer: gameOptions[unwrappedPlayerAnswer]) // Use unwrapped value
                    }
                    
                    Text("Player")
                        .textStyle(size: 25)
                    
                    Spacer()
                    
                    Text("Does our player win?")
                        .textStyle(size: 25)
                    
                    
                    HStack {
                        
                        BorderedButton(label: "Yes", color: .green) {
                            if actualResult("Yes") { // Check if the answer is correct
                                scoreTitle = "Correct!"
                            } else {
                                scoreTitle = "Incorrect!"
                            }
                            showingAlert = true // Show the alert
                        }
                        
                        Spacer()
                        
                        BorderedButton(label: "No", color: .red) {
                            if actualResult("No") { // Check if the answer is correct
                                scoreTitle = "Correct!"
                            } else {
                                scoreTitle = "Incorrect!"
                            }
                            showingAlert = true // Show the alert
                        }
                    }.textStyle(size: 35)
                    
                    Spacer()
                }
                
       
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()

                
            }
            .padding()
            .onAppear {  // Call generatePlayerAnswer() when the view appears
                generatePlayerAnswer()
            }
        }
        .alert(scoreTitle, isPresented: $showingAlert) {
            if questionsLeft == 0 {
                Button("Restart", action: nextRound)
            } else {
                Button("Next Round", action: nextRound)
            }
        } message: {
            if questionsLeft == 0 {
                Text("Well done, that's the end of the game.  You scored \(currentScore)!")
            } 
        }
    }
    
    private func generatePlayerAnswer() {
        repeat {
            playerAnswer = Int.random(in: 0...2)
        } while playerAnswer == computerAnswer // Repeat until different
    }
    
    private func gameResult() -> Bool {
        // Check if playerAnswer is not nil before using it
        guard let playerAnswer = playerAnswer else {
            return false // Or any other default value if player hasn't chosen yet
        }

        switch (gameOptions[computerAnswer], gameOptions[playerAnswer]) {
        case ("rock", "paper"), ("paper", "scissors"), ("scissors", "rock"):
            return true // Player wins
        default:
            return false // Player loses or tie
        }
    }
    
    private func actualResult(_ playerAnswer: String) -> Bool {
        if gameResult() == true && playerAnswer == "Yes" {
            currentScore += 1
            return true
        } else if gameResult() == false && playerAnswer == "No" {
            return true
        } else {
            currentScore -= 1
            return false
        }
    }

    
    private func nextRound() {
        gameOptions.shuffle()
        computerAnswer = Int.random(in: 0...2)
        playerAnswer = nil // Reset playerAnswer to force regeneration
        
        // After shuffling, call generatePlayerAnswer() again
        generatePlayerAnswer()
        
        showingAlert = false
        
        if questionsLeft == 0 {
            questionsLeft = 10
            currentScore = 0
        } else {
            questionsLeft -= 1
        }
        
        
    }
}

#Preview {
    ContentView()
}
