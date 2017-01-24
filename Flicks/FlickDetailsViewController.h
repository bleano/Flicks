//
//  FlickDetailsViewController.h
//  Flicks
//
//  Created by Bob Leano on 1/24/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickDetailsViewController : UIViewController
//data
@property (nonatomic, strong) NSString *flickId;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSString *flickDescription;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *flickTitle;

//ui elements
@property (weak, nonatomic) IBOutlet UILabel *flickDetailTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *flickScrollView;
@property (weak, nonatomic) IBOutlet UIView *flickDetailContentView;

@end
