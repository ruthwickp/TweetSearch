//
//  Tweet.h
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/16/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HashTag, Tweet, TwitterUser;

@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSSet *hashtags;
@property (nonatomic, retain) NSSet *mentions;
@property (nonatomic, retain) Tweet *replyTo;
@property (nonatomic, retain) TwitterUser *user;
@end

@interface Tweet (CoreDataGeneratedAccessors)

- (void)addHashtagsObject:(HashTag *)value;
- (void)removeHashtagsObject:(HashTag *)value;
- (void)addHashtags:(NSSet *)values;
- (void)removeHashtags:(NSSet *)values;

- (void)addMentionsObject:(TwitterUser *)value;
- (void)removeMentionsObject:(TwitterUser *)value;
- (void)addMentions:(NSSet *)values;
- (void)removeMentions:(NSSet *)values;

@end
