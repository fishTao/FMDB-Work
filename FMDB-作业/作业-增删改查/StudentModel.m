//
//  StudentModel.m
//  作业-增删改查
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel

+(instancetype)initName:(NSString *)name fromAge:(NSInteger)age fromStu_id:(NSInteger *)stu_id{
    StudentModel *mode=[[StudentModel alloc] init];
    mode.age = age;
    mode.stu_id = *(stu_id);
    mode.name=name;
    return mode;
}



#pragma mark 实现coding协议
/*
 * 序列化
 * 将对象归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //NSKeyedArchiver 归档工具类
    //归档姓名
    [aCoder encodeObject:_name forKey:@"name"];
    //归档年龄
    [aCoder encodeInteger:_age forKey:@"age"];
    //归档学号
    [aCoder encodeInteger:_stu_id forKey:@"stu_id"];
}
/*
 * 序列化
 * 将对象解档
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        //NSKeyedUnarchiver 解档
        
        //解档姓名
        _name=[aDecoder decodeObjectForKey:@"name"];
        //年龄
        _age=[aDecoder decodeIntegerForKey:@"age"];
        //学号
        _stu_id=[aDecoder decodeIntegerForKey:@"stu_id"];

    }
    return self;
}

@end
