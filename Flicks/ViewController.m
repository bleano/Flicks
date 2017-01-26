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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.systemMessageView.hidden = YES;
    self.movieTableView.dataSource = self;
    self.flickCollectionView.dataSource = self;
    NSLog(@"toolbarItems: %@", self.tabBarController.toolbarItems);


}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue: %@", self.restorationIdentifier);
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
//            NSLog(@"Response: %@", responseDictionary);
            NSArray *results = responseDictionary[@"results"];
            NSMutableArray *flicks = [NSMutableArray array];
            for (NSDictionary *result in results) {
                Flick *flick = [[Flick alloc] initWithDictionary:result];
//                NSLog(@"FLICK: %@", flick.flickId);
                [flicks addObject: flick];
            }
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.flicks = flicks;
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
//            });
            
            self.flicks = flicks;
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
         } else {
             self.systemMessageView.hidden = NO;
             self.systemMessageLable.text = @"NetworkError";
            NSLog(@"An error occurred: %@", error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    }];

    [task resume];
}

- (void)viewWillAppear:(BOOL)animated {
    self.systemMessageView.hidden = YES;
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
    NSLog(@"flickCollectionViewModes onValueChange %f", index);
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
