//
//  ContentView.swift
//  HackingWithSwiftUI-GuessTheFlag
//
//  Created by Michael Jones on 01/06/2026.
//

import SwiftUI

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var showingScore = false //@State property to handle the alert. An alert shows after ever country press.
    @State private var scoreTitle = "" //@State property to show if the user selected correctly.
    @State private var score = 0 //@State property to keep track of the players score.
    @State private var gamesPlayed = 1 //@State property to keep track of the number of games played. Limit is 8.
    @State private var gameOver = false //@State property to handle the game over alert.
    
    // A Static constant, this Array stays put and doesn't change.
    static let allCountries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Nigeria",
        "Poland",
        "Spain",
        "UK",
        "Ukraine",
        "US"
    ].shuffled()
    
    //Array of all the countries available taken from the allCountries Static Array. This Array matches the images in Assets.
    @State private var countries = allCountries.shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2) //Generates a random number.
    
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            ).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.weight(.bold))
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(score)")
        }
        .alert("Game Over!", isPresented: $gameOver) {
            Button("New Game", action: resetGame)
        } message: {
            Text("Your final score is: \(score)")
        }
    }
    
    /// Accepts the number passed in and compares it to the correct answer.  Based of the answer, either an correct or incorrect Alert will appear. Once a game limit is reached, an Alert will appear to replay the game.
    /// - Parameter number: A Integer value passed in and is used to determine if the chosen flag is correct.
    private func flagTapped(_ number: Int) {
        let needsThe = ["UK", "US"]
        let theirAnswer = countries[number]
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            if score > 0 {
                score -= 1
            }
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Incorrect! That's the flag of the \(theirAnswer)"
            } else {
                scoreTitle = "Incorrect! That's the flag of \(theirAnswer)"
            }
        }
        
        if gamesPlayed == 8 {
            gameOver = true
        } else {
            showingScore = true
        }
    }
    
    /// Progress to the next question.
    private func askQuestion() {
        countries.remove(at: correctAnswer)
        correctAnswer = Int.random(in: 0...2)
        gamesPlayed += 1
    }
    
    /// Resets the game back to it's default settings
    private func resetGame() {
        gamesPlayed = 0
        score = 0
        countries = Self.allCountries
        askQuestion()
    }
}

#Preview {
    ContentView()
}

