//
//  WriteStoryRequest.m
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "WriteStoryRequest.h"

@implementation WriteStoryRequest

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description":@"descr",
                                                       @"id":@"id",
                                                       @"status":@"status",
                                                       @"title":@"title"
                                                       }];
}

@end
