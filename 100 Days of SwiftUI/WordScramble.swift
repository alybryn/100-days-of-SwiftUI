import SwiftUI

struct ContentView: View {
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var usedWords = Array<String>()
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var sumScore = 0
    @State private var scoreMemories = Array<ScoreMemory>()
    var score: Int {
        guard !usedWords.isEmpty else {
            return 0
        }
        return (sumScore * 10) / usedWords.count + (usedWords.count * 5)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                Section("Score:") {
                    Text("\(score)")
                }
                Section("Past Scores:") {
                    ForEach(scoreMemories, id: \.word) {score in 
                        Text("\(score.word): \(score.score)")
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addWordAndReset)
            .onAppear(perform: startGame)
            .toolbar {
                Button("New Game", action: startGame)
            }
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    func addWordAndReset() {
        addNewWord()
        newWord = ""
    }
    func addNewWord() {
        // lowercase and trim the word, disallow duplicates
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        // exit if the remaining string is empty
        guard answer.count > 0 else { 
            return
        }
        guard islongEnough(word: answer) else {
            wordError(title: "Word too short", message: "Acceptable answers are longer than 3 letters long")
            return
        }
        guard isNotStartWord(word: answer) else {
            wordError(title: "Word is not different", message: "Acceptable answers are not the same as the prompt")
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        sumScore += answer.count
    }
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func islongEnough(word: String) -> Bool {
        word.count > 3
    }
    func isNotStartWord(word: String) -> Bool {
        !(word == rootWord)
    }
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    func startGame() {
        if usedWords.count > 0 {
            scoreMemories.insert(ScoreMemory(score: score, word: rootWord), at: 0)
        }
        usedWords = []
        //Find start.txt
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // Load it into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // split the string into array of Strings, with each element being one word
                let allWords = startWords.components(separatedBy: "\n")
                // pick a random word to be assigned to rootWord, or sensible default if array is empty
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
}
struct ScoreMemory: Hashable {
let score: Int 
let word: String
}
