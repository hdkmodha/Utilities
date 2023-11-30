//
//  WebServiceManager.swift
//
//
//  Created by Hardik Modha on 29/11/23.
//

import Foundation
import Alamofire

class WebServiceManager {
    
    static let shared = WebServiceManager()
    
    private init() {}
    
    static var isReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    lazy var session: Session = {
        let configure = URLSessionConfiguration.ephemeral
        configure.httpCookieStorage = nil
        configure.httpCookieAcceptPolicy = .never
        configure.httpShouldSetCookies = false
        let session = Session(configuration: configure)
        return session
    }()
    
    func fetch<Value>(resource: WebResource<Value>, witnCompletion completion: @escaping (Result<Value, ServerStatus>) -> Void) -> RequestToken? {
        
        guard let url = resource.url else {
            assertionFailure("Provide valid url")
            return nil
        }
        
        var headers: HTTPHeaders?
        let parameter = resource.httpMethod.parameter
        let method = resource.httpMethod.method
        
        if let header = resource.header {
            headers = HTTPHeaders(header)
        }
        
        print("------------ API Details ---------------")
        print("API URL: \(url)")
        print("API Method: \(method)")
        print("API Parameter: \(String(describing: parameter))")
        print("API Headers: \(String(describing: headers))")
        
        let dataTask  = self.session.request(url, method: method, parameters: parameter, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseData { (response) in
            
            self.processResponse(response: response, decode: resource.decode, completion: completion)
            
        }
        
        return RequestToken(task: dataTask)
        
    }
    
    private func processResponse<Value>(response: AFDataResponse<Data>, decode: (Data) -> Result<Value, ServerStatus>, completion: @escaping (Result<Value, ServerStatus>) -> Void) {
        
        
        guard let httpResponse = response.response else {
            completion(.failure(.internalServerError))
            return
        }
        
        if let serverStatus = ServerStatus(rawValue: httpResponse.statusCode) {
            switch serverStatus {
            case .success:
                switch response.result {
                case .success(let data):
                    completion(decode(data))
                case .failure:
                    completion(.failure(.forbidden))
                }
            default:
                completion(.failure(serverStatus))
            }
            
        }
        
        
    }
}
