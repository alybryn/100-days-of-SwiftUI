import SwiftUI

enum timeUnit: String {
    case seconds, minutes, hours, days
}
extension timeUnit: CaseIterable {}

struct TimeConverterView: View {
    @State private var convertThis = 0.0
    @State private var unitOne: timeUnit = timeUnit.seconds
    @State private var unitTwo: timeUnit = timeUnit.seconds
    
    // magic numbers to make the code go brrrrr
    private let secMin = 60.0
    private let secHour = 3600.0
    private let secDay = 86400.0
    
    private var lowestDenom: Double {
        switch unitOne {
        case .seconds:
            return convertThis
        case .minutes:
            return convertThis * secMin
        case .hours:
            return convertThis * secHour
        case .days:
            return convertThis * secDay
        }
    }
    private var convertTo: Double {
        switch unitTwo {
        case .seconds:
            return lowestDenom
        case .minutes:
            return lowestDenom / secMin
        case .hours:
            return lowestDenom / secHour
        case .days:
            return lowestDenom / secDay
        }
    }
    var body: some View {
        VStack {
            Section {
                VStack{
                    HStack {
                        TextField("Value to convert", value: $convertThis, format: .number)
                        Text(unitOne.rawValue)
                    }
                    .padding(.horizontal)
                    .background(.black)
                    //.scaledToFit()
                    Picker("Convert from units:", selection: $unitOne) {
                        ForEach(timeUnit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            } header: {
                Text("Convert from:")
            }
            
            Section {
                VStack {
                    HStack {
                        Text(convertTo, format: .number)
                        Spacer()
                        Text(unitTwo.rawValue)
                    }
                    .padding(.horizontal)
                    .background(.black)
                    Picker("Convert to units:", selection: $unitTwo) {
                        ForEach(timeUnit.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .scaledToFit()
                }
            } header: {
                Text("Convert to:")
            }
            
        }
    }
}

struct TimeConverterView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimeConverterView()
        }
    }
}
