import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercent = 25.0
    @FocusState private var amountIsFocused: Bool
    let currencyStyle: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "USD" )
    // let tipPercentages = [10, 15, 20, 25, 30, 0]
    var grandTotal: Double {
        let tipSelection = Double(tipPercent)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople)
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: currencyStyle)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(1 ..< 100, id: \.self) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    /*
                    Picker("Tip percentage", selection: $tipPercent) {
                        ForEach(0 ..< 101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.automatic)
                    */
                    
                    Slider(value: $tipPercent, in: 0 ... 100, step: 0.01)
                    if tipPercent == 100.00 {
                        Text("100.00")
                    } else {
                        Text("\(tipPercent.describeAsFixedLengthString())")
                    }
                     
                } header: {
                    Text("How much tip do you want to leave?")
                }
                Section {
                    Text(totalPerPerson, format: currencyStyle)
                } header: {
                    Text("Amount per person")
                }
                Section {
                    Text(grandTotal, format: currencyStyle)
                } header: {
                    Text("Total with tip")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

extension Double {
    func describeAsFixedLengthString(integerDigits: Int = 2, fractionDigits: Int = 2) -> String {
        self.formatted(
            .number
                .precision(
                    .integerAndFractionLength(integer: integerDigits, fraction: fractionDigits)
                )
        )
    }
}
