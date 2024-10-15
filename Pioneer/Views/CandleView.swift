import SwiftUI
import PangeaAggregator

struct CandleView: View {
    let viewModel: CandleViewModel
    let address: String
    let startTime: Date
    let endTime: Date
    let interval: Candle.TimeInterval
    
    init(viewModel: CandleViewModel,
         address: String,
         startTime: Date,
         interval: Candle.TimeInterval) {
        let endTime = startTime.otherTime(interval: interval,
                                          direction: .forward)
        self.init(viewModel: viewModel, address: address, startTime: startTime, endTime: endTime, interval: interval)
    }
    
    init(viewModel: CandleViewModel,
         address: String,
         endTime: Date,
         interval: Candle.TimeInterval) {
        let startTime = endTime.otherTime(interval: interval,
                                          direction: .backward)
        self.init(viewModel: viewModel, address: address, startTime: startTime, endTime: endTime, interval: interval)
    }
    
    init(viewModel: CandleViewModel,
         address: String,
         startTime: Date,
         endTime: Date,
         interval: Candle.TimeInterval) {
        self.viewModel = viewModel
        self.address = address
        self.startTime = startTime
        self.endTime = endTime
        self.interval = interval
    }
    
    func navigationTitle(candles: [Candle]) -> String {
        let symbol = candles.first?.symbol ?? ""
        let interval = interval.rawValue
        
        return "\(symbol) - \(interval)"
    }
    
    @MainActor
    var stateView: some View {
        Group {
            switch viewModel.candleState {
            case .waiting:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let candles):
                VStack {
                    CandleChart(candles: candles)
                    CandleListView(candles: candles.sorted().reversed())
                }
                .navigationTitle(navigationTitle(candles: candles))
            }
        }
    }
    
    var body: some View {
        VStack {
            stateView
        }
        .task {
            await fetchCandles()
        }
    }
}

extension CandleView {
    func fetchCandles() async {
        await viewModel.fetchCandles(address: address,
                                     startTime: startTime,
                                     endTime: endTime,
                                     interval: interval)
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    let client = AggregatorClient(client: FakePangeaAggregatorClient())
    let viewModel = CandleViewModel(client: client)
    CandleView(viewModel: viewModel,
               address: TestData.address,
               startTime: Date.now,
               interval: .hour)
}
#endif
