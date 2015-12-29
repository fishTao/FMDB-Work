//
//  AddViewController.m
//  作业-增删改查
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"添加";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置保存按钮
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(clickAdd:)];
    self.navigationItem.rightBarButtonItem = btn;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(38, 200, 300,300 )];
    image.image = [UIImage imageNamed:@"2.jpg"];
    
    [self.view addSubview:image];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickAdd:(UIBarButtonItem *)sander{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
