//
//  ImageListView.m
//  PPTToImage
//
//  Created by 刘川 on 2019/7/19.
//  Copyright © 2019 alex. All rights reserved.
//

#import "ImageListView.h"

@interface ImageListView ()<UICollectionViewDataSource>

@end

static NSString *iconfunCellId = @"ImageListView";

@implementation ImageListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:iconfunCellId];
        self.pagingEnabled = YES;
        self.dataSource = self;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma -mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iconfunCellId forIndexPath:indexPath];;
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:self.images[indexPath.item]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = cell.bounds;
    [cell.contentView addSubview:imageView];
    return cell;
}
@end
