//
//  BBPhotoSelectionCollectionViewController.h
//  Bobo
//
//  Created by Zhouboli on 15/8/14.
//  Copyright (c) 2015年 Zhouboli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLPhotoPickerCollectionView.h"

@class BLPhotoSelectionCollectionViewController;
@protocol BLPhotoSelectionCollectionViewControllerDelegate <NSObject>

@optional
-(void)photoSelectionCollectionViewController:(BLPhotoSelectionCollectionViewController *)viewController
                         didFetchPickedPhotos:(NSMutableArray *)photos;
-(void)photoSelectionCollectionViewControllerDidDismiss:(BLPhotoSelectionCollectionViewController *)viewController;
-(void)photoSelectionCollectionViewController:(BLPhotoSelectionCollectionViewController *)viewController
                               didSelectPhoto:(UIImage *)photo;

@end

@interface BLPhotoSelectionCollectionViewController : UICollectionViewController

@property (weak, nonatomic) id <BLPhotoSelectionCollectionViewControllerDelegate> delegate;

-(instancetype)initWithMaxPhotoNumber:(NSInteger)count;

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
              availabelPhotoCountForPicking:(NSInteger)count;

@end
