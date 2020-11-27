import Foundation

func makeURL() -> URL {
    return URL(string: "https://any.url.com/api")!
}

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeValidData() -> Data {
    return Data("{\"name\":\"felipe\"}".utf8)
}

func makeError() -> Error {
    return NSError(domain: "any_error", code: 0)
}
