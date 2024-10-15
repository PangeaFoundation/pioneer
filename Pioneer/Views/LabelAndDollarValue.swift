import SwiftUI

struct LabelAndDollarValue: View {
    let label: String
    let value: Double
    init(_ label: String, _ value: Double) {
        self.label = label
        self.value = value
    }
   
    var body: some View {
        LabelAndValue(label, value.dollarFormatted)
    }
}

#Preview {
    LabelAndDollarValue("Hammertime", 42.7298)
}
