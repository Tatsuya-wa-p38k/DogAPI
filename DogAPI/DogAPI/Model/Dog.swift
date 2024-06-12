import Foundation

class DogAPI {
    static func fetchDogBreeds(completion: @escaping ([String]?) -> Void) {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let dogBreedResponse = try decoder.decode(DogBreedResponse.self, from: data)
                let breeds = dogBreedResponse.message.keys.sorted()
                completion(breeds)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    static func fetchDogImages(for breed: String, completion: @escaping ([String]?) -> Void) {
        let urlString = "https://dog.ceo/api/breed/\(breed)/images"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let dogImagesResponse = try decoder.decode(DogImagesResponse.self, from: data)
                let images = dogImagesResponse.message
                completion(images)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}


