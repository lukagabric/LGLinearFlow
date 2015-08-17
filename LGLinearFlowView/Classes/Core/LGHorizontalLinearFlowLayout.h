//
//  Created by Luka Gabric on 15/08/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGHorizontalLinearFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat scalingOffset; //default is 200; for offsets >= scalingOffset scale factor is minimumScaleFactor
@property (assign, nonatomic) CGFloat minimumScaleFactor; //default is 0.7
@property (assign, nonatomic) BOOL scaleItems; //default is YES

+ (LGHorizontalLinearFlowLayout *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                                            itemSize:(CGSize)itemSize
                                                  minimumLineSpacing:(CGFloat)minimumLineSpacing;
@end
