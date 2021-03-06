//
//  Flick.m
//  Flicks
//
//  Created by Bob Leano on 1/23/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import "Flick.h"

@implementation Flick

- (instancetype) initWithDictionary: (NSDictionary *) jsonDictionary{
    self = [super init];
    if(self){
        self.title = jsonDictionary[@"original_title"];
        self.summary = jsonDictionary[@"overview"];
        self.flickId = ((NSNumber*)jsonDictionary[@"id"]).stringValue;
        NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", jsonDictionary[@"poster_path"]];
        self.posterURL = [NSURL URLWithString:urlString];
        self.posterPath = jsonDictionary[@"poster_path"];
    }
    return self;
}

@end
