import SwiftUI

enum distanceUnit: String {
    case meters, kilometers, feet, yards, miles
}
extension distanceUnit: CaseIterable {}

struct DistanceConverterView: View {
    @State private var convertThis = 0.0
    @State private var unitOne: distanceUnit = distanceUnit.meters
    @State private var unitTwo: distanceUnit = distanceUnit.meters
    
    // magic numbers to make the code go brrrrr
    private let feetMeters = 3.28084
    private let feetKilometers = 3280.84
    private let feetYards = 3.0
    private let feetMiles = 5280.0
    
    private var lowestDenom: Double {
        switch unitOne {
        case .feet:
            return convertThis
        case .miles:
            return convertThis * feetMiles
        case .meters:
            return convertThis * feetMeters
        case .yards:
            return convertThis * feetYards
        case .kilometers:
            return convertThis * feetKilometers
        }
    }
    private var convertTo: Double {
        switch unitTwo {
        case .feet:
            return lowestDenom
        case .miles:
            return lowestDenom / feetMiles
        case .meters:
            return lowestDenom / feetMeters
        case .yards:
            return lowestDenom / feetYards
        case .kilometers:
            return lowestDenom / feetKilometers
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
                        ForEach(distanceUnit.allCases, id: \.self) {
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
                        ForEach(distanceUnit.allCases, id: \.self) {
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

struct DistanceConverterView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DistanceConverterView()
        }
    }
}
