import SwiftUI
import PangeaAggregator

struct TokensView: View {
    @Environment(AggregatorClient.self) var client: AggregatorClient
    
    var viewModel: TokenViewModel
    
    var realTimeLink: some View {
        NavigationLink(destination: RealTimeView(viewModel: RealTimeViewModel(client: client))) {
            Text("View Real-time Data")
                .font(.headline)
        }
        .foregroundStyle(.black)
        .background(.white)
    }

    var stateView: some View {
        Group {
            switch viewModel.tokenState {
            case .waiting:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let tokens):
                realTimeLink
                TokensListView(tokens: tokens)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                stateView
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Spacer()
                                Image(.logo)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Pangea")
                                    .font(.title)
                                Spacer()
                            }
                        }
                    }
            }

        }
        .task {
            await fetchTokens()
        }
        .navigationViewStyle(.stack)
    }
}

extension TokensView {
    func fetchTokens() async {
        await viewModel.fetchTokens()
    }
}

#if DEBUG
#Preview {
    let client = AggregatorClient(client: FakePangeaAggregatorClient())
    let viewModel = TokenViewModel(client: client)
    TokensView(viewModel: viewModel)
        .environment(
            AggregatorClient(client: FakePangeaAggregatorClient())
        )
}
#endif
