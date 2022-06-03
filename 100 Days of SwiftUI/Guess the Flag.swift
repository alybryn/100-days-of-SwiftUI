import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = (wrong: 0, right: 0)
    var numberOfRounds: Int {
        score.right + score.wrong
    }
    @State private var usedCountries: Set<String> = []
    var body: some View {
        ZStack {
            RadialGradient(stops:[
                .init(color: .yellow, location: 0.3),
                .init(color: .indigo, location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3, id: \.self) { number in 
                        Button {
                            flagTapped(number)
                        } label: {
                            Image("\(countries[number])@2x")
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score.right)/\(numberOfRounds)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score.right)/\(numberOfRounds)")
        }
        .alert("final score: \(score.right)/\(numberOfRounds)", isPresented: $showingFinalScore) {
            Button("gg", action: reset)
        } message: {
            Text("That's the game! You scored \(score.right) out of \(numberOfRounds) possible points")
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "✅Correct!"
            score.right += 1
        } else {
            scoreTitle = "❌Wrong! That's the flag of \(countries[number])"
            score.wrong += 1
        }
        showingScore = true
    }
    func askQuestion() {
        usedCountries.insert(countries[correctAnswer])
        while usedCountries.contains(countries[correctAnswer]) {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        if numberOfRounds == 11 {
            showingFinalScore = true
        }
    }
    func reset() {
        score = (0,0)
        usedCountries.removeAll()
    }
}
