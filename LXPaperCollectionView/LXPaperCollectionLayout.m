//
//  LXPaperCollectionLayout.m
//  LXPaperCollectionView
//
//  Created by Leexin on 16/8/9.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXPaperCollectionLayout.h"

#define SCREEN_KEY_WINDOW [UIApplication sharedApplication].keyWindow

static const CGFloat kZoomDistance = 20.f; // 缩放值

@interface LXPaperCollectionLayout ()

@property (nonatomic, assign) CGFloat itemSizeHeight;
@property (nonatomic, assign) CGFloat itemSizeWidth;
@property (nonatomic, assign) CGFloat activeDistance;

@end

@implementation LXPaperCollectionLayout

- (instancetype)initWithItemSize:(CGSize)size {
    
    self = [super init];
    if (self) {
        self.itemSizeHeight = size.height - kZoomDistance;
        self.itemSizeWidth = size.width;
        self.activeDistance = self.itemSizeWidth / 2;
        self.itemSize = CGSizeMake(self.itemSizeWidth, self.itemSizeHeight);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, kEdgeInsetSize, 0, kEdgeInsetSize);
        self.minimumLineSpacing = 20;
    }
    return self;
}

// 当边界发生改变时，是否应该刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

// 设置所有的Cell的布局属性
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / self.activeDistance;
            if (ABS(distance) < self.activeDistance) { // 滑动到指定范围对Item的尺寸逐渐放大
                attributes.size = CGSizeMake(self.itemSizeWidth + kZoomDistance * (1 - ABS(normalizedDistance)), self.itemSizeHeight + kZoomDistance * (1 - ABS(normalizedDistance)));
            }
        }
    }
    return array;
}

// 自动对齐到网格
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}



@end
