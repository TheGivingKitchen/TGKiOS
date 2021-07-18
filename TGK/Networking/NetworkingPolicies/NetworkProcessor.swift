import Foundation

public typealias DataRequestCallback = (Result<Data, NetworkError>) -> Void

protocol NetworkProcessor {
    func processData(request:URLRequest, completionBlock: @escaping DataRequestCallback)
}

