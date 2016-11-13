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
    
}
