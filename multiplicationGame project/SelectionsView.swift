import SwiftUI

struct SelectionsView: View {
    @State private var difficulty = 2
    @State private var numQuestions = 5
    let myPassBack: (Int, Int) -> Void
    init(_ passFunc: @escaping (Int, Int) -> Void) {
        self.myPassBack = passFunc
    }
    var body: some View {
        // select difficulty:
        VStack {
            Section("Pick the biggest number you want to answer questions about:") {
                HStack (spacing: 0){
                    Spacer()
                    ForEach(2..<5, id: \.self) { setting in
                        Button(" \(setting) ") {
                            difficulty = setting
                        }
                        .modifier(
                            SelectModifier(selected: difficulty == setting)
                        )
                    }
                    Spacer()
                }
                HStack (spacing: 0){
                    Spacer()
                    ForEach(5..<9, id: \.self) { setting in
                        Button(" \(setting) ") {
                            difficulty = setting
                        }
                        .modifier(
                            SelectModifier(selected: difficulty == setting)
                        )
                    }
                    Spacer()
                }
                HStack(spacing: 0){
                    Spacer()
                    ForEach(9..<13, id: \.self) { setting in
                        Button(" \(setting) ") {
                            difficulty = setting
                        }
                        .modifier(
                            SelectModifier(selected: difficulty == setting)
                        )
                    }
                    Spacer()
                }
            }
            
            
            // select number of questions
            Section("Pick how many questions you want to answer:") {
                HStack (spacing: 10){
                    Spacer()
                    ForEach([5, 10, 20], id: \.self) { num in
                        Button(" \(num) "){
                            numQuestions = num
                        }
                        .modifier(SelectModifier(selected: numQuestions == num)
                        )
                    }
                    Spacer()
                }
            }
            // Text("Selected: difficulty of \(difficulty), \(numQuestions) questions")
            Section("When you're ready:") {
                Button("PLAY!") {
                    myPassBack(difficulty, numQuestions)
                }.modifier(
                    SelectModifier(selected: true)
                )
            }
        }
    }
}
struct SelectionsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionsView() { (i: Int, j: Int) in
            //nothing
        }
    }
}

struct SelectModifier: ViewModifier {
    let selected: Bool
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.quaternary, in: Capsule())
            .foregroundColor(selected ? .yellow : .pink)
            .padding(4)
            .buttonStyle(.borderless)
    }
}
