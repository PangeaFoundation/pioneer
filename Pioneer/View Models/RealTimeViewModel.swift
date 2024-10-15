import Foundation
import PangeaAggregator

@MainActor
@Observable
class RealTimeViewModel {
    enum DataSelection: String, CaseIterable, Identifiable {
        case priceUpdates = "Price Updates"
        case windowsDataUpdates = "Windows Data Updates"
        
        var id: Self { self }
    }

    var selectedData: DataSelection = .priceUpdates
    
    var priceUpdates: [PriceUpdate] = []
    var windowsDataUpdates: [WindowsData] = []
    
    let client: AggregatorClient
    init(client: AggregatorClient) {
        self.client = client
    }
    
    func openWebSocket() async {
        do {
            try await client.openWebSocket()
            guard let priceStream = await client.priceWebSocketStream,
                  let windowsDataStream = await client.windowsDataWebSocketStream else {
                return
            }
            Task {
                await processStream(priceStream) { values in
                    priceUpdates += values
                }
            }
            Task {
                await processStream(windowsDataStream) { values in
                    windowsDataUpdates += values
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func processStream<T: Sendable & Codable>(_ stream: WebSocketDataStream<T>, appender: ([T]) -> Void) async {
        for await message in stream {
            switch message {
            case .success(let success):
                appender(success)
            case .failure(let failure):
                print("Error processing stream: \(failure.localizedDescription)")
            }
        }
    }
}
