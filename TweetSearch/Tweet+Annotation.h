//
//  Tweet+Annotation.h
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/19/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Tweet.h"
#import <MapKit/MapKit.h>

// Makes this class an annotation
@interface Tweet (Annotation) <MKAnnotation>

@end
