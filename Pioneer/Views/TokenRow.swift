import SwiftUI
import PangeaAggregator

struct TokenRow: View {
    let viewModel: TokenRowViewModel
    let token: Token
    
    var logo: some View {
        AsyncImage(url: token.iconURL,
                   content: { $0.resizable().aspectRatio(contentMode: .fit) },
                   placeholder: { EmptyView() })
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .padding()
    }
    
    var symbol: some View {
        let symbol = token.symbol.trimmingCharacters(in: .whitespaces)
        return Text(symbol)
            .font(.title)
    }
    
    var name: some View {
        let name = token.name.trimmingCharacters(in: .whitespaces)
        return Text(name)
            .font(.headline)
    }
    
    var price: some View {
        return Text(token.usdPrice.dollarFormatted)
    }
    
    var address: some View {
        let address = token.address.prefix(6)
        + "..." + token.address.suffix(4)
        return Text(address)
    }
    
    var lastUpdate: some View {
        Text(token.lastUpdate.shortString)
            .font(.subheadline)
    }
    var lineChart: some View {
        Group {
            switch viewModel.candleState {
            case .waiting:
                EmptyView()
            case .loading:
                EmptyView()
            case .loaded(let candles):
                CandleLineChart(candles: candles)
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                logo
                VStack {
                    symbol
                    name
                }
                Spacer()
                VStack {
                    address
                    price
                    lastUpdate
                }
            }
            lineChart
        }
        .padding([.horizontal, .bottom])
        .task {
            await fetchCandles()
        }
    }
}

extension TokenRow {
    func fetchCandles() async {
        Task {
            await viewModel.fetchCandles(token: token)
        }
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    let token = TestData.tokens.filter { $0.symbol == "PEPE"}.first!
    let client = AggregatorClient(client: FakePangeaAggregatorClient())
    let viewModel = TokenRowViewModel(client: client)
    TokenRow(viewModel: viewModel, token: token)
}
#endif
