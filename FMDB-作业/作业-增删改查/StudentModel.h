//
//  StudentModel.h
//  作业-增删改查
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject<NSCoding>
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,assign)NSInteger age;
@property (nonatomic ,assign)NSInteger stu_id;

+(instancetype)initName:(NSString *)name fromAge:(NSInteger)age fromStu_id:(NSInteger *)stu_id;

@end
