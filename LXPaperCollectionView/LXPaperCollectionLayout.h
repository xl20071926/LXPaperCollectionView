//
//  LXPaperCollectionLayout.h
//  LXPaperCollectionView
//
//  Created by Leexin on 16/8/9.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kEdgeInsetSize = 30.f;

@interface LXPaperCollectionLayout : UICollectionViewFlowLayout

- (instancetype)initWithItemSize:(CGSize)size;

@end
