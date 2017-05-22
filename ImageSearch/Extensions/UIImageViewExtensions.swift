//
//  UIImageViewExtensions.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import UIKit

extension UIImageView
{
    /** A shared dictionary of cached images which have been previously loaded from a url */
    class func getCachedImages() -> NSCache<AnyObject, AnyObject>
    {
        struct Singleton
        { static var sharedCache = NSCache<AnyObject, AnyObject>() }
        
        return Singleton.sharedCache
    }
    
    /** Loads the image at the given url into this uiimageview, while the image is loading, the placeholder image is set to the imageview's image property */
    func loadImage(fromUrl imageUrl: URL?, withPlaceholder placeholder: UIImage?)
    {
        // initially set the image to placeholder
        self.image = placeholder
        
        guard let url = imageUrl else
        { return }
        
        // get the image cache
        let imageCache = UIImageView.getCachedImages()
        
        // first check the image cache, if the image is cached, dont load the url
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage
        {
            self.image = cachedImage
        }
        else
        {
            // dispatch to background thread for loading data
            DispatchQueue.global(qos: .background).async
                { () -> Void in
                    guard let imageData = try? Data(contentsOf: url) else
                    { return }
                    
                    // back to main queue to set image
                    DispatchQueue.main.async
                        {[weak self] () -> Void in
                            // attempt to create the image
                            guard let loadedImage = UIImage(data: imageData) else
                            { return }
                            
                            // cache the image if it loaded
                            imageCache.setObject(loadedImage, forKey: url as AnyObject)
                            
                            // update the image
                            self?.image = loadedImage
                    }
            }
        }
    }
}



