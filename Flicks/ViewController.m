//
//  ViewController.m
//  Flicks
//
//  Created by Bob Leano on 1/23/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "Flick.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FlickDetailsViewController.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (strong, nonatomic) NSArray<Flick *> *flicks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTableView.dataSource = self;
    NSLog(@"restorationIdentifier: %@", self.restorationIdentifier);

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue: %@", self.restorationIdentifier);
    if ([sender isKindOfClass:[MovieCell class]]) {
        MovieCell *cell = sender;
        NSIndexPath *indexPath = [self.movieTableView indexPathForCell:cell];
        FlickDetailsViewController *flickDetail = [segue destinationViewController];
        Flick *flick = [self.flicks objectAtIndex:indexPath.row];
        flickDetail.flickId = flick.flickId;
        flickDetail.posterPath = flick.posterPath;
        flickDetail.flickDescription = flick.summary;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchFlicks {
    NSString *apiKey = @"ada044d36f9975bd000fd457db65d01d";
    NSString *urlString =
    [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    self.flicksLabel.text = @"Now Playing";
    NSString *restorationIdentifier = self.restorationIdentifier;
        NSString *topRatedRestorationIdentifier = @"TopRatedRestorationId";
    if([restorationIdentifier isEqualToString:topRatedRestorationIdentifier]){
        urlString = [@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:apiKey];
        self.flicksLabel.text = @"Top Rated";
    }
    NSLog(@">>>urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [
        session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data,
                                    NSURLResponse * _Nullable response,
                                    NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:kNilOptions
                                              error:&jsonError];
//            NSLog(@"Response: %@", responseDictionary);
            NSArray *results = responseDictionary[@"results"];
            NSMutableArray *flicks = [NSMutableArray array];
            for (NSDictionary *result in results) {
                Flick *flick = [[Flick alloc] initWithDictionary:result];
//                NSLog(@"FLICK: %@", flick.flickId);
                [flicks addObject: flick];
            }
            self.flicks = flicks;
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
            
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    
    }];
    [task resume];
}

- (void)viewWillAppear:(BOOL)animated {
        NSLog(@"viewWillAppear restorationIdentifier: %@", self.restorationIdentifier);
        [self fetchFlicks];
}

- (void)viewDidAppear:(BOOL)animated {
//        NSLog(@"viewDidAppear restorationIdentifier: %@", self.restorationIdentifier);
}

- (void)viewWillDisappear:(BOOL)animated {
//        NSLog(@"view will disappear restorationIdentifier: %@", self.restorationIdentifier);
}

- (void)viewDidDisappear:(BOOL)animated {
//        NSLog(@"viewDidDisappear restorationIdentifier: %@", self.restorationIdentifier);
}

- (void) reload{
    [self.movieTableView reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    Flick *flick = [self.flicks objectAtIndex:indexPath.row];
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    movieCell.titleLabel.text = flick.title;
    movieCell.posterBody.text = flick.summary;
    movieCell.flickId = flick.flickId;
    [movieCell.posterImage setImageWithURL: flick.posterURL];
//    NSLog(@"row number:@%ld", indexPath.row);
    return movieCell;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return self.flicks.count;
}


@end
