import Foundation

protocol APIRequest {
    var endpoint:Endpoint { get }
    func constructRequest() -> URLRequest
}
