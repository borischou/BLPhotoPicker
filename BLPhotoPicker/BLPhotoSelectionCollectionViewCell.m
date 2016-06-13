//
//  BBPhotoSelectionCollectionViewCell.m
//  Bobo
//
//  Created by Zhouboli on 15/8/14.
//  Copyright (c) 2015年 Zhouboli. All rights reserved.
//

#import "BLPhotoSelectionCollectionViewCell.h"

static const CGFloat iconLength = 25;

@interface BLPhotoSelectionCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *deleteIcon;

@end

@implementation BLPhotoSelectionCollectionViewCell

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (self.highlighted)
    {
        self.contentView.alpha = 0.5;
    }
    else
    {
        self.contentView.alpha = 1.0;
    }
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupImageView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupImageView];
    }
    return self;
}

-(void)setupImageView
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _deleteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-3-iconLength, 3, iconLength, iconLength)];
    _deleteIcon.contentMode = UIViewContentModeScaleAspectFill;
    _deleteIcon.clipsToBounds = YES;
    _deleteIcon.image = [UIImage imageNamed:@"icon_cha_gray"];
    _deleteIcon.userInteractionEnabled = YES;
    [_deleteIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteIconTapped:)]];
    _deleteIcon.hidden = YES;
    [self.contentView addSubview:_deleteIcon];
    _showDeleteIcon = NO;
    _hasPhoto = NO;
    [self loadIcon];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self loadIcon];
}

-(void)resetCell
{
    _hasPhoto = NO;
    _showDeleteIcon = NO;
    _deleteIcon.hidden = YES;
    _imageView.image = [UIImage imageNamed:@"icon_add_image"];
}

-(void)loadIcon
{
    if (_hasPhoto)
    {
        _imageView.image = _image;
    }
    else
    {
        _imageView.image = [UIImage imageNamed:@"icon_add_image"];
    }
    if (_showDeleteIcon)
    {
        _deleteIcon.hidden = NO;
    }
    else
    {
        _deleteIcon.hidden = YES;
    }
}

-(void)deleteIconTapped:(UITapGestureRecognizer *)tap
{
    [self.delegate photoSelectionCollectionViewCell:self didTapDeleteIcon:tap];
}

@end