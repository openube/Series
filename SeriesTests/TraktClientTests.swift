//
//  TraktClientTests.swift
//  Series
//
//  Created by Konstantinos Loutas on 11/12/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import XCTest
@testable import Series

class TraktClientTests: XCTestCase {
    
    var sut: TraktClient!
    
    override func setUp() {
        super.setUp()
        sut = TraktClient()
    }
    
}

// MARK: - Token Management
extension TraktClientTests {
    func testUserDefaultsContainsTokens() {
        let defaults = UserDefaults.standard
        let accessToken = defaults.value(forKey: "accessToken") as? String
        let refreshToken = defaults.value(forKey: "refreshToken") as? String
        
        print("Access token: \(accessToken)")
        print("Refresh token: \(refreshToken)")
        
        XCTAssertNotNil(accessToken, "User Defaults doesn't contain the Access Token.")
        XCTAssertNotNil(refreshToken, "User Defaults doesn't contain the Refresh Token.")
    }
    
    func testRefreshAccessToken() {
        let expect = expectation(description: "Response received")
        var refreshSucceeded = false
        
        sut.refreshAccessToken { (_ success: Bool, _ message: String?) in
            expect.fulfill()
            refreshSucceeded = success
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(refreshSucceeded, "Could not refresh user access token")
    }
    
}

// MARK: - Requesting user data
extension TraktClientTests {
    
    func testGetUserSettings() {
        let expect = expectation(description: "Response received")
        var settingsReceived = false
        
        sut.getUserSettings { (success: Bool) in
            expect.fulfill()
            settingsReceived = success
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(settingsReceived, "Could not receive user settings")
    }
    
    func testUserDefaultsContainsUserName() {
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "username") as? String
        
        print("Username: \(username)")
        
        XCTAssertNotNil(username, "User Defaults doesn't contain the username")

    }
    
    func testGetWatchlist() {
        let expect = expectation(description: "Response received")
        var watchlistReceived = false
        
        sut.getWatchlist { (success: Bool) in
            expect.fulfill()
            watchlistReceived = success
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(watchlistReceived, "Could not receive user watchlist data")
    }
    
}
