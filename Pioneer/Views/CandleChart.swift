import SwiftUI
import Charts
import PangeaAggregator

struct CandleChart: View {
    let candles: [Candle]
    private let minPrice: Double
    private let maxPrice: Double
    private let padding: Double
    
    init(candles: [Candle]) {
        self.candles = candles
        
        let opens = candles.map({ $0.open })
        let closes = candles.map({ $0.close })
        
        minPrice = (opens + closes).min() ?? 0
        
        maxPrice = (opens + closes).max() ?? 0
        
        padding = (maxPrice - minPrice) * 0.1
    }
    
    private var yAxisMin: Double {
        let min = minPrice - padding
        return (min > 0) ? min : 0
    }
    
    private var yAxisMax: Double {
        maxPrice + padding
    }
    
    private func candleColor(_ candle: Candle) -> Color {
        (candle.close > candle.open) ? .green : .red
    }
    
    private var yAxisSpan: Double {
        yAxisMax - yAxisMin
    }
    
    
    private func candlestick(_ candle: Candle) ->  CandlestickMark<Date, Double> {
        let minimumGap: Double = yAxisSpan * 0.02
        let open: Double
        if candle.open - candle.close < minimumGap {
            open = candle.open + minimumGap
        } else {
            open = candle.open
        }
        
        return CandlestickMark(x: .value("timestamp", candle.startTime),
                               low: .value("low", candle.low),
                               high: .value("high", candle.high),
                               open: .value("open", open),
                               close: .value("close", candle.close),
                               color: candleColor(candle))
    }
    
    var body: some View {
        Chart {
            ForEach(candles.sorted()) { candle in
                candlestick(candle)
            }
        }
        .chartYScale(domain: [yAxisMin, yAxisMax])
        .chartScrollPosition(initialX: Date.now)
        .chartScrollableAxes(.horizontal)
    }
}

fileprivate struct CandlestickMark<X: Plottable, Y: Plottable>: ChartContent {
    let x: PlottableValue<X>
    let low: PlottableValue<Y>
    let high: PlottableValue<Y>
    let open: PlottableValue<Y>
    let close: PlottableValue<Y>
    let color: Color
    
    init(
        x: PlottableValue<X>,
        low: PlottableValue<Y>,
        high: PlottableValue<Y>,
        open: PlottableValue<Y>,
        close: PlottableValue<Y>,
        color: Color
    ) {
        self.x = x
        self.low = low
        self.high = high
        self.open = open
        self.close = close
        self.color = color
    }
    
    var body: some ChartContent {
        RectangleMark(x: x, yStart: low, yEnd: high, width: 2)
            .foregroundStyle(color)
        RectangleMark(x: x, yStart: open, yEnd: close, width: 16)
            .foregroundStyle(color)
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    CandleChart(candles: TestData.candlesByHour)
}
#endif
