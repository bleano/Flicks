//
//  Flick.h
//  Flicks
//
//  Created by Bob Leano on 1/23/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flick : NSObject
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;
- (instancetype) initWithDictionary: (NSDictionary *) jsonDictionary;
- (NSString*) getDescription;
@end
