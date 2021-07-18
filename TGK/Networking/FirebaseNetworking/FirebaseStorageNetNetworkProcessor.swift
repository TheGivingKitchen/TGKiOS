import Foundation

public class FirebaseStorageNetNetworkProcessor:NetworkProcessor {
    
    internal let session:URLSession
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        sessionConfig.urlCache = nil
        sessionConfig.timeoutIntervalForRequest = 10.0
        self.session = URLSession(configuration: sessionConfig)
    }
    
    func processData(request: URLRequest, completionBlock: @escaping DataRequestCallback) {
        self.session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                let apiErrorFromResponse = NetworkError(urlResponse: response)
                completionBlock(.failure(apiErrorFromResponse))
                return
            }
            
            //TODO throw error based on status code
            
            guard let data = data else {
                completionBlock(.failure(.parsingError))
                return
            }
            
            completionBlock(.success(data))
        }.resume()
    }
    
    
    
    
    
}
