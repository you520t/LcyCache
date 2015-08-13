//
//  TestObj.m
//  LcyCache
//
//  Created by lcyu on 15/8/13.
//  Copyright (c) 2015年 Lcyu. All rights reserved.
//

#import "TestObj.h"
@implementation SubObj
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.address forKey:@"address"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        self.address = [decoder decodeObjectForKey:@"address"];
    }
    return self;
}
@end

@implementation TestObj
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeObject:self.subObj forKey:@"subObj"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        self.name = [decoder decodeObjectForKey:@"name"];
        self.age = [decoder decodeIntegerForKey:@"age"];
        self.subObj = [decoder decodeObjectForKey:@"subObj"];
    }
    return self;
}
@end
