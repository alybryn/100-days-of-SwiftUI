import SwiftUI

struct ContentView: View {
    @State private var choices = true
    @State private var hasPlayedGame = false
    let selectionButtonText = "Play Game"
    let gameButtonText = "Back to Settings"
    // from selection view (for both?)
    @State private var difficulty = 2
    @State private var numberOfQuestions = 2
    // from game view
    @State private var score = 0
    
    
    var body: some View {
        ZStack{
            AngularGradient(gradient: Gradient(colors: [.green, .indigo, .yellow, .green]), center: .center)
            VStack(){
                if choices {
                    SelectionsView() { (dif: Int, num: Int) in
                        difficulty = dif
                        numberOfQuestions = num
                        choices.toggle()
                    }
                } else {
                    GameView(difficulty: difficulty, numberOfQuestions: numberOfQuestions) { (score: Int) in
                        self.score += score
                        hasPlayedGame = true
                        choices.toggle()
                    }
                }
//                Text("Selected: Difficulty: \(difficulty), \(numberOfQuestions) questions")
                Text(hasPlayedGame ? "You've gotten \(score) right answers!" : "You haven't played yet")
            }
            .padding()
            .background(.regularMaterial)
        }
    }
}
