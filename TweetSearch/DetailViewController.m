//
//  DetailViewController.m
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/16/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <MKMapViewDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation DetailViewController

#pragma mark - Displaying Top Tweets

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)setTopTweets:(NSArray *)topTweets
{
    _topTweets = topTweets;
    [self drawAnnotationsForTweets];
}

- (void)drawAnnotationsForTweets
{
    
}

//if (self.masterPopoverController != nil) {
//    [self.masterPopoverController dismissPopoverAnimated:YES];
//}



#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
