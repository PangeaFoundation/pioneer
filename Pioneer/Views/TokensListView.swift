import SwiftUI
import PangeaAggregator

struct TokensListView: View {
    @Environment(AggregatorClient.self) var client: AggregatorClient
    
    let tokens: [Token]

    func candleView(address: String) -> CandleView {
        CandleView(viewModel: CandleViewModel(client: client),
                   address: address,
                   endTime: .now,
                   interval: .day)
    }
    
    var body: some View {
        List {
            ForEach(tokens) { token in
                NavigationLink(destination: candleView(address: token.address)) {
                    TokenRow(viewModel: TokenRowViewModel(client: client),
                             token: token)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .listStyle(.inset)
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    TokensListView(tokens: TestData.filteredTokens)
        .environment(
            AggregatorClient(client: FakePangeaAggregatorClient())
        )
}
#endif
