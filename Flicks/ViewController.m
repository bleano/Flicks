//
//  ViewController.m
//  Flicks
//
//  Created by Bob Leano on 1/23/17.
//  Copyright © 2017 Y.CORP.YAHOO.COM\leano. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTableView.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    movieCell.titleLabel.text = [NSString stringWithFormat: @"Title - %ld", indexPath.row];
    movieCell.posterBody.text = @"Body";
    movieCell.posterImage.image = [UIImage imageNamed:@"/Users/leano/Desktop/Flicks/Flicks/Yahoo.png"];
    NSLog(@"row number:@%ld", indexPath.row);
    return movieCell;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return 20;
}


@end
