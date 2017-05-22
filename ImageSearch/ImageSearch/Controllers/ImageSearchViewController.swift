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
    @IBOutlet weak var imageSearchBar: UISearchBar?
    @IBOutlet weak var collectionView: UICollectionView?
    
    // data
    var imageResults = Array<ImageResult>()
    var isLoadingData = false
    // paging
    var hasMoreResults = true
    var perPage: Int = 20 // count per page
    var pageOffset: Int = 0   // current count position, incremented by perPage in every request
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.localizeStrings()
        self.registerCells()
        self.addObservers()
    }
    
    deinit
    {
        self.removeObservers()
    }
}

//MARK: - Data Loading -
extension ImageSearchViewController
{
    fileprivate func searchImages(query: String, shouldReset: Bool = false)
    {
        // one request at a time
        guard self.isLoadingData == false else
        { return }
        
        // make sure query is valid
        guard query.characters.count > 0 else
        { return }
        
        if shouldReset
        { self.resetPaging() }
        
        self.isLoadingData = true
        
        // make api call
        let model = ImageSearchModel()
        model.getImageResults(
            searchQuery: query,
            perPage: self.perPage,
            offset: self.pageOffset,
            successBlock:
            {[weak self] (imageResults, isEndOfList) in
                guard let weakself = self else
                { return }
                
                // append data and update paging
                weakself.imageResults += imageResults
                weakself.hasMoreResults = !isEndOfList
                weakself.pageOffset += weakself.perPage
                
                weakself.isLoadingData = false
                weakself.collectionView?.reloadData()
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

//MARK: - UICollectionViewDelegate -
extension ImageSearchViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let isLastRow = (indexPath.row == self.imageResults.count - 1)
        
        // at bottom of page, see if we need to fetch more images
        if let text = self.imageSearchBar?.text,
            text.characters.count > 0,
            isLastRow,
            self.hasMoreResults,
            !self.isLoadingData
        {
            self.searchImages(query: text)
        }
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
    // Localize strings
    fileprivate func localizeStrings()
    {
        self.imageSearchBar?.placeholder = NSLocalizedString("Search image", comment: "Search image")
    }
    
    // Registers cells for collection view
    fileprivate func registerCells()
    {
        guard let collectionView = self.collectionView else
        { return }
        
        ImageDisplayCollectionViewCell.regiserCell(forCollectionView: collectionView)
    }
}

//MARK: - Observers -
extension ImageSearchViewController
{
    
    fileprivate func addObservers()
    {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNotify(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideNotify(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    fileprivate func removeObservers()
    {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }

}

//MARK: - Helper Functions: Keyboard -
extension ImageSearchViewController
{
    // Adjusts collection view up when keyboard shows
    func keyboardWillShowNotify(_ notification: Notification)
    {
        guard let collectionView = self.collectionView,
            let userInfo = (notification as NSNotification).userInfo else
        { return }
        
        if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        { self._adjustCollectionViewInsets(collectionView: collectionView, toHeight: keyboardFrame.size.height) }
    }
    
    // Adjusts collection view down when keyboard hides
    func keyboardWillHideNotify(_ notification: Notification)
    {
        guard let collectionView = self.collectionView else
        { return }
        
        self._adjustCollectionViewInsets(collectionView: collectionView, toHeight: 0.0)
    }
    
    // Helper function to adjust view
    fileprivate func _adjustCollectionViewInsets(collectionView: UICollectionView, toHeight height: CGFloat)
    {
        var insets = collectionView.contentInset
        insets.bottom = height
        collectionView.contentInset = insets
    }
}

//MARK: - Helper Functions: Utilities -
extension ImageSearchViewController
{
    // Resets the paging
    fileprivate func resetPaging()
    {
        self.imageResults = Array<ImageResult>()
        self.hasMoreResults = true
        self.pageOffset = 0
    }
}

//MARK: - UISearchBarDelegate -
extension ImageSearchViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        guard let text = self.imageSearchBar?.text,
            text.characters.count > 0 else
        { return }
        
        self.searchImages(query: text)
    }
}

