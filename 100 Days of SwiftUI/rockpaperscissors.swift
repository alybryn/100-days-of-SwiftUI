import SwiftUI
// game picks rock paper scissors
// game promts player to win or lose
// plyer, presented with options, selects rock, paper, scissors
// score round
// game ends after 10 questions, final score  
struct ContentView: View {
    @State private var compMove = Move.paper.random()
    @State private var shouldWin = Bool.random()
    @State private var score = (right: 0, wrong: 0)
    @State private var gameOver = false
    
    let winPrompt = """
    Please select the correct 
    choice to win the game:
    """
    let altWinPrompt = "Try to Win"
    let losePrompt = """
    Selelct the option that will
    ensure your destruction:
    """
    let altLosePrompt = "Try to Lose"
    
    private var numberOfRounds: Int {
        score.right + score.wrong
    }
    let finalNumberOfRounds = 10
    
    var body: some View {
        ZStack {
            Color(shouldWin ? .green : .red)
            HStack {
                Spacer()
                VStack {
                    Group{
                        Spacer()
                        Spacer()
                    }
                    // player's score
                    Group {
                        Text("Score:")
                            .font(.title2)
                        Text("\(score.right) Correct, \(numberOfRounds) Wrong")
                            .font(.title3)
                    }
                    Group {
                        Spacer()
                        Spacer()
                        // compMove
                        Text("The computer chooses:")
                        Text("\((compMove.rawValue).uppercased())")
                        Spacer()
                        Spacer()
                    }
                    // desired outcome
                    Text(shouldWin ? winPrompt : losePrompt)
                    //Text(shouldWin ? altWinPrompt : altLosePrompt)
                    Spacer()
                    // 3 buttons for 🪨, 📄, ✂️
                    HStack (spacing: 30) {
                        Button("🪨") {
                            didIDoIt(input: compMove, clicked: .rock, should: shouldWin) ? (score.right += 1) : (score.wrong += 1)
                            reset()
                        }
                        Button("📄") {
                            didIDoIt(input: compMove, clicked: .paper, should: shouldWin) ? (score.right += 1) : (score.wrong += 1)
                            reset()
                        }
                        Button("✂️") {
                            didIDoIt(input: compMove, clicked: .scissors, should: shouldWin) ? (score.right += 1) : (score.wrong += 1)
                            reset()
                        }
                    }
                    .font(.largeTitle)
                    .buttonStyle(.bordered)
                    Group{
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                .alert("Game Over", isPresented: $gameOver) {
                    Button("Play Again") {
                        score = (0,0)
                    }
                } message: {
                    Text((score.right > score.wrong) ? "Winner!" : "You lost")
                }
                Spacer()
            }
            .background(.thinMaterial)
            .padding()
        }
    }
    func didIDoIt(input: Move, clicked: Move, should: Bool) -> Bool {
        switch input {
        case .scissors:
            return (clicked == .rock && should) || (clicked == .paper && !should)
        case .paper:
            return (clicked == .scissors && should) ||
            (clicked == .rock && !should)
        case .rock:
            return (clicked == .paper && should) ||
            (clicked == .scissors && !should)
        }
    }
    func reset() {
        compMove = Move.scissors.random()
        shouldWin.toggle()
        if numberOfRounds == finalNumberOfRounds {
            gameOver = true
        }
    }
}

enum Move: String {
    case rock, paper, scissors
    func random() -> Move {
        switch Int.random(in: 0...2) {
        case 0:
            return .rock
        case 1:
            return .paper
        case 2:
            return .scissors
        default:
            return .paper
        }
    }
}
