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
    
    var requiredHeaders: [String: String] {
        return ["trakt-api-version": "2",
                "trakt-api-key": clientID,
                "Content-Type":"application/json"]
    }
    
}

// MARK: - Authentication Token Management
extension TraktClient {

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
        let request = clientURLRequest("oauth/token", bodyParams: params, headers: requiredHeaders)
        post(request) { (success: Bool, object: [String : Any]?) in
            if !success {
                completion(false, "There was an error while requesting user access token")
            } else {
                self.saveTokens(from: object!)
                completion(true, "Access token received successfully with access token: \(object?["access_token"])")
            }
            
        }
    }
    
    func refreshAccessToken(completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let defaults = UserDefaults.standard
        guard let refreshToken = defaults.value(forKey: "refreshToken") as? String else {
            completion(false, "Refresh access token: Error while reading the old token")
            return
        }
        let params = ["refresh_token": refreshToken,
                      "client_id": clientID,
                      "client_secret": clientSecret,
                      "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
                      "grant_type": "refresh_token"]
        
        let request = clientURLRequest("oauth/token", bodyParams: params, headers: requiredHeaders)
        post(request) { (success: Bool, object: [String : Any]?) in
            if !success {
                completion(false, "There was an error while refreshing the user access token")
            } else {
                self.saveTokens(from: object!)
                completion(true, "Access token refreshed successfully with access token: \(object?["access_token"])")
            }
        }
    }
    
    func saveTokens(from object: [String : Any]) {
        let accessToken = object["access_token"] as! String
        let refreshToken = object["refresh_token"] as! String
        let defaults = UserDefaults.standard
        defaults.set(accessToken, forKey: "accessToken")
        defaults.set(refreshToken, forKey: "refreshToken")
    }
    
}

// MARK: - Get user settings
extension TraktClient {
    
    func getUserSettings(completion: @escaping (_ success: Bool) -> ()) {
        let defaults = UserDefaults.standard
        guard let accessToken = defaults.value(forKey: "accessToken") as? String else {
            completion(false)
            return
        }
        
        var headers = requiredHeaders
        headers["Authorization"] = "Bearer \(accessToken)"
        
        
        // TODO: slug should be used instead of username
        let request = clientURLRequest("users/settings", headers: headers)
        get(request) { (success: Bool, object: [String: Any]?) in
            guard success == true,
                let userInfo = object?["user"] as? [String: Any],
                let username = userInfo["username"] as? String
                else { completion(false); return }
            
            let defaults = UserDefaults.standard
            defaults.set(username, forKey: "username")
            
            completion(true)
        }
    }
    
    func updateWatchlistShows(completion: @escaping (_ success: Bool) -> ()) {
        let defaults = UserDefaults.standard
        guard let username = defaults.value(forKey: "username") as? String else {
            completion(false)
            return
        }
        
        var request = clientURLRequest("users/\(username)/watchlist/shows", headers: requiredHeaders)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error:Error?) in
            guard error == nil else { completion(false); return }
            guard let response = response as? HTTPURLResponse,
                200...299 ~= response.statusCode,
                let data = data
                else { completion(false); return }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let parsedJson = json as? [[String: Any]]
                else { completion(false); return }
            
            print(parsedJson)
            
            completion(true)
        }.resume()
    }
    
}
