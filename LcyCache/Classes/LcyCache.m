//
//  LcyCache.m
//  LcyCache
//
//  Created by lcyu on 15/8/6.
//  Copyright (c) 2015年 Lcyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LcyCache.h"

@interface LcyCache()
@property (nonatomic, strong) NSCache *memoryCache;
@property (nonatomic, strong) NSString *diskCachePath;
@property (nonatomic, strong) NSString *cacheInfoCachePath;
@property (nonatomic, strong) dispatch_queue_t cacheInfoQueue;
@property (nonatomic, strong) dispatch_queue_t cacheDataQueue;
@end

@implementation LcyCache

+(instancetype)shareCache
{
    static LcyCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

-(instancetype)init
{
    return [self initWithCacheDirectoryName:@"lcyuCacheDefault"];
}

-(instancetype)initWithCacheDirectoryName:(NSString *)directoryName
{
    if (self = [super init]) {
        self.cacheInfoQueue = dispatch_queue_create("com.lcyu.cacheInfo", DISPATCH_QUEUE_SERIAL);
        self.cacheDataQueue = dispatch_queue_create("com.lcyu.cacheDataQueue", DISPATCH_QUEUE_CONCURRENT);
        self.diskCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [[NSProcessInfo processInfo] processName], directoryName]];
        [[NSFileManager defaultManager] createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
//        self.cacheInfoCachePath = self.diskCachePath
    }
    return self;
}

-(void)saveString:(NSString *)data withKey:(NSString *)key
{
    if (!key || !data) {
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{key:data} options:NSJSONWritingPrettyPrinted error:nil];
    [jsonData writeToFile:[self.diskCachePath stringByAppendingPathComponent:key] atomically:YES];
}

-(void)readStringForKey:(NSString *)key completeBlock:(void (^)(NSString *readString))completeBlock
{
    dispatch_async(self.cacheDataQueue, ^{
        NSData *jsonData = [NSData dataWithContentsOfFile:[self.diskCachePath stringByAppendingPathComponent:key]];
        NSDictionary *jsonDic = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil] : nil;
        !completeBlock?:completeBlock([jsonDic valueForKey:key]);
    });
}

//-(void)saveCacheInfoKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
//{
//    self.ca
//}
@end
