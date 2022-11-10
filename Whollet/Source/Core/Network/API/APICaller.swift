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
    
    func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let apiURL = url else {
            return
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = type.rawValue
        completion(request)
    }
    
    func getRequest<T: Codable, P:BaseRequestParams>(request params: P, baseURL: String, endpoint: String, completion: @escaping(Result<T, Error>) -> Void) {
        createRequest(with: URL(string: baseURL + endpoint + params.toPath()), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.notModified))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                }
                
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
