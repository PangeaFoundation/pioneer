import SwiftUI
import PangeaAggregator

struct PriceUpdateRow: View {
    let priceUpdate: PriceUpdate
    
    func labelAndValueWithPrecision(_ label: String, _ value: Double) -> some View {
        HStack {
            Text("\(label):")
            Text(value, format: .number.precision(.fractionLength(5)))
        }
    }
    
    var transactionInfoView: some View {
        VStack {
            LabelAndValue("Provider", priceUpdate.provider)
            LabelAndValue("Block Number", "\(priceUpdate.blockNumber)")
            Text(priceUpdate.timestamp.shortString)
        }
    }
    
    func tokenView(symbol: String,
                   amount: Double,
                   targetPrice: Double) -> some View {
        VStack {
            Text(symbol)
                .font(.headline)
            Text("Amount:")
            Text(amount, format: .number.precision(.fractionLength(5)))
            Text("Target Price:")
            Text(targetPrice, format: .number.precision(.fractionLength(5)))
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                tokenView(symbol: priceUpdate.token0Symbol,
                          amount: priceUpdate.amount0,
                          targetPrice: priceUpdate.t0TgtPrice)
                Spacer()
                tokenView(symbol: priceUpdate.token1Symbol,
                          amount: priceUpdate.amount1,
                          targetPrice: priceUpdate.t1TgtPrice)
            }
            transactionInfoView
        }
        .padding()
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    PriceUpdateRow(priceUpdate: TestData.priceUpdates.randomElement()!)
}
#endif
