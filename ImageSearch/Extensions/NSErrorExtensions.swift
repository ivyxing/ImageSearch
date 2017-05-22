//
//  NSErrorExtensions.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import Foundation

extension NSError
{
    // parsing error
    class var standardParseError: NSError
    {
        struct Singleton
        { static let instance = NSError(domain: "Could not parse the given data", code: 0, userInfo: nil) }
        
        return Singleton.instance
    }
    
    // networking error
    class var standardNetworkError: NSError
    {
        struct Singleton
        { static let instance = NSError(domain: "Could not retrieve data", code: 0, userInfo: nil) }
        
        return Singleton.instance
    }
}
