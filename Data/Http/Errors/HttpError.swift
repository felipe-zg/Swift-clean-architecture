import Foundation


public enum HttpError: Error {
    case noConectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}
