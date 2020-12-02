import Foundation


final class Environment {
    enum EnvironmentVariable: String {
        case apiBaseUrl = "API_BASE_URL"
    }
    
    static func variable(_ key: EnvironmentVariable) -> String {
        return Bundle.main.infoDictionary![key.rawValue] as! String
    }
}
