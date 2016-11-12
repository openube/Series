//
//  JSONExtractable.swift
//  ApiClient
//
//  Created by Konstantinos Loutas on 11/11/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import Foundation

// The protocol makes sure that conforming Model Objects are able to be initialized based on information from JSON formatted data. It also declares a nested SerializationError type, which defines enumeration cases with associated values for missing or invalid properties. The JSON initializer throws an error to communicate the specific failure.

protocol JSONExtractable {
    
    init(json: [String: Any]) throws
    
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension SerializationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .missing(let string):
            return "JSON doesn't include a key named '\(string)'!"
        case .invalid(let string, _):
            return "Cannot serialize object for key \(string)!"
        }
    }
}
