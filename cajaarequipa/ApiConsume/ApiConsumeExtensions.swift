//
//  ApiConsumeExtensions.swift
//
//  Created by Raul Quispe on 12/11/16.
//  Copyright © 2016 Raul Quispe. All rights reserved.
//

import UIKit

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        
        var parametersString = ""
        for (key, value) in self {
            if let key = key as? String,
                let value = value as? String {
                parametersString = parametersString + key + "=" + value + "&"
            }
        }
        parametersString = parametersString.substring(to: parametersString.index(before: parametersString.endIndex))
        return parametersString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
}
extension URLRequest {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    mutating func addHeaders(headers:Dictionary< String, String>)  {
        
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }

    }
    
}
