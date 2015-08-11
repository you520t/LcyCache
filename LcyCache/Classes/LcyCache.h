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
-(void)readStringForKey:(NSString *)key completeBlock:(void (^)(NSString *readString))completeBlock;
@end
