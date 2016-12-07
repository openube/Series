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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TraktClient()
    }
    
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
