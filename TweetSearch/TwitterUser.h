//
//  TwitterUser.h
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/16/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet;

@interface TwitterUser : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *tweets;
@end

@interface TwitterUser (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

@end
