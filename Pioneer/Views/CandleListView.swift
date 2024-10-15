import SwiftUI
import PangeaAggregator

struct CandleListView: View {
    @Environment(AggregatorClient.self) var client: AggregatorClient
    
    let candles: [Candle]
    
    private func getDestinationView(candle: Candle) -> CandleView? {
        let nextInterval: Candle.TimeInterval?
        
        switch candle.interval {
        case .day:
            nextInterval = .hour
        case .hour:
            nextInterval = .minute
        case .minute:
            nextInterval = nil
        }
        
        guard let nextInterval else {
            return nil
        }
        
        return CandleView(viewModel: CandleViewModel(client: client),
                          address: candle.address,
                          startTime: candle.startTime,
                          interval: nextInterval)
    }
    
    var body: some View {
        List {
            ForEach(candles) { candle in
                if let destionationView = getDestinationView(candle: candle) {
                    NavigationLink(destination: destionationView) {
                        CandleRow(candle: candle)
                    }
                } else {
                    CandleRow(candle: candle)
                }
            }
        }
        .listStyle(.inset)
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    CandleListView(candles: TestData.candlesByHour)
        .environment(
            AggregatorClient(client: FakePangeaAggregatorClient())
        )
}
#endif
