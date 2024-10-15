import SwiftUI
import PangeaAggregator

struct CandleRow: View {
    let symbol: String
    let interval: Candle.TimeInterval?
    let startTime: Date
    let open, close, high, low: Double
    let volume: Double
    let volumeDollars: Double
    init(candle: Candle) {
        self.symbol = candle.symbol
        self.interval = candle.interval
        self.startTime = candle.startTime
        (open, close, high, low) = (candle.open, candle.close, candle.high, candle.low)
        self.volume = candle.volume
        self.volumeDollars = candle.volumeDollars
    }
    
    init(windowsData: WindowsData) {
        self.symbol = windowsData.tokenSymbol
        self.interval = nil
        self.startTime = windowsData.openTime
        (open, close, high, low) = (windowsData.open, windowsData.close, windowsData.high, windowsData.low)
        self.volume = windowsData.volume
        self.volumeDollars = windowsData.volumeDollars
        
    }
    
    
    private var nameView: some View {
        Text(symbol)
            .font(.headline)
    }
    
    private var intervalView: some View {
        Group {
            if let interval {
                let interval = "\(interval.rawValue) interval"
                Text(interval)
            } else {
                EmptyView()
            }
        }
    }
    
    private var timeView: some View {
        HStack {
            Text(startTime.shortString)
            Spacer()
            Text("(\(startTime.stringRelativeToNow))")
        }
    }
    
    private var openView: some View {
        LabelAndDollarValue("Open", open)
    }
    
    private var closeView: some View {
        LabelAndDollarValue("Close", close)
    }
    
    private var highView: some View {
        LabelAndDollarValue("High", high)
    }
    
    private var lowView: some View {
        LabelAndDollarValue("Low", low)
    }
    
    private var volumeView: some View {
        HStack {
            Text(volume, format: .number.precision(.fractionLength(5)))
            Text(symbol)
        }
    }
    
    private var volumeDollarsView: some View {
        Text(volumeDollars.dollarFormatted)
    }
    
    private var pricesView: some View {
        HStack {
            VStack {
                openView
                closeView
            }
            Spacer()
            VStack {
                highView
                lowView
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                nameView
                Spacer()
                intervalView
            }
            timeView
            HStack {
                pricesView
            }
            HStack {
                Text("Volume:")
                VStack {
                    volumeView
                    volumeDollarsView
                }
            }
        }
        .padding()
    }
}

#if DEBUG
import PangeaAggregatorTestData
#Preview {
    CandleRow(candle: TestData.singleMinuteCandle)
    CandleRow(windowsData: TestData.windowsData.randomElement()!)
}
#endif
