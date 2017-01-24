//
//  FlickDetailsViewController.m
//  Flicks
//
//  Created by Bob Leano on 1/24/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import "FlickDetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface FlickDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *flickDetailImageView;
@property (weak, nonatomic) IBOutlet UILabel *flickDetailDescription;

@end

@implementation FlickDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", self.posterPath];
    [self.flickDetailImageView setImageWithURL: [NSURL URLWithString:urlString]];
    self.flickDetailDescription.text = self.flickDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
