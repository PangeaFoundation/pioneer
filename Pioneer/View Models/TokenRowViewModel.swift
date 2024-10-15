import Foundation
import PangeaAggregator

@Observable
class TokenRowViewModel {
    var candleState: ViewState<Candle> = .waiting
    
    let client: AggregatorClient
    init(client: AggregatorClient) {
        self.client = client
    }
    
    @MainActor
    func fetchCandles(token: Token) async {
        candleState = .loading
        
        let interval = Candle.TimeInterval.minute
        let endTime = Date.now
        let startTime = Calendar.current.date(byAdding: .day,
                                              value: -1,
                                              to: endTime)!
        
        _ = (await client.getCandles(address: token.address,
                                     start: startTime,
                                     end: endTime,
                                     interval: interval))
            .map { candles in
                if candles.count > 1 {
                    candleState = .loaded(items: candles)
                } else {
                    candleState = .waiting
                }
                return ()
            }
            .mapError { error in
                print(error.localizedDescription)
                
                candleState = .waiting
                return error
            }
    }
}
    
