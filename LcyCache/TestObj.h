//
//  TestObj.h
//  LcyCache
//
//  Created by lcyu on 15/8/13.
//  Copyright (c) 2015年 Lcyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SubObj : NSObject
@property (nonatomic, strong) NSString *address;
@end

@interface TestObj : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) SubObj *subObj;
@end
