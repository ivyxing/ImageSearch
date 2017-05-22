//
//  NetworkRequest.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import Foundation

class NetworkRequest: NSObject
{
    // subclasses override
    class var endpoint: String
        { return "" }
    
    static var params = Dictionary<String, AnyObject>()
}

extension NetworkRequest
{
    // append parameters to the endpoint
    class func getFullPath() -> String
    {
        let paramString = self.convertParameters()
        var fullPath = self.endpoint
        
        if paramString.characters.count > 0
        { fullPath += "/?\(paramString)" }
        
        return fullPath
    }
    
    // append parameter dictionary to the request in the correct format. e.g.: .../images/search?q="cat"&count=20
    class func convertParameters() -> String
    {
        var parts = Array<String>()
        for (key, val): (String, AnyObject) in self.params
        {
            if let jsonKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
                let jsonVal = "\(val)".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
            { parts.append("\(jsonKey)=\(jsonVal)") }
        }
        let paramString = parts.joined(separator: "&")
        
        return paramString
    }
}
