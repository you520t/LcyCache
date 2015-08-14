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
@property (nonatomic, strong) NSString *cacheInfoFilePath;
@property (nonatomic, strong) dispatch_queue_t cacheInfoQueue;
@property (nonatomic, strong) dispatch_queue_t cacheDataQueue;
@property (nonatomic, strong) NSMutableDictionary *cacheInfo;
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
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.cacheInfoFilePath = [self.diskCachePath stringByAppendingPathComponent:@"cacheInfo"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.cacheInfoFilePath]) {
            [[NSFileManager defaultManager] createFileAtPath:self.cacheInfoFilePath contents:nil attributes:nil];
        }
        dispatch_async(self.cacheInfoQueue, ^{
            NSData *jsonData = [NSData dataWithContentsOfFile:self.cacheInfoFilePath];
            NSDictionary *jsonDic = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil] : nil;
            self.cacheInfo = jsonDic ? [jsonDic mutableCopy] : [NSMutableDictionary dictionary];
            for (NSString *key in self.cacheInfo) {
                if ([[self.cacheInfo objectForKey:key] longLongValue] < (long)NSDate.timeIntervalSinceReferenceDate) {
                    [self removeCacheForKey:key];
                }
            }
        });
    }
    return self;
}

-(void)saveString:(NSString *)data withKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    dispatch_async(self.cacheDataQueue, ^{
        NSData *stringData = [data dataUsingEncoding:NSUTF8StringEncoding];
        [self saveData:stringData withKey:key withTimeoutInterval:timeoutInterval];
    });
}

-(void)readStringForKey:(NSString *)key completeBlock:(void (^)(NSString *readString))completeBlock
{
    dispatch_async(self.cacheDataQueue, ^{
        [self readDataForKey:key completeBlock:^(NSData *readData) {
            !completeBlock?:completeBlock([[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding]);
        }];
    });
}

-(void)saveObject:(id<NSCoding>)object withKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    dispatch_async(self.cacheDataQueue, ^{
        [self saveData:[NSKeyedArchiver archivedDataWithRootObject:object] withKey:key withTimeoutInterval:timeoutInterval];
    });
}

-(void)readObjectForKey:(NSString *)key completeBlock:(void (^)(id readObject))completeBlock
{
    dispatch_async(self.cacheDataQueue, ^{
        [self readDataForKey:key completeBlock:^(NSData *readData) {
            !completeBlock?:completeBlock([NSKeyedUnarchiver unarchiveObjectWithData:readData]);
        }];
    });
}

-(void)saveData:(NSData *)data withKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    if (!key || !data) {
        return;
    }
    dispatch_async(self.cacheDataQueue, ^{
        [data writeToFile:[self.diskCachePath stringByAppendingPathComponent:key] atomically:YES];
        [self setCacheInfoKey:key withTimeoutInterval:timeoutInterval];
    });
}

-(void)readDataForKey:(NSString *)key completeBlock:(void (^)(NSData *readData))completeBlock
{
    dispatch_async(self.cacheDataQueue, ^{
        NSData *readData = [[NSData alloc] initWithContentsOfFile:[self.diskCachePath stringByAppendingPathComponent:key]];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(readData);
        });
    });
}

-(void)setCacheInfoKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSString *stringDate = timeoutInterval > 0 ? [NSString stringWithFormat:@"%ld", (long)    (NSDate.timeIntervalSinceReferenceDate + timeoutInterval)] : nil;
    dispatch_async(self.cacheInfoQueue, ^{
        if (stringDate) {
            [self.cacheInfo setValue:stringDate forKey:key];
        }
        else
        {
            [self.cacheInfo removeObjectForKey:key];
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.cacheInfo options:NSJSONWritingPrettyPrinted error:nil];
        [jsonData writeToFile:self.cacheInfoFilePath atomically:YES];
    });
}

-(void)removeCacheForKey:(NSString *)key
{
    dispatch_barrier_async(self.cacheDataQueue, ^{
        [[NSFileManager defaultManager] removeItemAtPath:[self.diskCachePath stringByAppendingPathComponent:key] error:nil];
    });
    [self setCacheInfoKey:key withTimeoutInterval:0];
}
@end
