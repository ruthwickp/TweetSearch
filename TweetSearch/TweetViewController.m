//
//  TweetViewController.m
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/16/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate>
// Outlets to UIControls
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UISlider *batchSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetViewController

// Displays only tweets located in a certain map area
- (IBAction)filterByMapButtonPressed {
}

// Get called when slider moves to certain value
// Displays number of tweets from that value
- (IBAction)movedBatchSlider:(UISlider *)sender {
}
@end
