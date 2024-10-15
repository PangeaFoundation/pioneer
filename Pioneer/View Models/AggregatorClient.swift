import Foundation
import PangeaAggregator

@Observable
final class AggregatorClient: Sendable {
    var priceWebSocketStream: WebSocketDataStream<PriceUpdate>? {
        get async {
            await client.priceWebSocketStream
        }
    }
    
    var windowsDataWebSocketStream: WebSocketDataStream<WindowsData>? {
        get async {
            await client.windowsDataWebSocketStream
        }
    }
    
    let client: PangeaAggregatorClientProtocol
    init(client: PangeaAggregatorClientProtocol = PangeaAggregatorClient()) {
        self.client = client
        
        URLCache.shared.memoryCapacity = 10_000_000
        URLCache.shared.diskCapacity = 1_000_000_000
    }
    
    func getTokens() async -> Result<[Token], PangeaAggregatorError> {
        await client.getTokens()
    }
    
    func getCandles(address: String, start: Date, end: Date, interval: Candle.TimeInterval) async -> Result<[Candle], PangeaAggregatorError> {
        await client.getCandles(address: address, start: start, end: end, interval: interval)
    }
    
    func openWebSocket() async throws {
        try await client.openWebSocket()
    }
}

