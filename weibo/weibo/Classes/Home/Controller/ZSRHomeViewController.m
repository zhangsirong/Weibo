//
//  ZSRHomeViewController.m
//  weibo
//
//  Created by hp on 15/11/27.
//  Copyright © 2015年 hp. All rights reserved.
//

#import "ZSRHomeViewController.h"
#import "ZSRSearchBar.h"
#import "ZSRDropdownMenu.h"
#import "ZSRTitleMenuViewController.h"
#import "AFNetworking.h"
#import "ZSRAccountTool.h"
#import "ZSRTitleButton.h"

@interface ZSRHomeViewController ()<ZSRDropdownMenuDelegate>

@end

@implementation ZSRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏内容
    [self setupNav];
    
    //获得用户信息
    [self setupUserInfo];

}

/**
 * 获得用户信息
 */
- (void)setupUserInfo
{
    
    // https://api.weibo.com/2/users/show.json
    // access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    // uid	false	int64	需要查询的用户ID。
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    ZSRAccount *account = [ZSRAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        ZSRLog(@"请求成功-%@", responseObject);

        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        NSString *name = responseObject[@"name"];
        [titleButton setTitle:name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = name;
        [ZSRAccountTool saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZSRLog(@"请求失败-%@", error);
    }];

}
/**
 *  设置导航栏上面的内容
 */
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题按钮 */
    ZSRTitleButton *titleButton = [[ZSRTitleButton alloc] init];
   // 设置图片和文字
    NSString *name = [ZSRAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
//    titleButton.backgroundColor = ZSRRandomColor;
    self.navigationItem.titleView = titleButton;
}
    // 如果图片的某个方向上不规则，比如有突起，那么这个方向就不能拉伸
    // 什么情况下建议使用imageEdgeInsets、titleEdgeInsets
    // 如果按钮内部的图片、文字固定，用这2个属性来设置间距，会比较简单
    // 标题宽度
    //    CGFloat titleW = titleButton.titleLabel.width * [UIScreen mainScreen].scale;
    ////    // 乘上scale系数，保证retina屏幕上的图片宽度是正确的
    //    CGFloat imageW = titleButton.imageView.width * [UIScreen mainScreen].scale;
    //    CGFloat left = titleW + imageW;
    //    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);
    


/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton{
    
    // 1.创建下拉菜单
    ZSRDropdownMenu *menu = [ZSRDropdownMenu menu];
    menu.delegate = self;
    
    // 2.设置内容
    ZSRTitleMenuViewController *vc = [[ZSRTitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}

- (void)friendSearch
{
    NSLog(@"friendSearch");
}

- (void)pop
{
    NSLog(@"pop");
}

#pragma mark - HWDropdownMenuDelegate
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(ZSRDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    // 让箭头向下
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(ZSRDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
    // 让箭头向上
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

@end
