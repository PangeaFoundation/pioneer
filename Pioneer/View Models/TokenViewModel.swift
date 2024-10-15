import Foundation
import PangeaAggregator

@MainActor
@Observable
class TokenViewModel {
    var tokenState: ViewState<Token> = .waiting
    
    var showError = false
    @ObservationIgnored var errorText = ""
    
    let client: AggregatorClient
    
    init(client: AggregatorClient) {
        self.client = client

    }
    
    func fetchTokens() async {
        tokenState = .loading
        
        _ = (await client.getTokens())
            .map { tokens in
                tokenState = .loaded(items: tokens)
                return ()
            }
            .mapError { error in
                print(error.localizedDescription)
                self.errorText = error.localizedDescription
                showError = true
                
                tokenState = .waiting
                return error
            }
    }
}

