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
-(void)saveObject:(id<NSCoding>)object withKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;
-(void)readStringForKey:(NSString *)key completeBlock:(void (^)(NSString *readString))completeBlock;
-(void)readObjectForKey:(NSString *)key completeBlock:(void (^)(id readObject))completeBlock;
@end
