import Foundation
import PangeaAggregator
import PangeaAggregatorTestData

actor FakePangeaAggregatorClient: PangeaAggregatorClientProtocol {
    var priceWebSocketStream: PangeaAggregator.WebSocketDataStream<PangeaAggregator.PriceUpdate>?
    
    var windowsDataWebSocketStream: PangeaAggregator.WebSocketDataStream<PangeaAggregator.WindowsData>?
    
    func openWebSocket() async throws {
    }
    
    func sleepABit() async {
        try? await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_000_000_000))
    }
    
    
    var getTokens_error: PangeaAggregatorError?
    func getTokens() async -> Result<[Token], PangeaAggregatorError> {
        await sleepABit()
        
        if let getTokens_error {
            return .failure(getTokens_error)
        }
        return .success(TestData.filteredTokens)
    }
    
    var getCandles_error: PangeaAggregatorError?
    func getCandles(address: String, start: Date, end: Date, interval: Candle.TimeInterval) async -> Result<[Candle], PangeaAggregatorError> {
        await sleepABit()
        
        if let getCandles_error {
            return .failure(getCandles_error)
        }
        
        switch interval {
        case .minute:
            return .success(TestData.candlesByMinute)
        case .hour:
            return .success(TestData.candlesByHour)
        case .day:
            return .success(TestData.candlesByDay)
        }
    }
}

