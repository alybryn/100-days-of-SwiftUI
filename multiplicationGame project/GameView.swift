import SwiftUI

struct GameView: View {
    
    let questionsToAsk: GameQuestions
    private var remainingQuestions: Int {
        return questionsToAsk.questions.count - currentQ
    }
    
    @State private var score = 0
    @State private var currentQ = 0
    @State private var userAnswer = -1
    
    let myPassBack: (Int) -> Void
    
    init (difficulty: Int, numberOfQuestions: Int, _ passFunc: @escaping (Int) -> Void) {
        myPassBack = passFunc
        questionsToAsk = GameQuestions(diff: difficulty, numQ: numberOfQuestions)
    }
    
    @State private var showScore = false
    @State private var showFinalScore = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                //Text("Asking \(questionsToAsk.questions.count) questions. This is your \(currentQ + 1)th question")
                VStack {
                    Text("\(questionsToAsk.questions[currentQ].text)")
                        .font(.title)
                    VStack {
                        HStack {
                            Button(" \(questionsToAsk.questions[currentQ].allAnswers[0]) "){
                                userAnswer = questionsToAsk.questions[currentQ].allAnswers[0]
                            }.modifier(
                                GameButtonModifier(selected: (userAnswer == questionsToAsk.questions[currentQ].allAnswers[0]), correct: questionsToAsk.questions[currentQ].allAnswers[0] == questionsToAsk.questions[currentQ].answer, run: showScore)
                            )
                            Button(" \(questionsToAsk.questions[currentQ].allAnswers[1]) "){
                                userAnswer = questionsToAsk.questions[currentQ].allAnswers[1]
                            }.modifier(
                                GameButtonModifier(selected: (userAnswer == questionsToAsk.questions[currentQ].allAnswers[1]), correct: questionsToAsk.questions[currentQ].allAnswers[1] == questionsToAsk.questions[currentQ].answer, run: showScore)
                            )
                        }
                        HStack {
                            Button(" \(questionsToAsk.questions[currentQ].allAnswers[2]) "){
                                userAnswer = questionsToAsk.questions[currentQ].allAnswers[2]
                            }.modifier(
                                GameButtonModifier(selected: (userAnswer == questionsToAsk.questions[currentQ].allAnswers[2]), correct: questionsToAsk.questions[currentQ].allAnswers[2] == questionsToAsk.questions[currentQ].answer, run: showScore)
                            )
                            Button(" \(questionsToAsk.questions[currentQ].allAnswers[3]) "){
                                userAnswer = questionsToAsk.questions[currentQ].allAnswers[3]
                            }.modifier(
                                GameButtonModifier(selected: (userAnswer == questionsToAsk.questions[currentQ].allAnswers[3]), correct: questionsToAsk.questions[currentQ].allAnswers[3] == questionsToAsk.questions[currentQ].answer, run: showScore)
                            )
                        }
                    }
                    Button ("Submit Answer") {
                        submitAnswer()
                    }.modifier(
                        SelectModifier(selected: true)
                    )
                }
                Text("You've got \(score) answers correct!")
                Text("You have \(remainingQuestions) questions left")
            }
            .alert("Final Score:", isPresented: $showFinalScore) {
                Button ("Great!") {
                    myPassBack(score)
                }
            } message: {
                Text("You got \(score) answers correct!")
            }
        }
    }
    func submitAnswer() {
        if userAnswer == questionsToAsk.questions[currentQ].answer {
            score += 1
        } 
        if remainingQuestions == 1 {
            withAnimation {
                showScore = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75){
                showFinalScore = true
            }
        } else {
            withAnimation{
                showScore = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                askQuestion()
            }
        }
    }
    func askQuestion() {
        showScore = false
        currentQ += 1
        userAnswer = -1
    }
    func reset() {
        score = 0
        currentQ = 0
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(difficulty: 3, numberOfQuestions: 4) { (score: Int) in
            //nothing
        }
    }
}

struct GameButtonModifier: ViewModifier {
    let selected: Bool
    let correct: Bool
    let run: Bool
    func body(content: Content) -> some View {
        content
            .font(.title)
            .padding()
            .background(.quaternary, in: Capsule())
            .foregroundColor(selected ? .yellow : .pink)
            .scaleEffect(run && correct ? 1.25 : 1)
            .padding(4)
            .buttonStyle(.borderless)
    }
}
