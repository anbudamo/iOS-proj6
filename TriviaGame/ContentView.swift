//
//  ContentView.swift
//  TriviaGame
//
//  Created by Anbu Damodaran on 3/31/24.
//

//
//  ContentView.swift
//  TriviaGame
//
//  Created by Anbu Damodaran on 3/31/24.
//

import SwiftUI

struct Option {
    var name: String
    var values: [String]
    var selectedValue: String
    
    init(name: String, values: [String], selectedValue: String) {
        self.name = name
        self.values = values
        self.selectedValue = selectedValue
    }
}

struct ContentView: View {
    @State private var numberOfQuestions: Int = 5
    @State private var selectedCategory: String = "General Knowledge"
    @State private var selectedDifficulty: String = "Medium"
    @State private var selectedType: String = "Multiple Choice"
    @State private var isGameStarted: Bool = false
    
    let categories = ["General Knowledge", "Science", "History", "Geography"]
    let difficulties = ["Easy", "Medium", "Hard"]
    let types = ["Multiple Choice", "True False"]
    
    var body: some View {
        if !isGameStarted {
            OptionsView(numberOfQuestions: $numberOfQuestions,
                        selectedCategory: $selectedCategory,
                        selectedDifficulty: $selectedDifficulty,
                        selectedType: $selectedType,
                        categories: categories,
                        difficulties: difficulties,
                        types: types,
                        isGameStarted: $isGameStarted,
                        startGame: startGame)
        } else {
            TriviaGameView(isGameStarted: $isGameStarted)
        }
    }
    
    func startGame() {
        // Start the trivia game
        isGameStarted = true
    }
}

struct OptionsView: View {
    @Binding var numberOfQuestions: Int
    @Binding var selectedCategory: String
    @Binding var selectedDifficulty: String
    @Binding var selectedType: String
    var categories: [String]
    var difficulties: [String]
    var types: [String]
    @Binding var isGameStarted: Bool
    var startGame: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Number of Questions")) {
                Stepper(value: $numberOfQuestions, in: 1...20) {
                    Text("\(numberOfQuestions)")
                }
            }
            
            Section(header: Text("Category")) {
                Picker(selection: $selectedCategory, label: Text("Category")) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
            
            Section(header: Text("Difficulty")) {
                Picker(selection: $selectedDifficulty, label: Text("Difficulty")) {
                    ForEach(difficulties, id: \.self) { difficulty in
                        Text(difficulty)
                    }
                }
            }
            
            Section(header: Text("Type")) {
                Picker(selection: $selectedType, label: Text("Type")) {
                    ForEach(types, id: \.self) { type in
                        Text(type)
                    }
                }
            }
            
            Button(action: startGame) {
                Text("Start Game")
            }
        }
        .navigationBarTitle("Trivia Options")
    }
}

struct TriviaGameView: View {
    @Binding var isGameStarted: Bool
    @State private var selectedAnswers: [String?] = Array(repeating: nil, count: triviaQuestions.count)
    @State private var timeRemaining = 60 // Timer set to 60 seconds
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Auto-submit timer
    
    var body: some View {
        VStack {
            List {
                ForEach(triviaQuestions.indices, id: \.self) { index in
                    QuestionRow(question: triviaQuestions[index], selectedAnswer: $selectedAnswers[index])
                }
            }
            .navigationBarTitle("Trivia Game")
            .navigationBarItems(trailing: Button("Submit", action: submitAnswers))
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    submitAnswers()
                }
            }
            Text("Time remaining: \(timeRemaining) seconds")
        }
    }
    
    func submitAnswers() {
        // Calculate score based on selected answers
        let score = calculateScore()
        // Present score to the user
        print("Your score: \(score)")
    }
    
    func calculateScore() -> Int {
        var score = 0
        for (index, question) in triviaQuestions.enumerated() {
            if let selectedAnswer = selectedAnswers[index], selectedAnswer == question.correctAnswer {
                score += 1
            }
        }
        return score
    }
}


struct QuestionRow: View {
    let question: TriviaQuestion
    @Binding var selectedAnswer: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(question.text)
                Spacer()
                if selectedAnswer != nil {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
            ForEach(question.options, id: \.self) { option in
                Button(action: {
                    selectedAnswer = option
                }) {
                    HStack {
                        Text(option)
                        if selectedAnswer == option {
                            Spacer()
                            // Image(systemName: "circle.fill")
                            // .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}



struct TriviaQuestion {
    let text: String
    let options: [String]
    let correctAnswer: String
}

let triviaQuestions = [
    TriviaQuestion(text: "What is the capital of France?", options: ["Paris", "Berlin", "London", "Madrid"], correctAnswer: "Paris"),
    TriviaQuestion(text: "Which planet is known as the Red Planet?", options: ["Mars", "Venus", "Jupiter", "Saturn"], correctAnswer: "Mars"),
    TriviaQuestion(text: "Who painted the Mona Lisa?", options: ["Leonardo da Vinci", "Pablo Picasso", "Vincent van Gogh", "Michelangelo"], correctAnswer: "Leonardo da Vinci"),
    TriviaQuestion(text: "What is the largest mammal?", options: ["Elephant", "Blue Whale", "Giraffe", "Hippopotamus"], correctAnswer: "Blue Whale"),
    TriviaQuestion(text: "What is the chemical symbol for water?", options: ["H2O", "CO2", "NaCl", "O2"], correctAnswer: "H2O"),
    TriviaQuestion(text: "Who wrote 'Romeo and Juliet'?", options: ["William Shakespeare", "Charles Dickens", "Jane Austen", "Mark Twain"], correctAnswer: "William Shakespeare")
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

