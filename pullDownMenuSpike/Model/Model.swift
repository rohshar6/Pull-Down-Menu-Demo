import Foundation

struct ImageData: Decodable {
    let urls: Urls
    let id: String
}

struct Urls: Decodable {
    let regular: String
    var regularUrl: URL {
        return URL(string: regular)!
    }
}

struct ImageModel {
    let urlString: String
}
