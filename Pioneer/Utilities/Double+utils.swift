import Foundation

extension Double {
    var dollarFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.locale = Locale(identifier: "en_US")
        if self < 1 {
            formatter.minimumSignificantDigits = 4
            formatter.maximumSignificantDigits = 4
        }
        return formatter.string(for: self) ?? ""
    }
}
 
