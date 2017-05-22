//
//  ImageDisplayCollectionViewCell.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import UIKit

class ImageDisplayCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var displayImageView: UIImageView?
 
    // Sets up the cell with the specified item
    func collectionView(collectionView: UICollectionView, setupCellwithAny any: Any?, indexPath: IndexPath)
    {
        guard let imageResult = any as? ImageResult,
            let url = imageResult.contentUrl else
        {
            self.displayImageView?.image = nil
            return
        }
     
        // set image view's image
        self.displayImageView?.loadImage(fromUrl: url, withPlaceholder: nil)
    }
}

//MARK: - Helper Functions: Initialization -
extension ImageDisplayCollectionViewCell
{
    // Class name for cell
    class func cellIdentifier() -> String
    {
        return String(describing: self)
    }
    
    // Registers the cell for collection
    class func regiserCell(forCollectionView collectionView: UICollectionView)
    {
        let identifier = self.cellIdentifier()
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}
