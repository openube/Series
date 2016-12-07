//
//  TraktClient.swift
//  Series
//
//  Created by Konstantinos Loutas on 11/12/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import Foundation

struct TraktClient: ApiClient {
    
    var useMockTraktEndpoint = false
    
    var apiEndpoint: String {
        if useMockTraktEndpoint {
            return "https://private-anon-7d4f25ca89-trakt.apiary-mock.com"
        } else {
            return "https://api.trakt.tv"
        }
    }
    
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
                let accessToken = object?["access_token"] as! String
                let defaults = UserDefaults.standard
                defaults.set(accessToken, forKey: "accessToken")
                completion(true, "Access token received successfully with access token: \(object?["access_token"])")
            }
            
        }
    }
    
    func refreshAccessToken(completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let defaults = UserDefaults.standard
        guard let oldAccessToken = defaults.value(forKey: "accessToken") as? String else {
            completion(false, "Refresh access token: Error while reading the old token")
            return
        }
        let params = ["refresh_token": oldAccessToken,
                      "client_id": clientID,
                      "client_secret": clientSecret,
                      "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
                      "grant_type": "refresh_token"]
        let request = clientURLRequest("oauth/token", bodyParams: params, headers: headers)
        post(request) { (success: Bool, object: [String : Any]?) in
            if !success {
                completion(false, "There was an error while refreshing the user access token")
            } else {
                let accessToken = object?["access_token"] as! String
                let defaults = UserDefaults.standard
                defaults.set(accessToken, forKey: "accessToken")
                completion(true, "Access token refreshed successfully with access token: \(object?["access_token"])")
            }
            
        }
    }
    
}
