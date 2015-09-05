//
//  ViewController.swift
//  LGLinearFlowViewSwift
//
//  Created by Luka Gabric on 16/08/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Vars
    
    var collectionViewLayout: LGHorizontalLinearFlowLayout!
    var dataSource: Array<String>!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    
    var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureDataSource()
        self.configureCollectionView()
        self.configurePageControl()
        self.configureButtons()
    }
    
    // MARK: Configuration
    
    func configureDataSource() {
        self.dataSource = Array()
        for index in 1...10 {
            self.dataSource.append("Page \(index)")
        }
    }
    
    func configureCollectionView() {
        self.collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSizeMake(180, 180), minimumLineSpacing: 0)
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = self.dataSource.count
    }
    
    func configureButtons() {
        self.nextButton.enabled = self.dataSource.count > 0 && self.pageControl.currentPage < self.dataSource.count - 1
        self.previousButton.enabled = self.pageControl.currentPage > 0
    }
    
    // MARK: Actions
    
    @IBAction func longPress() {
        if self.longPressRecognizer.state != .Ended ||
            self.collectionView.dragging ||
            self.collectionView.decelerating ||
            self.collectionView.tracking {
                return
        }
        
        self.scrollToPage(self.pageControl.currentPage, animated: true)
    }
    
    @IBAction func pageControlValueChanged(sender: AnyObject) {
        self.scrollToPage(self.pageControl.currentPage, animated: true)
    }
    
    @IBAction func nextButtonAction(sender: AnyObject) {
        self.scrollToPage(self.pageControl.currentPage + 1, animated: true)
    }

    @IBAction func previousButtonAction(sender: AnyObject) {
        self.scrollToPage(self.pageControl.currentPage - 1, animated: true)
    }

    func scrollToPage(page: Int, animated: Bool) {
        let pageOffset = CGFloat(page) * self.pageWidth - self.collectionView.contentInset.left
        self.collectionView.setContentOffset(CGPointMake(pageOffset, 0), animated: true)
        self.pageControl.currentPage = page
        self.configureButtons()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        collectionViewCell.pageLabel.text = self.dataSource[indexPath.row]
        return collectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.dragging || collectionView.decelerating || collectionView.tracking { return }
        
        let selectedPage = indexPath.row
        
        if selectedPage == self.pageControl.currentPage {
            NSLog("Did select center item")
        }
        else {
            self.scrollToPage(selectedPage, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(self.contentOffset / self.pageWidth)
        self.configureButtons()
    }
    
}
