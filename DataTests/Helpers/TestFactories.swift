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
