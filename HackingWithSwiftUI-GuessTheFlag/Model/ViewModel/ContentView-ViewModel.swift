//
//  ContentView-ViewModel.swift
//  HackingWithSwiftUI-GuessTheFlag
//
//  Created by Michael Jones on 06/07/2026.
//

import Foundation

extension ContentView {
    @Observable
    class ViewModel {
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
        
        var showingScore = false
        var gameOver = false
        
        var scoreTitle = String()
        var score = Int()
        var gamesPlayed = 1
        
        var selectedFlag = -1
        
        var countries = allCountries.shuffled()
        
        var correctAnswer = Int.random(in: 0...2)
        
        func askQuestion() {
            countries.remove(at: correctAnswer)
            correctAnswer = Int.random(in: 0...2)
            gamesPlayed += 1
            selectedFlag = -1
        }
        
        func resetGame() {
            selectedFlag = -1
            gamesPlayed = 0
            score = 0
            countries = Self.allCountries
            askQuestion()
        }
        
        func flagTapped(_ number: Int) {
            selectedFlag = number
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
    }
}
