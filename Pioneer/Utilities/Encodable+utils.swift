import Foundation

extension Encodable {
    var asString: String {
        guard let data = try? JSONEncoder().encode(self) else {
            return "{}"
        }
        return String(data: data, encoding: .utf8) ?? "{}"
    }
}
