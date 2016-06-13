//
//  BBPhotoPickerCollectionView.h
//  Bobo
//
//  Created by Zhouboli on 15/8/28.
//  Copyright (c) 2015年 Zhouboli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class BLPhotoPickerCollectionView;
@protocol BLPhotoPickerCollectionViewDelegate <NSObject>

-(void)photoPickerCollectionView:(BLPhotoPickerCollectionView *)photoPickerCollectionView didSelectPhoto:(UIImage *)photo;

@end

@interface BLPhotoPickerCollectionView : UICollectionView

@property (weak, nonatomic) id <BLPhotoPickerCollectionViewDelegate> pickerDelegate;

@property (copy, nonatomic) NSMutableArray *pickedOnes;
@property (copy, nonatomic) NSMutableArray *pickedStatuses;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) PHFetchResult *fetchedPhotos;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout availablePhotoCountForPicking:(NSInteger)count;

@end
