//
//  TraktClient.swift
//  Series
//
//  Created by Konstantinos Loutas on 11/12/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import Foundation
import SafariServices
import UIKit

struct TraktClient: ApiClient {
    
//    var apiEndpoint = "https://private-anon-7d4f25ca89-trakt.apiary-mock.com" // MOCK ENDPOINT
    var apiEndpoint = "https://api.trakt.tv"
    
    let clientID = "4e576144747b7411b2f7029feb039edbf6baaca98b43b22db407a611745c32bf"
    let clientSecret = "b2b57762b71b57a8e66192ebb392a230c5d8ff9185beb204ab43ad6c9fce5f2b"
    
    var headers: [String: String] {
        return ["trakt-api-version": "2",
                "trakt-api-key": clientID,
                "Content-Type":"application/json"]
    }
    
    var authenticationRequestUrl: URL? {
        let authEndpoint = "https://trakt.tv/oauth/authorize"
        let params = ["response_type": "code",
                      "client_id": clientID,
                      "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
                      "state": "test"]
        if let encodedParams = convert(params) {
            let authUrlString = authEndpoint.appending("?\(encodedParams)")
            let authUrl = URL(string: authUrlString)
            return authUrl
        } else {
            return nil
        }
    }
    
//    func requestAuthorization(completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
//        let path = "oauth/authorize"
//        let params = ["response_type": "code",
//                      "client_id": clientID,
//                      "redirect_uri": "com.CLoutas.Series"/*,
//                      "state": "test"*/]
//        guard let paramsString = convert(params),
//            let url = URL(string: (apiEndpoint + "/" + path + "?" + paramsString))
//            else {
//                completion(false, "Authorization request failed during setup.")
//                return
//        }
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        get(request) { (success, object: [String : Any]?) in
//            
//        }
//    }
    
    func requestAccessToken(withUserAuthorizationCode code: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let params = ["code": code,
                      "client_id": clientID,
                      "client_secret": clientSecret,
                      "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
                      "grant_type": "authorization_code"]
        let request = clientURLRequest("oauth/token", bodyParams: params)
        post(request) { (success: Bool, object: [String : Any]?) in
            if !success {
                completion(false, "There was an error while requesting user access token")
            } else {
                completion(true, "Access token received successfully with access token: \(object?["access_token"])")
            }
            
        }
    }
    
}

// MARK: - Sample public methods
//func login(_ email: String, password: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
//    let loginObject = ["email": email, "password": password]
//    
//    post(clientURLRequest("auth/local", params: loginObject as [String: Any]?)) { (success, object) -> () in
//        
//        DispatchQueue.main.async(execute: { () -> Void in
//            if success {
//                completion(true, nil)
//            } else {
//                var message = "there was an error"
//                if let object = object, let passedMessage = (object as AnyObject)["message"] as? String {
//                    message = passedMessage
//                }
//                completion(true, message)
//            }
//        })
//    }
//}
