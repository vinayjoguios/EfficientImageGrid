//
//  APIManager.swift
//  EfficientImageGrid

import Foundation
import Alamofire
import UIKit

struct HeaderKeys {
    static let authorization = "Authorization"
    static let accept = "Accept"
    static let contentType = "Content-Type"
}

class APIManager {
    
    static let shared = APIManager()
    
    //For example, the snake case key "first_name" would be converted to "firstName" in camel case.
    private let camelCaseDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() { }
    
    func request<T: Decodable>(WithUrlStr urlStr: String,
                               WithHttpMethod httpMethod: HTTPMethod,
                               WithHeaders httpHeaders: HTTPHeaders? = nil,
                               WithParameters parameters: Parameters? = nil,
                               WithCompletionCallback completionCallback: @escaping(Data?) -> Void,
                               WithSuccessCallback successCallback: @escaping(T) -> Void,
                               WithFailureCallback failureCallback: @escaping(String?) -> Void) {
        //Removing all cached responses if any
        URLCache.shared.removeAllCachedResponses()
        
        //Adding HttpHeaders
        var httpHeaders: HTTPHeaders? = httpHeaders
        if httpHeaders == nil {
            httpHeaders = HTTPHeaders()
        }
        guard var httpHeaders = httpHeaders else { return }
        httpHeaders[HeaderKeys.accept] = "application/json"
        httpHeaders[HeaderKeys.contentType] = "application/json"
        
        //Setting ParameterEncoding
        var encoding:ParameterEncoding!
        if httpMethod == .get {
            encoding = URLEncoding.Destination.methodDependent as? ParameterEncoding ?? URLEncoding.default
        } else {
            encoding = JSONEncoding.default
        }
        
        AF.request(urlStr, method: httpMethod, parameters: parameters, encoding: encoding, headers: httpHeaders).responseDecodable(of: T.self, decoder: camelCaseDecoder) { afDataResponse in
            //Debug response
            self.debugResponse(WithResponse: afDataResponse)
            
            //Calling callback as request processed
            completionCallback(afDataResponse.data)
            
            if afDataResponse.response?.statusCode ?? 0 == 401 {
                // LOGOUT
                return
            } else {
                switch(afDataResponse.result) {
                case .success:
                    successCallback(afDataResponse.value!)
                case .failure(let error):
                    guard NetworkReachabilityManager()!.isReachable else {
                        failureCallback("NO Internet")
                        return
                    }
                    failureCallback(error.errorDescription)
                }
            }
        }
    }
    
    private func debugResponse<T: Decodable>(WithResponse response: AFDataResponse<T>, WithParameters parameters: Parameters? = nil) {
        print("\n\n")
        print("*************************************************************************************")
        print("RequestedURL -> \(response.request?.url?.absoluteString ?? "")")
        print("StatusCode -> \(response.response?.statusCode ?? 0)")
        
        print("\n")
        print("AllHTTPHeaderFields -> ")
        if let allHTTPHeaderFieldsArr = response.request?.allHTTPHeaderFields {
            for key in allHTTPHeaderFieldsArr.keys {
                print("\(key): \(allHTTPHeaderFieldsArr[key] ?? "")")
            }
        }
        
        if (response.request?.httpMethod ?? "") == "GET" {
            print("\n")
            print("HttpMethod -> GET")
        } else if (response.request?.httpMethod ?? "") == "POST" {
            print("\n")
            print("HttpMethod -> POST")
            if let parameters = parameters {
                print("Parameters -> ")
                print(parameters)
            } else {
                if let responseData = response.request?.httpBody {
                    if let json = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print("Parameters -> ")
                        print(String(decoding: jsonData, as: UTF8.self))
                    } else {
                        assertionFailure("Malformed JSON")
                    }
                }
            }
        }
        
        if let responseData = response.data {
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                print("\n")
                print("Response -> ")
                print(String(decoding: jsonData, as: UTF8.self))
            } catch let parsingError as NSError {
                print("\n")
                print("Error -> ")
                print(parsingError.localizedDescription)
            }
        } else {
            print("\n")
            print("Error -> ")
            print(response.error!.asAFError?.localizedDescription ?? "")
        }
        
        //Checking if any error occurs while decoding data in failure cases
        switch(response.result) {
        case .success:
                break
        case .failure(_):
            self.validateResponse(dataIs: response.data, resultType: T.self)
        }
        print("*************************************************************************************")
        print("\n\n")
    }
    
    private func validateResponse<T: Decodable>(dataIs: Data?, resultType: T.Type) {
        guard let dataIs = dataIs else {
            print("Data object is nil")
            return
        }
        print("\n")
        print("Checking if any error occurs while decoding data ->")
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let messages = try decoder.decode(resultType.self, from: dataIs)
            //print(messages as Any)
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
    }
}


extension Encodable {
    
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    func asArray() throws -> [Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let data = try encoder.encode(self)
        guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else {
            throw NSError()  // Replace this with a more specific error type
        }

        return array
    }
    
}
