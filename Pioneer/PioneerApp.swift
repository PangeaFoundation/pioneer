import SwiftUI

@main
struct PioneerApp: App {
    @State private var client = AggregatorClient()

    var body: some Scene {
        WindowGroup {
            TokensView(viewModel: TokenViewModel(client: client))
                .environment(client)
        }
    }
}
