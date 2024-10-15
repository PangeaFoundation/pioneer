import Foundation
import PangeaAggregator

extension PangeaAggregator.PangeaAggregatorClient {
    override init() {
        self.init(apiHost: Configuration.apiHost,
                  authToken: Configuration.pangeaAuth,
                  tokenAddressWhitelist: Whitelist.list)
    }
}
