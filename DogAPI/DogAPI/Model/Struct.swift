import Foundation

struct DogBreedResponse: Codable {
    let message: [String: [String]]
    let status: String
}

struct DogImagesResponse: Codable {
    let message: [String]
    let status: String
}
