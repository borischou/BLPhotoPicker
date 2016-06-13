//
//  ViewController.m
//  BLPhotoPicker
//
//  Created by Zhouboli on 16/6/13.
//  Copyright © 2016年 boris. All rights reserved.
//

#import "ViewController.h"
#import "BLPhotoSelectionCollectionViewController.h"
#import "BLImageViewer.h"

@interface ViewController () <BLPhotoSelectionCollectionViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"One Photo" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *buttonMore = [[UIButton alloc] initWithFrame:CGRectMake(100, 100+50+100, 100, 50)];
    buttonMore.backgroundColor = [UIColor redColor];
    [buttonMore setTitle:@"More Photo" forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(buttonMorePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonMore];
}

-(void)buttonPressed:(UIButton *)sender
{
    BLPhotoSelectionCollectionViewController *pscvc = [[BLPhotoSelectionCollectionViewController alloc] init];
    pscvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:pscvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)buttonMorePressed:(UIButton *)sender
{
    BLPhotoSelectionCollectionViewController *pscvc = [[BLPhotoSelectionCollectionViewController alloc] initWithMaxPhotoNumber:9];
    pscvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:pscvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - BLPhotoSelectionCollectionViewControllerDelegate

-(void)photoSelectionCollectionViewController:(BLPhotoSelectionCollectionViewController *)viewController didSelectPhoto:(UIImage *)photo
{
    BLImageViewer *viewer = [[BLImageViewer alloc] initWithFrame:[UIScreen mainScreen].bounds images:@[photo] index:0];
    [viewer present];
}

-(void)photoSelectionCollectionViewController:(BLPhotoSelectionCollectionViewController *)viewController didFetchPickedPhotos:(NSMutableArray *)photos
{
    BLImageViewer *viewer = [[BLImageViewer alloc] initWithFrame:[UIScreen mainScreen].bounds images:photos index:0];
    [viewer present];
}

-(void)photoSelectionCollectionViewControllerDidDismiss:(BLPhotoSelectionCollectionViewController *)viewController
{
    
}

@end
