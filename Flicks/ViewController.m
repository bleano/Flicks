//
//  ViewController.m
//  Flicks
//
//  Created by Bob Leano on 1/23/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "CollectionViewCell.h"
#import "Flick.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FlickDetailsViewController.h"
#import <MBProgressHUD.h>

@interface ViewController () <UITableViewDataSource, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (weak, nonatomic) IBOutlet UIView *systemMessageView;
@property (strong, nonatomic) NSArray<Flick *> *flicks;
@property (weak, nonatomic) IBOutlet UILabel *systemMessageLable;
@property (weak, nonatomic) IBOutlet UICollectionView *flickCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *flickCollectionViewModes;
@property (weak, nonatomic) UIRefreshControl *refreshControlForTableView;
@property (weak, nonatomic) UIRefreshControl *refreshControlForCollectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.systemMessageView.hidden = YES;
    self.movieTableView.dataSource = self;
    self.flickCollectionView.dataSource = self;
    self.movieTableView.hidden = NO;
    self.flickCollectionView.hidden = YES;
    UIRefreshControl *one = [[UIRefreshControl alloc]init];
    self.refreshControlForTableView = one;
    UIRefreshControl *two = [[UIRefreshControl alloc]init];
    self.refreshControlForCollectionView = two;
    [self.movieTableView insertSubview:one atIndex:0];
    [self.flickCollectionView insertSubview:two atIndex:0];
    [self.refreshControlForTableView addTarget:self action:@selector(fetchFlicks) forControlEvents:UIControlEventValueChanged];
    [self.refreshControlForCollectionView addTarget:self action:@selector(fetchFlicks) forControlEvents:UIControlEventValueChanged];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[MovieCell class]] ||
        [sender isKindOfClass:[CollectionViewCell class]]) {
        
        NSIndexPath *indexPath;
        float index = self.flickCollectionViewModes.selectedSegmentIndex;
        if(index==0) {
            MovieCell *cell = sender;
            indexPath = [self.movieTableView indexPathForCell:cell];
        }
        if(index==1) {
            CollectionViewCell *cell = sender;
            indexPath = [self.flickCollectionView indexPathForCell:cell];
        }
        
        FlickDetailsViewController *flickDetail = [segue destinationViewController];
        Flick *flick = [self.flicks objectAtIndex:indexPath.row];
        flickDetail.flickId = flick.flickId;
        flickDetail.posterPath = flick.posterPath;
        flickDetail.flickDescription = flick.summary;
        flickDetail.flickTitle = flick.title;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchFlicks {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
            NSArray *results = responseDictionary[@"results"];
            NSMutableArray *flicks = [NSMutableArray array];
            for (NSDictionary *result in results) {
                Flick *flick = [[Flick alloc] initWithDictionary:result];
                [flicks addObject: flick];
            }
            self.flicks = flicks;
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
         } else {
             self.systemMessageView.hidden = NO;
             self.systemMessageLable.text = @"NetworkError";
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    }];

    [task resume];
}

- (void)viewWillAppear:(BOOL)animated {
    self.systemMessageView.hidden = YES;
    [self fetchFlicks];
}

- (void) reload{
    [self.refreshControlForTableView endRefreshing];
    [self.refreshControlForCollectionView endRefreshing];
    float index = self.flickCollectionViewModes.selectedSegmentIndex;
    if(index==0) {
        [self.movieTableView reloadData];
    }
    if(index==1) {
        [self.flickCollectionView reloadData];
    }
    
}

//-------   SEGMENTED CONTROL
- (IBAction)onValueChanged:(id)sender {
    float index = self.flickCollectionViewModes.selectedSegmentIndex;
    self.systemMessageView.hidden = YES;
    self.movieTableView.hidden = YES;
    self.flickCollectionView.hidden = YES;
    if(index==0) {
        self.movieTableView.hidden = NO;
    }
    if(index==1) {
        self.flickCollectionView.hidden = NO;
    }
    [self fetchFlicks];
}
//-------   SEGMENTED CONTROL


//-------  TABLE VIEW
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    Flick *flick = [self.flicks objectAtIndex:indexPath.row];
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    [movieCell.posterBody sizeToFit];
    movieCell.titleLabel.text = flick.title;
    movieCell.posterBody.text = [self getSummary:flick.summary];
    movieCell.flickId = flick.flickId;
    [movieCell.posterImage setImageWithURL: flick.posterURL];
    return movieCell;
    
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return self.flicks.count;
}
//-------  TABLE VIEW

//-------  COLLECTION VIEW
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Flick *flick = [self.flicks objectAtIndex:indexPath.row];
    CollectionViewCell *movieCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    movieCell.flickId = flick.flickId;
    [movieCell.imageView setImageWithURL: flick.posterURL];
    return movieCell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.flicks.count;
}
//-------  COLLECTION VIEW


- (NSString*) getSummary: (NSString*)longString{
    NSArray *listOfWords = [longString componentsSeparatedByString:@" "];
    NSString *str = @"";
    int counter = 0;
    for (NSString *word in listOfWords) {
        str = [str stringByAppendingString:word];
        str = [str stringByAppendingString:@" "];
        counter++;
        if(counter == 15){
            str = [str stringByAppendingString:@"..."];
            return str;
        }
    }
    return str;
}



@end
