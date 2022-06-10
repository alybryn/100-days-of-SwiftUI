struct Question {
    let numberOne: Int
    let numberTwo: Int
    let text: String
    let answer: Int
    let allAnswers: [Int]
    init(numberOne: Int, numberTwo: Int) {
        self.numberOne = numberOne
        self.numberTwo = numberTwo
        self.text = "What is the result of \(numberOne) times \(numberTwo)?"
        self.answer = numberOne * numberTwo
        
        let a = (Bool.random() && numberOne != 1 ? (numberOne - 1) : (numberOne + 1)) * numberTwo
        let b = (Bool.random() && numberTwo != 1 ? (numberTwo - 1) : (numberTwo + 1)) * numberOne
        let c = Bool.random() ? (numberOne + 2) * numberTwo : (numberTwo + 2) * numberOne
        self.allAnswers = [a, b, c, answer].shuffled()
    }
}
extension Question: Equatable {
    static func == (_ lhs: Question, rhs: Question) -> Bool {
        return (lhs.numberOne == rhs.numberOne) && (lhs.numberTwo == rhs.numberTwo)
    }
}
struct GameQuestions {
    let questions: Array<Question>
    
    init (diff: Int, numQ: Int) {
        var qs = Array<Question>()
        while qs.count < numQ {
            let q = Question(numberOne: Int.random(in: 1...diff), numberTwo: Int.random(in: 1...12))
            if !qs.contains(q) {
                qs.append(q)
            }
        }
        questions = qs
    }
}
