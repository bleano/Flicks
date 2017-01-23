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

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (strong, nonatomic) NSArray<Flick *> *flicks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTableView.dataSource = self;
    [self fetchFlicks];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchFlicks {
    NSString *apiKey = @"ada044d36f9975bd000fd457db65d01d";
    NSString *urlString =
    [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    
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
            NSLog(@"Response: %@", responseDictionary);
            NSArray *results = responseDictionary[@"results"];
            NSMutableArray *flicks = [NSMutableArray array];
            for (NSDictionary *result in results) {
                Flick *flick = [[Flick alloc] initWithDictionary:result];
                NSLog(@"FLICK: %@", flick.title);
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

- (void) reload{
    [self.movieTableView reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    Flick *flick = [self.flicks objectAtIndex:indexPath.row];
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    movieCell.titleLabel.text = flick.title;
    movieCell.posterBody.text = flick.summary;
    movieCell.posterImage.image = [UIImage imageNamed:@"/Users/leano/Desktop/Yahoo.png"];
    NSLog(@"row number:@%ld", indexPath.row);
    return movieCell;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return self.flicks.count;
}


@end
