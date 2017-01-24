//
//  FlickDetailsViewController.h
//  Flicks
//
//  Created by Bob Leano on 1/24/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickDetailsViewController : UIViewController
@property (nonatomic, strong) NSString *flickId;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSString *flickDescription;
@property (nonatomic, strong) NSString *posterPath;
@end
