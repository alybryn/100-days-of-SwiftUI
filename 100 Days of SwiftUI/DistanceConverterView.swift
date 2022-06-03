import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                TimeConverterView()
            }
            .navigationTitle("Time Converter")
        }
        NavigationView {
            Form {
                DistanceConverterView()
            }
            .navigationTitle("Distance Converter")
        }
    }
}
