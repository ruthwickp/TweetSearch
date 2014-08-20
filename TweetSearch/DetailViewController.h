//
//  DetailViewController.h
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/16/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Tweet+Annotation.h"

// Displays Tweets on a mapview
@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

// Array consist of top 100 tweets to display
@property (strong, nonatomic) NSArray *topTweets;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
