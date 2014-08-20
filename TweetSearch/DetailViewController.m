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

// Makes view the delegate
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

// When top Tweets are set, we add annotations for them
- (void)setTopTweets:(NSArray *)topTweets
{
    _topTweets = topTweets;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.topTweets];
}

#pragma mark - MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // Displays Tweet annotations
    if ([annotation isKindOfClass:[Tweet class]]) {
        NSString *annotationIdentifier = @"Annotation Identifier";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        // Creates annotation if it doesn't exist
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = YES;
        }
        else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil;
}



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
