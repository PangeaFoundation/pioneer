import SwiftUI
import PangeaAggregator

struct RealTimeView: View {
    @Bindable var viewModel: RealTimeViewModel
    
    var sortedUpdates: [PriceUpdate] {
        viewModel.priceUpdates.sorted(using: KeyPathComparator(\.timestamp))
    }
    
    var sortedWindowsData: [WindowsData] {
        viewModel.windowsDataUpdates.sorted(using: KeyPathComparator(\.openTime))
    }
    
    var dataPicker: some View {
        Picker(selection: $viewModel.selectedData, label: EmptyView()) {
            ForEach(RealTimeViewModel.DataSelection.allCases) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var dataView: some View {
        Group {
            switch viewModel.selectedData {
            case .priceUpdates:
                priceUpdatesView
            case .windowsDataUpdates:
                windowsDataUpdatesView
            }
        }
    }
    
    var priceUpdatesView: some View {
        List {
            ForEach(sortedUpdates, id: \.transactionHash) { priceUpdate in
                PriceUpdateRow(priceUpdate: priceUpdate)
            }
        }
        .listStyle(.inset)
    }
    
    var windowsDataUpdatesView: some View {
        List {
            ForEach(sortedWindowsData) { windowsData in
                CandleRow(windowsData: windowsData)
            }
        }
        .listStyle(.inset)
    }
    
    var body: some View {
        Group {
            dataPicker
            dataView
        }
            .task {
                await openWebSocket()
                
            }
    }
}

extension RealTimeView {
    func openWebSocket() async {
        await viewModel.openWebSocket()
    }
    
}

#Preview {
    let client = AggregatorClient(client: FakePangeaAggregatorClient())
    let viewModel = RealTimeViewModel(client: client)
    return RealTimeView(viewModel: viewModel)
}
