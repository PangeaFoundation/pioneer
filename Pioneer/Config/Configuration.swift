import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    static var apiHost: String {
        try! value(for: .apiHost)
    }
    
    static var pangeaAuth: String {
        try! value(for: .pangeaAuth)
    }
    
    private enum Key: String {
        case apiHost = "API_HOST"
        case pangeaAuth = "PANGEA_AUTH"
    }

    private static func value<T>(for key: Key) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key.rawValue) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}
