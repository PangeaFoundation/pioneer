import Foundation
import PangeaAggregator
import PangeaAggregatorTestData

extension TestData {
    static var filteredTokens: [Token] {
        tokens.filter { Whitelist.list.contains($0.address) }
    }
}
