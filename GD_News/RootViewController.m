//
//  RootViewController.m
//  GD_News
//
//  Created by xiaoyu on 15/11/17.
//  Copyright © 2015年 guoda. All rights reserved.
//

#import "RootViewController.h"

#define TitleLineTag  999
#define TableViewTag 10000
@interface RootViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    float new;
    float old;
    BOOL isLeft;
    
}
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIScrollView *SelectedItemsView;

@property (nonatomic, strong) UIScrollView *backScrollView;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavigation];
    
    [self createMenu_selected_Items];
    
    [self createBackScrollView];
}
#pragma  mark - 滚动视图
- (void)createBackScrollView {
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+40, SCREENWIDTH, SCREENHEIGHT-64-40)];
    _backScrollView.showsHorizontalScrollIndicator = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.delegate = self;
    _backScrollView.pagingEnabled = YES;
    [self.view addSubview:_backScrollView];
    
    
    CGFloat x = 0;
    CGFloat width = SCREENWIDTH;
    CGFloat height = _backScrollView.frame.size.height;
    for (int i=0; i<3; i++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = TableViewTag+i;
        [_backScrollView addSubview:tableView];
        x += width;
        
    }
    _backScrollView.contentSize = CGSizeMake(width*_titleArray.count, height);
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger number =scrollView.contentOffset.x/SCREENWIDTH + 1000;
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.tag = TitleLineTag;
    
    for (UIView *view in _SelectedItemsView.subviews) {
        if (number == view.tag) { //选中
            UIButton *button = (UIButton*)view;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            lineLabel.backgroundColor = [UIColor redColor];
            
            lineLabel.frame = CGRectMake(0, button.frame.size.height-1, button.frame.size.width, 1);
            [button addSubview:lineLabel];
            [_SelectedItemsView scrollRectToVisible:CGRectMake(60*(number-1000), 0, 60, 40) animated:YES];
        }
        else { //没有被选中
            UIButton *button = (UIButton*)view;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            for (UIView *view1 in button.subviews) {
                UILabel *label = (UILabel*)view1;
                if (label.tag == TitleLineTag) {
                    [label removeFromSuperview];
                }
            }
        }
    }
    
    int page = scrollView.contentOffset.x / SCREENWIDTH;
    if (isLeft) {
        if (page >= 3 && page <= _titleArray.count) {
            NSLog(@"111111");
            NSInteger needCreate = 0;
            for (UIView *view2 in _backScrollView.subviews) {
                if (view2.tag == TableViewTag + page) {
                    needCreate = 1;
                }
                
            }
            if (needCreate ==1) {
                //不用创建
                NSLog(@"不用创建");
                return;
            }
            else{
                NSLog(@"需要创建");
                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((page)*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-64-40)];
                tableView.tag = TableViewTag + page;
                tableView.delegate = self;
                tableView.backgroundColor = [UIColor yellowColor];
                [_backScrollView addSubview:tableView];
                
            }
            
            
        }
    }
    else{
        
        NSLog(@"向右");
    }
    
    
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    old = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    new = scrollView.contentOffset.x;
    if (new > old) {
        isLeft = YES;
    }else{
        isLeft = NO;
    }
}
#pragma mark - 选项条
- (void)createMenu_selected_Items {
    self.SelectedItemsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 40)];
    _SelectedItemsView.bounces = YES;
    //    self.SelectedItemsView.delegate = self;
    _SelectedItemsView.showsHorizontalScrollIndicator = NO;
    _SelectedItemsView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.SelectedItemsView];
    
    CGFloat x = 0;
    CGFloat width = 60;
    CGFloat height = 40;
    for (int i=0; i<_titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(x, 0, width, height);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        x += width;
        button.tag = 1000 + i;
        [self.SelectedItemsView addSubview:button];
        if (i == 0) {
            UILabel *lineLabel = [[UILabel alloc] init];
            lineLabel.tag = TitleLineTag;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            lineLabel.backgroundColor = [UIColor redColor];
            lineLabel.frame = CGRectMake(0, button.frame.size.height-1, button.frame.size.width, 1);
            [button addSubview:lineLabel];
        }
    }
    _SelectedItemsView.contentSize = CGSizeMake(width*_titleArray.count, height);
    
}
- (void)btnClick:(UIButton*)sender {
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.tag = TitleLineTag;
    
    for (UIView *view in _SelectedItemsView.subviews) {
        if (sender.tag == view.tag) { //选中
            UIButton *button = (UIButton*)view;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            lineLabel.backgroundColor = [UIColor redColor];
            
            lineLabel.frame = CGRectMake(0, button.frame.size.height-1, button.frame.size.width, 1);
            [button addSubview:lineLabel];
            
        }
        else { //没有被选中
            UIButton *button = (UIButton*)view;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            for (UIView *view1 in button.subviews) {
                UILabel *label = (UILabel*)view1;
                if (label.tag == TitleLineTag) {
                    [label removeFromSuperview];
                }
            }
        }
    }
    
    [_backScrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * (sender.tag-1000), 0, SCREENWIDTH, SCREENHEIGHT-64-40) animated:YES];
    
    NSInteger page = sender.tag -1000;
    if (page >= 3 && page <= _titleArray.count) {
        NSLog(@"111111");
        NSInteger needCreate = 0;
        for (UIView *view2 in _backScrollView.subviews) {
            if (view2.tag == TableViewTag + page) {
                needCreate = 1;
            }
            
        }
        if (needCreate ==1) {
            //不用创建
            NSLog(@"不用创建");
            return;
        }
        else{
            NSLog(@"需要创建");
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((page)*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-64-40)];
            tableView.tag = TableViewTag + page;
            tableView.delegate = self;
            tableView.backgroundColor = [UIColor yellowColor];
            [_backScrollView addSubview:tableView];
            
        }
        
        
    }
    
    
}
#pragma mark - 设置导航栏
- (void)createNavigation {
    self.title = @"HelloNews";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"首页",@"订阅",@"娱乐",@"生活",@"科技",@"北京",@"财经",@"军事",@"文化",@"体育",@"汽车",@"星座", nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
