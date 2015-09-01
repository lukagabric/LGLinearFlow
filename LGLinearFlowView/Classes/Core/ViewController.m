//
//  Created by Luka Gabric on 15/08/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

#import "ViewController.h"
#import "LGHorizontalLinearFlowLayout.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) LGHorizontalLinearFlowLayout *collectionViewLayout;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (readonly, nonatomic) CGFloat pageWidth;
@property (readonly, nonatomic) CGFloat contentOffset;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureDataSource];
    [self configureCollectionView];
    [self configurePageControl];
    [self configureButtons];
}

#pragma mark - Configuration

- (void)configureCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    self.collectionViewLayout = [LGHorizontalLinearFlowLayout layoutConfiguredWithCollectionView:self.collectionView
                                                                                        itemSize:CGSizeMake(180, 180)
                                                                              minimumLineSpacing:0];
}

- (void)configureDataSource {
    NSMutableArray *datasource = [NSMutableArray new];
    for (NSUInteger i = 0; i < 10; i++) {
        [datasource addObject:[NSString stringWithFormat:@"Page %@", @(i)]];
    }
    self.dataSource = datasource;
}

- (void)configurePageControl {
    self.pageControl.numberOfPages = self.dataSource.count;
}

- (void)configureButtons {
    self.nextButton.enabled = self.dataSource.count > 0 && self.pageControl.currentPage < self.dataSource.count - 1;
    self.previousButton.enabled = self.pageControl.currentPage > 0;
}

#pragma mark - Actions

- (IBAction)pageControlValueChanged:(id)sender {
    [self configureViewForPageControlValueChange];
}

- (IBAction)nextButtonAction:(id)sender {
    self.pageControl.currentPage += 1;
    [self configureViewForPageControlValueChange];
}

- (IBAction)previousButtonAction:(id)sender {
    self.pageControl.currentPage -= 1;
    [self configureViewForPageControlValueChange];
}

- (void)configureViewForPageControlValueChange {
    CGFloat pageOffset = self.pageControl.currentPage * self.pageWidth - self.collectionView.contentInset.left;
    [self.collectionView setContentOffset:CGPointMake(pageOffset, 0) animated:YES];
    
    [self configureButtons];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell =
    (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell"
                                                                    forIndexPath:indexPath];
    cell.pageLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.contentOffset / self.pageWidth;
    [self configureButtons];
}

#pragma mark - Convenience

- (CGFloat)pageWidth {
    return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing;
}

- (CGFloat)contentOffset {
    return self.collectionView.contentOffset.x + self.collectionView.contentInset.left;
}

#pragma mark -

@end
