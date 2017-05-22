//
//  ImageResult.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import Foundation

struct ImageResultAPIKey
{
    static let ID = "id"
    static let name = "name"
    static let contentUrl = "contentUrl"
}

class ImageResult: NSObject
{
    var ID: String = ""
    var name: String = ""
    var contentUrl: URL?
    
    public required init?(dict: NSDictionary)
    {
        super.init()
        
        if let ID = dict[ImageResultAPIKey.ID ] as? String
        { self.ID = ID }
        
        if let name = dict[ImageResultAPIKey.name] as? String
        { self.name = name }
        
        if let urlString = dict[ImageResultAPIKey.contentUrl] as? String,
            let url = URL(string: urlString)
        { self.contentUrl = url }
    }
}

//MARK: - Equality -
extension ImageResult
{
    open override func isEqual(_ object: Any?) -> Bool
    {
        guard let imageResult = object as? ImageResult else
        { return false }
        
        return self.isEqualToImageResult(imageResult: imageResult)
    }
    
    public func isEqualToImageResult(imageResult: ImageResult) -> Bool
    {
        return self.ID == imageResult.ID
    }
}
