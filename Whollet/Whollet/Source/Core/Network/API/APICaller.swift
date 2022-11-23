import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum RequestError: Error {
        case wrongUrl
        case wrongData
    }
    
    func requestData<T: Codable>(urlString: String,
                                 method: HTTPMethod.RawValue,
                                 expecting: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void) {
        let url = URL(string: urlString)
        guard let urlPath = url else {
            return
        }
        var request = URLRequest(url: urlPath)
        request.httpMethod = method
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(RequestError.wrongData))
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        task.resume()
    }
}
