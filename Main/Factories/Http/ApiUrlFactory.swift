import Foundation

func makeApiUrl(endPath: String) -> URL {
    return URL(string: "\(Environment.variable(.apiBaseUrl))/\(endPath)")!
}
