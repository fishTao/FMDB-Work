//
//  QYStudent.h
//  作业-增删改查
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QYStudent : NSObject


@property(nonatomic ,assign)int age;
@property(nonatomic,strong)NSString *name;
@property(nonatomic ,strong)NSString *stu_id;

-(instancetype)initWithDic:(NSDictionary *)value;



@end
