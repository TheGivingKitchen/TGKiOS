import Foundation

class StabilityNetNetworkClient:NetworkClient {
    var processor: NetworkProcessor
    
    init() {
        self.processor = StabilityNetNetworkProcessor()
    }
    
    func processDataAndDecode<T: Decodable>(request: APIRequest, completionBlock: @escaping (Result<T, NetworkError>) -> Void) {
        self.processor.processData(request: request.constructRequest()) { result in
            switch result {
            case .success(let data):
                do {
                    let dataWithTopLevelJsonObjectRemoved = try self.responseDataWithTopLevelObjectRemoved(data: data)
                    let decodedModels = try JSONDecoder().decode(T.self, from: dataWithTopLevelJsonObjectRemoved)
                    completionBlock(.success(decodedModels))
                }
                catch {
                    completionBlock(.failure(.decodingError))
                }
                break
            case .failure(let apiError):
                completionBlock(.failure(apiError))
                break
            }
        }
    }
    
    private func responseDataWithTopLevelObjectRemoved(data:Data) throws -> Data {
        
        do {
            let decodedJsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            let innerResponseJson = try self.topLevelJsonObjectRemoved(jsonObject: decodedJsonObject)
            let reencodedDataFromJson = try JSONSerialization.data(withJSONObject: innerResponseJson, options: .fragmentsAllowed)
            
            return reencodedDataFromJson
        }
        catch {
            throw NetworkError.parsingError
        }
    }
    
    private func topLevelJsonObjectRemoved(jsonObject:[String:Any]?) throws -> [[String:Any]] {
        guard let unwrappedJson = jsonObject,
                let innerJson = unwrappedJson["records"] as? [[String:Any]] else {
            throw NetworkError.parsingError
        }
        
        return innerJson
    }
    
    
}

//MARK: Public Facade
extension StabilityNetNetworkClient {
    func getStabilityNetResources(completion: @escaping ([SafetyNetResourceModel]?, NetworkError?) -> Void) {
        let stabNetApiRequest = StabilityNetResourceAPIRequest()
        self.processDataAndDecode(request: stabNetApiRequest) { (result:Result<[StabilityNetResourceDTO], NetworkError>) in
            switch result {
            case .success(let stabilityNetResourceModels):
                //adapter to return more usable model
                print("adsf")
//                completion(stabilityNetResourceModels, nil)
                break
            case .failure(let networkError):
                completion(nil, networkError)
                break
                
            }
        }
    }
}
