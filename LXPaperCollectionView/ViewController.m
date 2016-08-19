//
//  ViewController.m
//  LXPaperCollectionView
//
//  Created by Leexin on 16/8/9.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extensions.h"
#import "LXPaperCollectionLayout.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

static const CGFloat kCellSpacing = 20; // cell之间的间隙

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *paperCollectionView;
@property (nonatomic, strong) UILabel *numberLabel; // 页码Label
@property (nonatomic, assign) CGFloat itemWidth; // Cell宽度
@property (nonatomic, assign) CGFloat itemHeight; // Cell高度
@property (nonatomic, assign) NSInteger allCount; // 所有Cell数量
@property (nonatomic, assign) NSInteger currentItemIndex; // 当前Cell位置

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
}

- (void)commonInit {
    
    self.allCount = 9;
    self.itemWidth = SCREEN_WIDTH - 2 * kEdgeInsetSize;
    self.itemHeight = self.itemWidth * 1.2;
    LXPaperCollectionLayout *paperLayout = [[LXPaperCollectionLayout alloc] initWithItemSize:CGSizeMake(self.itemWidth, self.itemHeight)];
    self.paperCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - self.itemHeight) / 2, SCREEN_WIDTH, self.itemHeight) collectionViewLayout:paperLayout];
    self.paperCollectionView.dataSource = self;
    self.paperCollectionView.backgroundColor = [UIColor clearColor];
    self.paperCollectionView.delegate = self;
    self.paperCollectionView.scrollEnabled = YES;
    self.paperCollectionView.pagingEnabled = NO;
    self.paperCollectionView.alwaysBounceHorizontal = YES;
    self.paperCollectionView.showsHorizontalScrollIndicator = NO;
    self.paperCollectionView.decelerationRate = 0.5; // 设置scroll更快减速
    
    [self.view addSubview:self.paperCollectionView];
    
    [self.paperCollectionView registerNib:[UINib nibWithNibName:@"PaperCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PaperCollectionCell"];
    
    [self.view addSubview:self.numberLabel];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PaperCollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1.f;
    UIImageView *imageView = [cell viewWithTag:666];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpeg",indexPath.row]];
    [cell addSubview:imageView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Click picture index : %ld",indexPath.row);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger count = scrollView.contentOffset.x / (self.itemWidth + kCellSpacing) + 1;
    if (count == 0) {
        count = 1;
    }
    self.currentItemIndex = count - 1;
    [self updateNumberLabelWithCurrentIndex:count allCount:self.allCount];
}

// 仿系统的pageEnable 的效果
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView == self.paperCollectionView) {
        if (0 == velocity.x) {
            return;
        }
        
        CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
        //        CGFloat targetIndex = round(targetX / (kCellWidth + kCellSpacing));
        CGFloat targetIndex;
        if (velocity.x > 0) {
            targetIndex = ceil(targetX / (self.itemWidth + kCellSpacing));
        } else {
            targetIndex = floor(targetX / (self.itemWidth + kCellSpacing));
        }
        if (targetIndex < 0) {
            targetIndex = 0;
        }
        if (targetIndex > self.allCount - 1) {
            targetIndex = self.allCount - 1;
        }
        if (targetIndex == self.allCount - 1) {
            targetContentOffset->x = targetIndex * (self.itemWidth + kCellSpacing);
        } else {
            targetContentOffset->x = targetIndex * (self.itemWidth + kCellSpacing);
        }
        self.currentItemIndex = targetIndex;
        [self updateNumberLabelWithCurrentIndex:targetIndex + 1 allCount:self.allCount];
    }
}

#pragma mark - Private Method

- (void)updateNumberLabelWithCurrentIndex:(NSInteger)currentIndex allCount:(NSInteger)allCount { // 更新顶部页码Label
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)currentIndex]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0, str.length)];
    NSAttributedString *allStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld",(long)allCount]];
    [str appendAttributedString:allStr];
    
    self.numberLabel.attributedText = str;
}

#pragma mark - Getter

- (UILabel *)numberLabel {
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21.f, SCREEN_WIDTH, 36.f)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:16.0f];
        _numberLabel.textColor = [UIColor darkGrayColor];
        _numberLabel.text = @"0/0";
    }
    return _numberLabel;
}

@end
