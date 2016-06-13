//
//  BBPhotoSelectionCollectionViewCell.h
//  Bobo
//
//  Created by Zhouboli on 15/8/14.
//  Copyright (c) 2015年 Zhouboli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLPhotoSelectionCollectionViewCell;
@protocol BLPhotoSelectionCollectionViewCellDelegate <NSObject>

@optional
-(void)photoSelectionCollectionViewCell:(BLPhotoSelectionCollectionViewCell *)cell didTapDeleteIcon:(UITapGestureRecognizer *)tap;

@end

@interface BLPhotoSelectionCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) BOOL hasPhoto;
@property (nonatomic) BOOL showDeleteIcon;

@property (weak, nonatomic) id <BLPhotoSelectionCollectionViewCellDelegate> delegate;

-(void)resetCell;

@end
