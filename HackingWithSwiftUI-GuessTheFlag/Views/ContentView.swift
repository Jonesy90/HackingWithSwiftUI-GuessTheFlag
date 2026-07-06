//
//  ContentView.swift
//  HackingWithSwiftUI-GuessTheFlag
//
//  Created by Michael Jones on 01/06/2026.
//

/*
 Animation Challenges:
 1. When you tap a flag, make it spin around 360 degrees on the Y axis.
 
 2. Make the other two buttons fade out to 25% opacity.
 
 3. Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!
*/

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
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
                        
                        Text(viewModel.countries[viewModel.correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            viewModel.flagTapped(number)
                        } label: {
                            FlagImage(name: viewModel.countries[number])
                                .rotation3DEffect(.degrees(viewModel.selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .animation(.default, value: viewModel.selectedFlag)
                                .opacity(viewModel.selectedFlag == -1 || viewModel.selectedFlag == number ? 1.0 : 0.25)
                                .scaleEffect(viewModel.selectedFlag == -1 || viewModel.selectedFlag == number ? 1.0 : 0.25)
                                .saturation(viewModel.selectedFlag == -1 || viewModel.selectedFlag == number ? 1.0 : 0.25)
                                .blur(radius: viewModel.selectedFlag == -1 || viewModel.selectedFlag == number ? 0 : 7)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(viewModel.score)")
                    .foregroundStyle(.white)
                    .font(.title.weight(.bold))
                
                Spacer()
            }
            .padding()
        }
        .alert(viewModel.scoreTitle, isPresented: $viewModel.showingScore) {
            Button("Continue", action: viewModel.askQuestion)
        } message: {
            Text("Your score is: \(viewModel.score)")
        }
        .alert("Game Over!", isPresented: $viewModel.gameOver) {
            Button("New Game", action: viewModel.resetGame)
        } message: {
            Text("Your final score is: \(viewModel.score)")
        }
    }
}

#Preview {
    ContentView()
}

