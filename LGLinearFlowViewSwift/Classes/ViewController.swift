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
    
    private var collectionViewLayout: LGHorizontalLinearFlowLayout!
    private var dataSource: Array<String>!
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var previousButton: UIButton!
    @IBOutlet private var pageControl: UIPageControl!
    
    private var animationsCount = 0
    
    private var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    private var contentOffset: CGFloat {
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
    
    private func configureDataSource() {
        self.dataSource = Array()
        for index in 1...10 {
            self.dataSource.append("Page \(index)")
        }
    }
    
    private func configureCollectionView() {
        self.collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSizeMake(180, 180), minimumLineSpacing: 0)
    }
    
    private func configurePageControl() {
        self.pageControl.numberOfPages = self.dataSource.count
    }
    
    private func configureButtons() {
        self.nextButton.enabled = self.dataSource.count > 0 && self.pageControl.currentPage < self.dataSource.count - 1
        self.previousButton.enabled = self.pageControl.currentPage > 0
    }
    
    // MARK: Actions
    
    @IBAction private func pageControlValueChanged(sender: AnyObject) {
        self.scrollToPage(self.pageControl.currentPage, animated: true)
    }
    
    @IBAction private func nextButtonAction(sender: AnyObject) {
        self.scrollToPage(self.pageControl.currentPage + 1, animated: true)
    }

    @IBAction private func previousButtonAction(sender: AnyObject) {
        self.scrollToPage(self.pageControl.currentPage - 1, animated: true)
    }

    private func scrollToPage(page: Int, animated: Bool) {
        self.collectionView.userInteractionEnabled = false
        self.animationsCount++
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
        if collectionView.dragging || collectionView.decelerating || collectionView.tracking {
            return
        }
        
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
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if --self.animationsCount == 0 {
            self.collectionView.userInteractionEnabled = true
        }
    }
    
}
