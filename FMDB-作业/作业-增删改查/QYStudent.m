//
//  QYStudent.m
//  作业-增删改查
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYStudent.h"

@implementation QYStudent


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.stu_id=value;
    }
}

-(instancetype)initWithDic:(NSDictionary *)value{
    if (self = [super init]) {
        //KVC进行赋值
        [self setValuesForKeysWithDictionary:value];
    }
    return self;
}

@end
