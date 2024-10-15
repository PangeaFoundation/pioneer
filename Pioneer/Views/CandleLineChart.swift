import SwiftUI
import Charts
import PangeaAggregator

struct CandleLineChart: View {
    let candles: [Candle]
    private let prices: [Double]
    private let minPrice: Double
    private let maxPrice: Double
    private let padding: Double
    
    init(candles: [Candle]) {
        self.candles = candles
        self.prices = candles.map({ $0.close })
        
        minPrice = prices.min() ?? 0
        maxPrice = prices.max() ?? 0
        padding = (maxPrice - minPrice) * 0.1
    }
    
    private var yAxisMin: Double {
        let min = minPrice - padding
        return (min > 0) ? min : 0
    }
    
    private var yAxisMax: Double {
        maxPrice + padding
    }
    
    var body: some View {
        Chart {
            ForEach(candles.sorted()) { candle in
                LineMark(x: .value("Timestamp", candle.startTime),
                         y: .value("Close", candle.close))
            }
            
        }
        .chartYScale(domain: [yAxisMin, yAxisMax])
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    CandleLineChart(candles: TestData.candlesByHour)
}
#endif
