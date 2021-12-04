//
//  ContentView.swift
//  challenge-2-rock-paper-scissors
//
//  Created by Di Wu on 2021-12-03.
//

import SwiftUI

// Custom View
struct ChoiceButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(title) {
            action()
        }.choiceButtonStyle()
    }
}

// Custom ViewModifier
struct ChoiceButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 100))
            .foregroundColor(.black)
            .frame(maxWidth: 200)
            .padding(20)
            .background(.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func choiceButtonStyle() -> some View {
        modifier(ChoiceButtonStyle())
    }
}

struct ContentView: View {
    private let options = ["🪨", "📄","✂"]
    @State private var score = 0
    @State private var result = ""
    @State private var generatedChoice = ["🪨", "📄","✂"].randomElement()
    @State private var userChoice = ""
    @State private var showResult = false
    @State private var numberOfGames = 1
    @State private var continueGame = true
    
    // View as property
    let background: some View = LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    
    var body: some View {
        ZStack {
            background
            if continueGame {
                VStack {
                    
                    Text("Game \(numberOfGames)")
                        .font(.system(size: 100))
                    
                    Text("choose your options")
                        .font(.title.bold())
                    ForEach(options, id:\.self) { option in
                        ChoiceButton(title: option) {
                            compareResult(option)
                            showResult = true
                        }
                    }
                    .padding(0.5)
                }.alert(result == "Win" ?"Yay!":"Uh-oh!", isPresented: $showResult) {
                    Button("Continue", role: .cancel, action: askQuestion)
                    
                } message: {
                    Text("You \(result), computer choice was \(generatedChoice!)")
                }
                
            } else {
                VStack {
                    Text("Game Ended!")
                    Text("Your final score is \(score)")
                    Button("Continue to Play?") {
                        continueGame = true
                        numberOfGames = 1
                    }
                }
                .padding()
                .font(.title.bold())
            }
        }
        
        
    }
    
    func askQuestion() {
        generatedChoice = options.randomElement()!
        showResult = false
        numberOfGames += 1
        if numberOfGames == 10 {
            continueGame = false
        }
    }
    
    func compareResult(_ user: String) {
        if user == "🪨" && generatedChoice == "✂" {
            result = "Win"
        } else if user == "🪨" && generatedChoice == "📄" {
            result = "Lost"
        } else if user == "📄" && generatedChoice == "✂" {
            result = "Lost"
        } else if user == "📄" && generatedChoice == "🪨" {
            result = "Win"
        } else if user == "✂" && generatedChoice == "📄" {
            result = "Win"
        } else if user == "✂" && generatedChoice == "🪨" {
            result = "Lost"
        } else {
            result = "Tie"
        }
        
        if result == "Win" {
            score += 1
        } else if result == "Lost" {
            score -= 1
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
