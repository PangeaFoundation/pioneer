import SwiftUI

struct LabelAndValue: View {
    let label: String
    let value: String
    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text("\(label):")
            Text(value)
        }
    }
}

#Preview {
    LabelAndValue("Label", "247.61")
}
