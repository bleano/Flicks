//
//  FlickDetailsViewController.m
//  Flicks
//
//  Created by Bob Leano on 1/24/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import "FlickDetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface FlickDetailsViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *flickDetailImageView;
@property (weak, nonatomic) IBOutlet UITextView *flickTextView;
@property (weak, nonatomic) IBOutlet UILabel *flickDetailDescription;

@end

@implementation FlickDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flickScrollView.delegate = self;
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", self.posterPath];
    [self.flickDetailImageView setImageWithURL: [NSURL URLWithString:urlString]];
    self.flickScrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    CGFloat contentOffsetY = 0 + CGRectGetHeight(self.flickDetailContentView.bounds);
    self.flickScrollView.contentSize = CGSizeMake(self.flickScrollView.bounds.size.width, contentOffsetY);
//    self.flickScrollView.backgroundColor = [UIColor yellowColor];
    self.flickDetailContentView.backgroundColor = [UIColor blackColor];
    self.flickDetailTitle.text = self.flickTitle;
    self.flickDetailTitle.textColor = [UIColor whiteColor];
    [self.flickTextView sizeToFit];
    self.flickTextView.text = self.flickDescription;
    self.flickTextView.textColor = [UIColor whiteColor];
    self.flickTextView.backgroundColor = [UIColor blackColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    targetContentOffset->y = -180;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
