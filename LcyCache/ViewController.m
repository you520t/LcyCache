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
