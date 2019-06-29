//
//  TradeRecordAlertView.m
//  Sale_app
//
//  Created by targetios on 2018/12/5.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "TradeRecordAlertView.h"
#import "BaseTableViewCell.h"

@interface TradeRecordAlertAction ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) TradeRecordAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(TradeRecordAlertAction *);

@end

@implementation TradeRecordAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(TradeRecordAlertActionStyle)style handler:(void (^)(TradeRecordAlertAction *))handler
{
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(TradeRecordAlertActionStyle)style handler:(void (^)(TradeRecordAlertAction *))handler
{
    if (self = [super init])
    {
        _title = title;
        _style = style;
        _handler = handler;
        _enabled = YES;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TradeRecordAlertAction *action = [[self class] allocWithZone:zone];
    action.title = self.title;
    action.style = self.style;
    
    return action;
}

@end


//
@interface TradeRecordAlertView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *tipBox;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *shuLine;

@property (nonatomic, strong) NSArray <NSString *>*dataSource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *actions;

@end

@implementation TradeRecordAlertView

+ (instancetype)tipViewWithTitle:(NSString *)title dataSource:(NSArray<NSString *> *)dataSource
{
    return [[self alloc] initWithTitle:title dataSource:dataSource];
}

- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray<NSString *> *)dataSource
{
    self = [super init];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [self.titleLabel setText:LocalizedString(title)];
        
        self.dataSource = dataSource;
        
        [self.tableView reloadData];
    }
    
    return self;
}

- (NSMutableArray *)btns
{
    if (_btns == nil)
    {
        _btns = [NSMutableArray array];
    }
    
    return _btns;
}

- (NSMutableArray *)actions
{
    if (_actions == nil)
    {
        _actions = [NSMutableArray array];
    }
    
    return _actions;
}

- (void)addAction:(TradeRecordAlertAction *)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:LocalizedString(action.title) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTag:action.style];
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor fontBlackColor] forState:UIControlStateNormal];
    
    [self.tipBox addSubview:button];
    [self.btns addObject:button];
    [self.actions addObject:action];
}

/** 判断显示条件，如果有其他视图正在显示就不弹出 */
- (BOOL)judgeShowCondition
{
    if (_isShowing)
    {
        return NO;
    }
    
    _isShowing = YES;
    
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([rootController.presentedViewController isKindOfClass:[UIAlertController class]] || [rootController.presentedViewController isKindOfClass:[NSClassFromString(@"LoginViewController") class]])
    {
        return NO;
    }
    
    UINavigationController *curNavi = [self currentNavigationController];
    if ([curNavi isBeingPresented])
    {
        return NO;
    }
    
    for (UIView *subview in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([subview isKindOfClass:[TradeRecordAlertView class]])
        {
            return NO;
        }
    }
    
    return YES;
}

- (UINavigationController *)currentNavigationController
{
    UINavigationController *navigationController = nil;
    
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([controller isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)controller;
        controller = tabBarController.viewControllers[tabBarController.selectedIndex];
        
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            navigationController = (UINavigationController *)controller;
        }
    }
    
    while (controller.presentedViewController != nil)
    {
        controller = controller.presentedViewController;
        
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            navigationController = (UINavigationController *)controller;
        }
    }
    
    
    return navigationController;
}

#pragma mark - ********* 事件

- (void)showInView:(UIView *)view
{
    if (![self judgeShowCondition])
    {
        return;
    }
    
    [self layoutButtons];
    
    if (view == nil)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [self setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [view addSubview:self];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    _isShowing = YES;
}

- (void)hideInView:(UIView *)view
{
    if (view == nil)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    if (view)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    
    _isShowing = NO;
}

- (void)actionButtonClicked:(UIButton *)sender
{
    [self hideInView:nil];
    
    TradeRecordAlertAction *action = self.actions[sender.tag];
    
    if (action.handler != nil)
    {
        action.handler(action);
    }
}

#pragma mark - ******** UI

- (UIView *)tipBox
{
    if (_tipBox == nil)
    {
        _tipBox = [[UIView alloc] init];
        [_tipBox.layer setCornerRadius:2];
        [_tipBox.layer setMasksToBounds:YES];
        [_tipBox setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:_tipBox];
        
        [_tipBox makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(280);
            make.center.equalTo(self);
        }];
    }
    
    return _tipBox;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        __weak UIView *superView = self.tipBox;
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setNumberOfLines:0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor fontBlackColor];
        
        [superView addSubview:_titleLabel];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(superView).offset(10);
            make.right.equalTo(superView).offset(-10);
            make.height.equalTo(60);
        }];
        
        [self topLine];
    }
    
    return _titleLabel;
}

- (UIView *)topLine
{
    if (_topLine == nil)
    {
        _topLine = [[UIView alloc] init];
        [_topLine setBackgroundColor:[UIColor lineColor]];
        
        [self.titleLabel addSubview:_topLine];
        
        [_topLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tipBox);
            make.height.equalTo(0.5);
            make.bottom.equalTo(self.titleLabel);
        }];
    }
    
    return _topLine;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setScrollEnabled:NO];
        [_tableView setBackgroundColor:nil];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        
        [self addSubview:_tableView];
        
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.bottom).offset(20);
            make.left.equalTo(self.tipBox).offset(15);
            make.right.equalTo(self.tipBox).offset(-15);
            make.height.equalTo(30 * 4 + 50);
        }];
    }
    
    return _tableView;
}

- (UIView *)line
{
    if (_line == nil)
    {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor lineColor]];
        
        [self.tipBox addSubview:_line];
        
        [_line makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tipBox);
            make.height.equalTo(0.5);
            make.bottom.equalTo(self.tipBox).offset(-50);
        }];
    }
    
    return _line;
}

- (UIView *)shuLine
{
    if (_shuLine == nil)
    {
        _shuLine = [[UIView alloc] init];
        [_shuLine setBackgroundColor:[UIColor lineColor]];
        
        [self.tipBox addSubview:_shuLine];
        
        [_shuLine makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.btns.lastObject);
            make.width.equalTo(0.5);
            make.bottom.centerX.equalTo(self.tipBox);
        }];
    }
    
    return _shuLine;
}

- (void)layoutButtons
{
    [self.btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.btns makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom).offset(20);
        make.bottom.equalTo(self.tipBox);
        make.height.mas_equalTo(50);
    }];
    
    [self line];
    [self shuLine];
}

#pragma mark - ******** 代理 ********

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSource.count - 1)
    {
        return 50;
    }
    
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSettingCell"];
    
    if (cell == nil)
    {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"kSettingCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSArray *leftTitles = @[@"类型:",@"数量:",@"状态:",@"时间:",@"地址:"];
    
    [cell.textLabel setText:LocalizedString(leftTitles[indexPath.row])];
    [cell.detailTextLabel setText:LocalizedString(self.dataSource[indexPath.row])];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.detailTextLabel setNumberOfLines:2];
    
    [cell.textLabel setTextColor:[UIColor fontBlackColor]];
    [cell.detailTextLabel setTextColor:[UIColor fontBlackColor]];
    
    return cell;
}

@end
