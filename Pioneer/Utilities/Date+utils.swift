import Foundation
import PangeaAggregator

extension Date {
    enum Direction {
        case forward
        case backward
    }
    
    var shortString: String {
        DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .short)
    }
    
    var stringRelativeToNow: String {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.day, .hour, .minute]
        dateComponentsFormatter.unitsStyle = .abbreviated
        let dateRemaining = dateComponentsFormatter.string(from: self, to: Self.now) ?? ""
        return dateRemaining + " ago"
    }
    
    func otherTime(interval: Candle.TimeInterval, direction: Direction) -> Date {
        let multiplier = (direction == .forward) ? 1 : -1
        
        let timeInterval: DateComponents
        switch interval {
        case .minute:
            return Calendar.current.date(byAdding: .minute,
                                         value: 60 * multiplier,
                                         to: self)!
        case .hour:
            timeInterval = DateComponents(day: 1 * multiplier)
        case .day:
            timeInterval = DateComponents(day: 30 * multiplier)
        }
        
        return Calendar.current.date(byAdding: timeInterval, to: self)!
    }
}
