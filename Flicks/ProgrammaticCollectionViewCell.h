//
//  ProgrammaticCollectionViewCell.h
//  Flicks
//
//  Created by Bob Leano on 1/26/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flick.h"
@interface ProgrammaticCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) Flick *flick;
- (void) reloadData;
@end
