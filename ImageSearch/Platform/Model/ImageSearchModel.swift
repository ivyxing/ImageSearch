//
//  ImageSearchModel.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import Foundation

class ImageSearchModel: NSObject
{
    class var defaultPageSize: Int
    { return 20 }
    
    let dataKey = "value"
    
    public func getImageResults(searchQuery: String,
                                perPage: Int = ImageSearchModel.defaultPageSize,
                                successBlock: ((_ imageResults: Array<ImageResult>, _ isEndOfList: Bool)-> Void)? = nil,
                                failureBlock: ((_ error: NSError) -> Void)? = nil)
    {
        ImageResultsNetworkRequest.imageSearchRequest(
            searchQuery: searchQuery,
            perPage: perPage,
            successBlock:
            { (data, response) in
                guard let foundData = data as? NSDictionary,
                    let values = foundData[self.dataKey] else
                {
                    DispatchQueue.main.async
                        { successBlock?([], true) }
                    
                    return
                }
                
                // parse list of image results
                let parser = ImageResultParser()
                var error: NSError? = nil
                let parsedList = parser.parseList(data: values, error: &error)
                
                DispatchQueue.main.async
                    {
                        // check for error, if not then return list
                        if let foundError = error
                        { failureBlock?(foundError) }
                        else
                        { successBlock?(parsedList, true) }
                    }
                
            },
            failureBlock:
            { (error) in
                DispatchQueue.main.async
                    { failureBlock?(error) }
            }
        )
    }
    
}
