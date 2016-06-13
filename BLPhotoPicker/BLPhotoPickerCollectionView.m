//
//  BBPhotoPickerCollectionView.m
//  Bobo
//
//  Created by Zhouboli on 15/8/28.
//  Copyright (c) 2015年 Zhouboli. All rights reserved.
//

#import "BLPhotoPickerCollectionView.h"
#import "BLPhotoSelectionCollectionViewCell.h"

static const CGFloat scale = 1.0;

@interface BLPhotoPickerCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) PHCachingImageManager *manager;
@property (nonatomic) NSInteger maxCount;

@end

@implementation BLPhotoPickerCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        _layout = (UICollectionViewFlowLayout *)layout;
        [self preparePhotoDataWithLayout:(UICollectionViewFlowLayout *)layout];
        [self registerClass:[BLPhotoSelectionCollectionViewCell class] forCellWithReuseIdentifier:@"reuseCell"];
        _pickedOnes = @[].mutableCopy;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout availablePhotoCountForPicking:(NSInteger)count
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        _maxCount = count > 9 ? 9 : count;
        _layout = (UICollectionViewFlowLayout *)layout;
        [self preparePhotoDataWithLayout:(UICollectionViewFlowLayout *)layout];
        [self registerClass:[BLPhotoSelectionCollectionViewCell class] forCellWithReuseIdentifier:@"reuseCell"];
        _pickedOnes = @[].mutableCopy;
        [self reloadData];
    }
    return self;
}

-(void)preparePhotoDataWithLayout:(UICollectionViewFlowLayout *)layout
{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop)
     {
        NSLog(@"ALBUM NAME: %@", collection.localizedTitle);
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"All Photos"] || [collection.localizedTitle isEqualToString:@"相机胶卷"])
        {
            PHFetchOptions *options  = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
            _fetchedPhotos = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            
            _pickedStatuses = nil;
            _pickedStatuses = @[].mutableCopy;
            
            for (int i = 0; i < _fetchedPhotos.count; i ++)
            {
                [_pickedStatuses addObject:@"0"];
            }
            
            if (!_manager)
            {
                _manager = [[PHCachingImageManager alloc] init];
            }
            
            NSRange range = NSMakeRange(0, _fetchedPhotos.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            NSArray *assets = [_fetchedPhotos objectsAtIndexes:set];
            
            CGSize targetSize = CGSizeMake(_layout.itemSize.width*scale, _layout.itemSize.height*scale);
            
            [_manager startCachingImagesForAssets:assets targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil];
        }
    }];
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

#pragma mark - UICollectionViewDelegate & data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _fetchedPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BLPhotoSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCell" forIndexPath:indexPath];
    if ([[_pickedStatuses objectAtIndex:indexPath.item] isEqualToString:@"0"])
    {
        cell.layer.borderWidth = 0.0;
    }
    if ([[_pickedStatuses objectAtIndex:indexPath.item] isEqualToString:@"1"])
    {
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = UIColor.greenColor.CGColor;
    }
    [cell resetCell];
    CGSize targetSize = CGSizeMake(_layout.itemSize.width*scale, _layout.itemSize.height*scale);
    PHAsset *asset = _fetchedPhotos[indexPath.item];
    [_manager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info)
    {
        cell.hasPhoto = YES;
        cell.showDeleteIcon = NO;
        cell.image = result;
        [cell setNeedsLayout];
    }];
    if (indexPath.item == _fetchedPhotos.count)
    {
        [_manager stopCachingImagesForAllAssets];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BLPhotoSelectionCollectionViewCell *cell = (BLPhotoSelectionCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (_maxCount == 1)
    {
        __block UIImage *selectedImage = nil;
        PHImageManager *manager = [PHImageManager defaultManager];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        PHAsset *asset = _fetchedPhotos[indexPath.item];
        [manager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info)
        {
            selectedImage = [UIImage imageWithData:imageData];
        }];
        [self.pickerDelegate photoPickerCollectionView:self didSelectPhoto:selectedImage];
        return;
    }
    
    if ([[_pickedStatuses objectAtIndex:indexPath.item] isEqualToString:@"1"])
    {
        cell.layer.borderWidth = 0.0;
        if (_pickedOnes.count)
        {
            [_pickedStatuses setObject:@"0" atIndexedSubscript:indexPath.item];
            [_pickedOnes removeObject:_fetchedPhotos[indexPath.item]];
        }
    }
    else
    {
        if (_pickedOnes.count == _maxCount)
        {
            return;
        }
        [_pickedOnes addObject:_fetchedPhotos[indexPath.item]];
        [_pickedStatuses setObject:@"1" atIndexedSubscript:indexPath.item];
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = [UIColor blueColor].CGColor;
    }
}

@end