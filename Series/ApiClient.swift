//
//  ApiClient.swift
//  ApiClient
//
//  Created by Konstantinos Loutas on 11/08/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//
//  Inspired by a relevant post on That Thing in Swift:
//  https://thatthinginswift.com/write-your-own-api-clients-swift/
//

import Foundation

protocol ApiClient {
    
    // This needs to be implemented for each client conforming to ApiClient
    var apiEndpoint: String { get }
    
    // A functional default implementation of all methods is provided below
    func clientURLRequest(_ path: String, bodyParams params: [String: Any]?, headers: [String: String]?) -> URLRequest
    func post(_ request: URLRequest, completion: @escaping (_ success: Bool, _ object: [String: Any]?) -> ())
    func put(_ request: URLRequest, completion: @escaping (_ success: Bool, _ object: [String: Any]?) -> ())
    func get(_ request: URLRequest, completion: @escaping (_ success: Bool, _ object: [String: Any]?) -> ())
    
}

// MARK: - Default implementations of protocol methods
extension ApiClient {
    
    // In short, the default implementation:
    //  (1) creates the URL that contains the request
    //  (2) offers convenience functions for making POST, PUT and GET requests
    //  (3) submits a request to the server and serializes the responce (assuming JSON format)
    
    // MARK: (1) Create a URL request
    func clientURLRequest(_ path: String, bodyParams params: [String: Any]? = nil, headers: [String: String]? = ["application/json": "application/json"]) -> URLRequest {
        var request = URLRequest(url: (URL(string: apiEndpoint)?.appendingPathComponent(path))!)
        
        if let params = params,
            let encodedParams = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
            request.httpBody = encodedParams
        }
        if let headers = headers {
            for (headerField, value) in headers {
                request.setValue(value, forHTTPHeaderField: headerField)
            }
        }
        
        return request
    }
    
    // MARK: (2) Endpoints for POST, PUT and GET requests
    func post(_ request: URLRequest, completion: @escaping (_ success: Bool, _ object: [String: Any]?) -> ()) {
        dataTask(request, method: "POST", completion: completion)
    }
    
    func put(_ request: URLRequest, completion: @escaping (_ success: Bool, _ object: [String: Any]?) -> ()) {
        dataTask(request, method: "PUT", completion: completion)
    }
    
    func get(_ request: URLRequest, completion: @escaping (_ success: Bool, _ object: [String: Any]?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
}

// MARK: - Internal protocol methods
extension ApiClient {
    
    // MARK: (3) Retrieve URL contents with JSON serialization
    fileprivate func dataTask(_ request: URLRequest, method: String, completion: @escaping (_ success: Bool, _ object: [String: Any]?) -> ()) {
        var request = request
        request.httpMethod = method
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            print((response as? HTTPURLResponse)?.statusCode as Any)
            if let data = data {
                print(data)
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String: Any],
                    let response = response as? HTTPURLResponse,
                    200...299 ~= response.statusCode {
                    completion(true, json)
                } else {
                    completion(false, nil)
                }
            }
            }.resume()
    }
    
}

// MARK: - Helper methods
extension ApiClient {
    
    // Converts a dictionary of parameters to a single string 
    func convert(_ params: [String: Any]) -> String? {
        var paramString = ""
        for (key, value) in params {
            if let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let escapedValue = (value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                paramString += "\(escapedKey)=\(escapedValue)&"
            }
        }
        return paramString
    }
    
}
