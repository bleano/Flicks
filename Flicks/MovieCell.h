//
//  MovieCell.h
//  Flicks
//
//  Created by Bob Leano on 1/23/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UITextView *posterBody;
@property (strong, nonatomic) NSString *flickId;
@end
