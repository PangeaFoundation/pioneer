import Foundation
import PangeaAggregator

@MainActor
@Observable
class CandleViewModel {
    var candleState: ViewState<Candle> = .waiting
    
    var showError = false
    var errorText = ""
    
    let client: AggregatorClient
    
    init(client: AggregatorClient) {
        self.client = client
    }
    
    func fetchCandles(address: String, startTime: Date, endTime: Date, interval: Candle.TimeInterval) async {
        candleState = .loading
        
        _ = (await client.getCandles(address: address, start: startTime, end: endTime, interval: interval))
            .map { candles in
                candleState = .loaded(items: candles)
                return ()
            }
            .mapError { error in
                print(error.localizedDescription)
                self.errorText = error.localizedDescription
                showError = true
                
                candleState = .waiting
                return error
            }
    }
}
