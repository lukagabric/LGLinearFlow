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
        self.configureViewForPageControlValueChange()
    }
    
    @IBAction private func nextButtonAction(sender: AnyObject) {
        self.pageControl.currentPage += 1;
        self.configureViewForPageControlValueChange()
    }

    @IBAction private func previousButtonAction(sender: AnyObject) {
        self.pageControl.currentPage -= 1;
        self.configureViewForPageControlValueChange()
    }

    private func configureViewForPageControlValueChange() {
        let pageOffset = self.pageWidth * CGFloat(self.pageControl.currentPage) - self.collectionView.contentInset.left
        self.collectionView .setContentOffset(CGPointMake(pageOffset, 0), animated: true)
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(self.contentOffset / self.pageWidth)
        self.configureButtons()
    }
    
}
