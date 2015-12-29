//
//  ViewController.m
//  作业-增删改查
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "AddViewController.h"
#import "AFNetworking.h"
#import "Header.h"
#import "DBFileHandel.h"
#import "QYStudent.h"


//请求的url
#define baseURl @"http://afnetworking.sinaapp.com/persons.json"
#define ISSAVE @"SAVE"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic ,strong) NSMutableArray *datas;
@property (nonatomic ,strong) UITableView *myTable;

@property(nonatomic,strong)UIRefreshControl *refreshControl;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    //====设置'添加'按钮
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAdd:)];
    self.navigationItem.rightBarButtonItem = btn;
 
#pragma mark ----添加TableView----
    
    _myTable  = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    //=设置代理
    _myTable.delegate = self;
    _myTable.dataSource = self;
    
    [self.view addSubview:_myTable];
    
    
#pragma mark  -------创建SeachBar------
    //=searchBar
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.delegate=self;
    
    _myTable.tableHeaderView=searchBar;
    
#pragma mark---------添加下拉刷新--------
    //=====添加下来刷新的控件
    _refreshControl=[[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    [_refreshControl addTarget:self action:@selector(changValue:) forControlEvents:UIControlEventValueChanged];
    //添加tableview
    [_myTable addSubview:_refreshControl];

//////////=====判断本地是否有缓存数据
    
    NSString *issave =[[NSUserDefaults standardUserDefaults] objectForKey:ISSAVE];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ISSAVE];
    if(issave){
        //读取本地缓存
        NSMutableArray *tempARR=[[DBFileHandel shareHandel] selectAllData];
        if (tempARR) {
            self.datas=tempARR;
        }
    }else{
        //网络请求
        
        [self requestHouseList];
    }

    // Do any additionalp setup after loading the view, typically from a nib.
}

#pragma searchBardelegate======搜索的方法========

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //=显示取消按钮
    searchBar.showsCancelButton=YES;
    return YES;
}

//=====点击搜索按钮的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=NO;
    //=取消第一响应
    [searchBar resignFirstResponder];
    
    //=调用搜索
    
    NSMutableArray *tempArr=[[DBFileHandel shareHandel] selectFromDataWithName:searchBar.text];
    if (tempArr) {
        self.datas=tempArr;
        //刷新列表
        [_myTable reloadData];
    }
    
    
}
//=====点击取消按钮时候调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=NO;
    //取消第一响应
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"=====%@",searchBar.text);
    if (searchBar.text.length==0) {
        //加载本地数据
        NSMutableArray *tempARR=[[DBFileHandel shareHandel] selectAllData];
        if (tempARR) {
            self.datas=tempARR;
        }
        [_myTable reloadData];
    }else{
        NSMutableArray *tempArr=[[DBFileHandel shareHandel] selectFromDataWithName:searchBar.text];
        if (tempArr) {
            self.datas=tempArr;
            //刷新列表
            [_myTable reloadData];
        }
    }
}


#pragma mark ========UITable DataSource=======


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.datas.count;
}
#pragma mark   ==============设置删除==============
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //取出模型
        QYStudent *mode=self.datas[indexPath.row];
        //1.删除数据源 内存
        [self.datas removeObjectAtIndex:indexPath.row];
        //2.删除表格
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //3.删除数据库的数据
        if ([[DBFileHandel shareHandel] deleteDataFromStuid:mode.stu_id]) {
            NSLog(@"=====删除单条数据成功");
        }
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    
    QYStudent *mode=self.datas[indexPath.row];
    cell.textLabel.text = mode.name;
    
    
    return cell;
}
#pragma mark     ============下拉刷新=============
//=========下拉刷新
-(void)endRefresh{
    _refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉刷新..."];
}

//=========正在加载
-(void)changValue:(UIRefreshControl *)control{
    if (control.isRefreshing) {
        control.attributedTitle=[[NSAttributedString alloc] initWithString:@"正在加载..."];
        //执行网络请求
        [self requestHouseList];
    }else{
        
    }
}
#pragma mark   ==========进行网络请求==========
-(void)requestHouseList{
    //请求列表
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    //设置参数
    NSDictionary *prameter=@{@"person_type":@"student"};
    //设置响应序列化
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", nil];

    [manager POST:baseURl parameters:prameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //请求成功
        NSLog(@"=======%@",responseObject);
        NSArray *tempArr=responseObject[@"data"];
        self.datas=[NSMutableArray array];
        
        for (NSDictionary *dic in tempArr) {
            QYStudent *student=[[QYStudent alloc] initWithDic:dic];
            [self.datas addObject:student];
        }
        //刷新UI
        [_myTable reloadData];
//__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-
        //如果已经ISSAVE设置过值，说明当前请求是下拉刷新请求，
        //我们需要清空当前列表，重写缓存数据
        if ([[NSUserDefaults standardUserDefaults]objectForKey:ISSAVE]) {
            //说明是下拉过来数据，删除本地已经缓存过的数据
            //删除表的上次请求的数据
            if ([[DBFileHandel shareHandel] deleteDataAll]) {
                NSLog(@"======删除完成");
            }
        }
//__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-__-
        

        //=刷新后调用停止的方法
        [_refreshControl endRefreshing];
        //设置刷新到停止的时间
        [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1];
        //缓存到数据库
        for (QYStudent *mode in self.datas) {
//            //存到数据库
            
            [[DBFileHandel  shareHandel]insertIntoDataFrom:mode];
        }
        //3.设置已经保存过
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ISSAVE];
        
        //持久化同步
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        //请求失败也要调用此方法，设置刷新时间
        [_refreshControl endRefreshing];
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
    }];
    
}


//===设置右上角的按钮功能
-(void)clickAdd:(id)sander{
    //创建添加页面的的视图以及导航控制器
    AddViewController *view = [[AddViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:view];
    
    [self presentViewController:navi animated:YES completion:^{
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
