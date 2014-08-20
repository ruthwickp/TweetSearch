//
//  Tweet+Annotation.m
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/19/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Tweet+Annotation.h"
#import "TwitterUser.h"

@implementation Tweet (Annotation)

#pragma mark - Annotation propertys

// Return coordinates of tweet
- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

// Return content of Tweet
- (NSString *)title
{
    return self.content;
}

// Returns username of Tweet
- (NSString *)subtitle
{
    return self.user.username;
}


@end
