//
//  ViewController.m
//  LcyCache
//
//  Created by lcyu on 15/8/6.
//  Copyright (c) 2015年 Lcyu. All rights reserved.
//

#import "ViewController.h"
#import "LcyCache.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self convertToData];
    [[LcyCache shareCache] readStringForKey:@"two" completeBlock:^(NSString *readString) {
        
    }];
    [[LcyCache shareCache] saveString:@"22高心" withKey:@"two"];
    
//    dispatch_queue_t cacheDataQueue = dispatch_queue_create("com.lcyu.cacheDataQueue", DISPATCH_QUEUE_SERIAL);
//    NSString *dic = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lcyuCacheDefault", [[NSProcessInfo processInfo] processName]]];
//    dic = [dic stringByAppendingPathComponent:@"aaa"];
//    for (int i=0; i<10000; i++) {
//        dispatch_async(cacheDataQueue, ^{
//                [[[NSString stringWithFormat:@"%d", i] dataUsingEncoding:NSUTF8StringEncoding] writeToFile:dic atomically:YES];
//                NSLog(@"%d", i);
//        });
//    }
    //    NSURL *diskCacheURL = [NSURL fileURLWithPath:dic isDirectory:YES];
    //    NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
    //
    //
    //    // This enumerator prefetches useful properties for our cache files.
    //    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:diskCacheURL
    //                                               includingPropertiesForKeys:resourceKeys
    //                                                                  options:NSDirectoryEnumerationSkipsHiddenFiles
    //                                                             errorHandler:NULL];
    //    for (NSURL *fileURL in fileEnumerator) {
    //        NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
    //        NSLog(@"%@", [fileURL absoluteString]);
    //    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)convertToData
{
    UIImage *gif = [UIImage imageNamed:@"2.png"];
    NSData * data = UIImagePNGRepresentation(gif);
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    [data writeToFile:[cacPath[0] stringByAppendingPathComponent:@"aa"] atomically:YES];
    
    UIImage *tGif = [UIImage imageWithData:[NSData dataWithContentsOfFile:[cacPath[0] stringByAppendingPathComponent:@"aa"]]];
}
@end
