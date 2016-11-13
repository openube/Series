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
    
    var apiEndpoint = "https://api.trakt.tv"
    let clientID = "4e576144747b7411b2f7029feb039edbf6baaca98b43b22db407a611745c32bf"
    
    var headers: [String: String] {
        return ["trakt-api-version": "2","trakt-api-key": clientID]
    }
    
    var authenticationRequestUrl: URL? {
        let authEndpoint = "https://trakt.tv/oauth/authorize"
        let params = ["response_type": "code",
                      "client_id": clientID,
                      "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
                      "state": "test"]
        if let encodedParams = convertParams(params) {
            let authUrlString = authEndpoint.appending("?\(encodedParams)")
            let authUrl = URL(string: authUrlString)
            return authUrl
        } else {
            return nil
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
