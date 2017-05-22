//
//  ImageSearchViewController.swift
//  ImageSearch
//
//  Created by Ivy Xing on 5/21/17.
//  Copyright © 2017 Ivy Xing. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView?
    
    // data
    var imageResults = Array<ImageResult>()
    // paging
    var hasMorePages = true
    var page: Int = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.registerCells()
    }
}

//MARK: - Data Loading -
extension ImageSearchViewController
{
    fileprivate func searchImages(query: String, shouldReset: Bool = false)
    {
        // fetch from beginning
        if shouldReset
        { self.resetPaging() }
        
        // make sure query is valid
        guard query.characters.count > 0 else
        { return }
        
        // make api call
        let model = ImageSearchModel()
        model.getImageResults(
            searchQuery: query,
            successBlock:
            {[weak self] (imageResults, isEndOfList) in
                self?.imageResults += imageResults
                self?.hasMorePages = !isEndOfList
                self?.page += 1
                self?.collectionView?.reloadData()
            },
            failureBlock:
            {(error) in
                // TODO: error handling - alert
                NSLog("Failed with error \(error.localizedDescription)")
            }
        )
    }
    
}

//MARK: - UICollectionViewDataSource -
extension ImageSearchViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imageResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // dequeue the cell
        let identifier = ImageDisplayCollectionViewCell.cellIdentifier()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ImageDisplayCollectionViewCell else
        { return UICollectionViewCell() }
        
        // set up the image
        if indexPath.item < self.imageResults.count
        {
            let imageResult = self.imageResults[indexPath.item]
            cell.collectionView(collectionView: collectionView, setupCellwithAny: imageResult, indexPath: indexPath)
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout -
extension ImageSearchViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // 3 images per row
        let offset: CGFloat = 3.0
        let size = (collectionView.frame.width / 2) - offset
        return CGSize(width: size, height: size)
    }
}

//MARK: - Helper Functions: Initialization -
extension ImageSearchViewController
{
    // Registers cells for collection view
    fileprivate func registerCells()
    {
        guard let collectionView = self.collectionView else
        { return }
        
        ImageDisplayCollectionViewCell.regiserCell(forCollectionView: collectionView)
    }
}

//MARK: - Helper Functions: Utilities -
extension ImageSearchViewController
{
    fileprivate func resetPaging()
    {
        self.imageResults.removeAll()
        self.hasMorePages = true
        self.page = 1
    }
}

//MARK: - UISearchBarDelegate -
extension ImageSearchViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchImages(query: searchText, shouldReset: true)
        self.collectionView?.reloadData()
    }
}

