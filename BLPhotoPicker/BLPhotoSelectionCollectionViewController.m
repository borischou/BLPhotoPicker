//
//  BBPhotoSelectionCollectionViewController.m
//  Bobo
//
//  Created by Zhouboli on 15/8/14.
//  Copyright (c) 2015年 Zhouboli. All rights reserved.
//

#import "BLPhotoSelectionCollectionViewController.h"
#import "BLPhotoSelectionCollectionViewCell.h"

#define bWidth [UIScreen mainScreen].bounds.size.width
#define bHeight [UIScreen mainScreen].bounds.size.height

@interface BLPhotoSelectionCollectionViewController () <BLPhotoPickerCollectionViewDelegate>

@property (strong, nonatomic) BLPhotoPickerCollectionView *photoPickerCollectionView;

@end

@implementation BLPhotoSelectionCollectionViewController

#pragma mark - View Controller Life Cycle

-(void)viewDidLoad
{
    self.title = @"相册";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"相册";
}

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [self flowLayout];
    return [self initWithCollectionViewLayout:layout availabelPhotoCountForPicking:1];
}

-(instancetype)initWithMaxPhotoNumber:(NSInteger)count
{
    UICollectionViewFlowLayout *layout = [self flowLayout];
    return [self initWithCollectionViewLayout:layout availabelPhotoCountForPicking:count];
}

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
              availabelPhotoCountForPicking:(NSInteger)count
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        _photoPickerCollectionView = [[BLPhotoPickerCollectionView alloc] initWithFrame:CGRectMake(0, 0, bWidth, bHeight) collectionViewLayout:self.collectionViewLayout availablePhotoCountForPicking:count];
        self.view = _photoPickerCollectionView;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _photoPickerCollectionView.pickerDelegate = self;
        [self setupNavigationBarButtonItems];
    }
    return self;
}

#pragma mark - Helpers

-(UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((bWidth-3)/4, (bWidth-3)/4);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    return layout;
}

-(void)setupNavigationBarButtonItems
{
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonItemPressed:)];
    UIBarButtonItem *confirmButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.navigationItem.rightBarButtonItem = confirmButtonItem;
}

-(NSMutableArray *)imagesFromData:(NSMutableArray *)data
{
    NSMutableArray *images = @[].mutableCopy;
    for (NSData *imageData in data)
    {
        [images addObject:[UIImage imageWithData:imageData]];
    }
    return images;
}

#pragma mark - BLPhotoPickerCollectionViewDelegate

-(void)photoPickerCollectionView:(BLPhotoPickerCollectionView *)photoPickerCollectionView didSelectPhoto:(UIImage *)photo
{
    [self.delegate photoSelectionCollectionViewController:self didSelectPhoto:photo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIButtons

-(void)cancelButtonItemPressed:(UIBarButtonItem *)sender
{
    [self.delegate photoSelectionCollectionViewControllerDidDismiss:self];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)confirmButtonItemPressed:(UIBarButtonItem *)sender
{
    NSMutableArray *images = @[].mutableCopy;
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    NSInteger pickedNum = _photoPickerCollectionView.pickedOnes.count;
    for (int i = 0; i < pickedNum; i ++)
    {
        PHAsset *asset = _photoPickerCollectionView.pickedOnes[i];
        [manager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info)
        {
            [images addObject:imageData];
        }];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.delegate photoSelectionCollectionViewController:self didFetchPickedPhotos:[self imagesFromData:images]];
    }];
}

@end