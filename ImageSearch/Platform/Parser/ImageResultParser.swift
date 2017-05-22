//
//  ImageResultParser.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import Foundation

class ImageResultParser: NSObject
{
    // parse single image result
    func parse(data: Any, error: NSErrorPointer) -> ImageResult?
    {
        guard let dict = data as? NSDictionary else
        {
            error?.pointee = NSError.standardParseError
            return nil
        }
        
        return ImageResult(dict: dict)
    }
    
    // parse list
    func parseList(data: Any?, error: NSErrorPointer) -> Array<ImageResult>
    {
        var imageResultsList = Array<ImageResult>()
        
        // return empty list if cannot parse
        guard let list = data as? Array<NSDictionary> else
        {
            error?.pointee = NSError.standardParseError
            return imageResultsList
        }
        
        for dict in list
        {
            // add if can be initialized
            if let imageResult = ImageResult(dict: dict)
            { imageResultsList.append(imageResult) }
        }
        
        return imageResultsList
    }
}
