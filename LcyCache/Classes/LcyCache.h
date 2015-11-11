//
//  LcyCache.h
//  LcyCache
//
//  Created by lcyu on 15/8/6.
//  Copyright (c) 2015年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LcyCache : NSObject
+(instancetype)shareCache;

-(void)saveString:(NSString *)data withKey:(NSString *)key;
-(void)saveString:(NSString *)data withKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

-(void)saveObject:(id<NSCoding>)object withKey:(NSString *)key;
-(void)saveObject:(id<NSCoding>)object withKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

-(void)saveData:(NSData *)data withKey:(NSString *)key;
-(void)saveData:(NSData *)data withKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

-(void)readStringForKey:(NSString *)key completeBlock:(void (^)(NSString *readString))completeBlock;
-(NSString *)readStringForKey:(NSString *)key;
-(void)readObjectForKey:(NSString *)key completeBlock:(void (^)(id readObject))completeBlock;
-(id)readObjectForKey:(NSString *)key;
-(void)readDataForKey:(NSString *)key completeBlock:(void (^)(NSData *readData))completeBlock;
-(NSData *)readDataForKey:(NSString *)key;

-(void)removeCacheForKey:(NSString *)key;
- (BOOL)hasCacheForKey:(NSString*)key;
- (void)clearCache;
-(void)cacheSizeWithCompletionBlock:(void(^)(NSUInteger fileCount, NSUInteger cacheSize))completionBlock;
@end
