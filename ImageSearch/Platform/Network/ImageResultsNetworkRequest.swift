//
//  ImageResultsNetworkRequest.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import Foundation

// header fields
fileprivate struct ImageResultsNetworkRequestHeaderField
{
    static let searchApiKey = "Ocp-Apim-Subscription-Key"
}

// request parameters
fileprivate struct ImageResultsNetworkRequestParameter
{
    static let searchQuery = "q"
    static let perPage = "count"
}


class ImageResultsNetworkRequest: NetworkRequest
{
    static let searchApiKey = "5d1a5c8c558d4ed3a6c79e528016b768"
    
    override class var endpoint: String
    { return "https://api.cognitive.microsoft.com/bing/v7.0/images/search" }
    
    class func imageSearchRequest(searchQuery: String,
                                  perPage: Int,
                                  successBlock: ((_ jsonObject: Any?, _ response: URLResponse?)-> Void)? = nil,
                                  failureBlock: ((_ error: NSError) -> Void)? = nil)
    {
        // parameters
        self.params[ImageResultsNetworkRequestParameter.searchQuery] = searchQuery as AnyObject
        self.params[ImageResultsNetworkRequestParameter.perPage] = perPage as AnyObject
        
        // url
        guard let url = URL(string: self.getFullPath()) else
        {
            failureBlock?(NSError.standardNetworkError)
            return
        }
        
        // headers
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(self.searchApiKey, forHTTPHeaderField: ImageResultsNetworkRequestHeaderField.searchApiKey)
        
        // url session
        let task = URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            // check data is returned
            guard let foundData = data else
            {
                failureBlock?(NSError.standardNetworkError)
                return
            }
            
            // check for error
            if let foundError = error as? NSError
            {
                failureBlock?(foundError)
            }
            else
            {
                // attempt to get json data
                do
                {
                    let responseData = try JSONSerialization.jsonObject(with: foundData, options: .allowFragments)
                    successBlock?(responseData, response)
                    
                }
                catch let parseError as NSError
                {
                    failureBlock?(parseError)
                }
            }
        }
        task.resume()
    }
}


