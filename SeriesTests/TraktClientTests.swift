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
    
    var trakt: TraktClient!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        trakt = TraktClient()
    }
    
    func testAuthorizeApplication() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expect = expectation(description: "Response of GET request received")
        var result = false
        trakt.authorizeApplication { (success, string) in
            result = success
            print(string!)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(result, "Authorization not successful")
    }
    
}
