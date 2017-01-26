//
//  ProgrammaticCollectionViewCell.m
//  Flicks
//
//  Created by Bob Leano on 1/26/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import "ProgrammaticCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProgrammaticCollectionViewCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ProgrammaticCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *uiImageView = [[UIImageView alloc] init];
        [self.contentView addSubview: uiImageView];
        self.imageView = uiImageView;
    }
    return self;
}
- (void) reloadData {
    [self.imageView setImageWithURL:self.flick.posterURL];
    [self setNeedsLayout];
}

- (void) layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}
@end
