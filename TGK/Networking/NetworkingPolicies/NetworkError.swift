import Foundation

public enum NetworkError:Error {
    case badRequest
    case unauthorized
    case forbidden
    case requestTimeout
    case internalServerError
    case parsingError
    case decodingError
    
    case unknown
    
    init(urlResponse:URLResponse?) {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            self = .unknown
            return
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 400:
            self = .badRequest
            break
        case 401:
            self = .unauthorized
            break
        case 403:
            self = .forbidden
            break
        case 408:
            self = .requestTimeout
            break
        case 500...599:
            self = .internalServerError
            break
        default:
            self = .unknown
            break
        }
    }
}
