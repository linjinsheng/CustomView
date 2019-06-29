//
//  CustomAlertView.m
//  Sale_app
//
//  Created by targetios on 2018/8/31.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "CustomAlertView.h"

@interface AlertAction ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) AlertActionStyle style;
@property (nonatomic, copy) void (^handler)(AlertAction *);

@end

@implementation AlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(void (^)(AlertAction *))handler
{
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(void (^)(AlertAction *))handler
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
    AlertAction *action = [[self class] allocWithZone:zone];
    action.title = self.title;
    action.style = self.style;
    
    return action;
}

@end


@interface CustomAlertView ()

@property (nonatomic, strong) UIView *tipBox;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *shuLine;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *actions;

@property (nonatomic, strong) MASConstraint *bottomConstraint;

@end

@implementation CustomAlertView

+ (instancetype)tipViewWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [self.titleLabel setText:LocalizedString(title)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [self.nickNameTextfield becomeFirstResponder];
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

 - (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    
    [self.titleLabel setText:nil];
    [self.titleLabel setAttributedText:attributedString];
}

- (void)addAction:(AlertAction *)action
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
        if ([subview isKindOfClass:[CustomAlertView class]])
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

    AlertAction *action = self.actions[sender.tag];
    
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
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).priorityHigh();
            make.bottom.equalTo(self).priorityLow();
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
        _titleLabel.textColor = [UIColor colorWithHex:0x000000];
        
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

- (CommonModuleTextField *)nickNameTextfield
{
    if (_nickNameTextfield == nil)
    {
        _nickNameTextfield = [[CommonModuleTextField alloc] init];
        [_nickNameTextfield setFont:[UIFont systemFontOfSize:15]];
        [_nickNameTextfield setRightViewMode:UITextFieldViewModeAlways];
        [_nickNameTextfield setRightView:[self textFieldLeftViewWithImageNameString:@"i_btn_account"]];
        [_nickNameTextfield setPlaceholder:LocalizedString(@"昵称")];
        
        [self.tipBox addSubview:_nickNameTextfield];
        
        [_nickNameTextfield makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipBox).offset(15);
            make.top.equalTo(self.titleLabel.bottom).offset(30);
            make.right.equalTo(self.tipBox).offset(-15);
            make.height.mas_equalTo(40);
        }];
    }
    
    return _nickNameTextfield;
}

- (UIImageView *)textFieldLeftViewWithImageNameString:(NSString *)imageNameString
{
    UIImage *img = [UIImage imageNamed:imageNameString];
    
    UIImageView *imgview = [[UIImageView alloc] init];
    [imgview setContentMode:UIViewContentModeLeft];
    [imgview setImage:img];
    [imgview setFrame:CGRectMake(0, 0, img.size.width + 10, img.size.height)];
    
    return imgview;
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
    if (self.btns.count > 1)
    {
        [self.btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [self.btns makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickNameTextfield.bottom).offset(30);
            make.bottom.equalTo(self.tipBox);
            make.height.mas_equalTo(50);
        }];
    }
    else
    {
        [self.btns.firstObject makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickNameTextfield.bottom).offset(10);
            make.bottom.equalTo(self.tipBox);
            make.height.mas_equalTo(50);
            make.width.equalTo(95);
            make.centerX.equalTo(self.tipBox);
        }];
    }
    
    [self line];
    [self shuLine];
}

#pragma mark - UIKeyboad Notification methods

-(void)keyboardWillShowNotification:(NSNotification*)aNotification
{
    CGFloat aDuration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect kbFrame = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:aDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [self.tipBox updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).priorityLow();
            
            if (kScreenHeight <= 320)
            {
                _bottomConstraint = make.bottom.equalTo(self).offset(-(kbFrame.size.height - 40));
            }
            else
            {
                _bottomConstraint = make.bottom.equalTo(self).offset(-kbFrame.size.height);
            }
        }];
        
    } completion:NULL];
    
    [self layoutIfNeeded];
}

- (void)keyboardWillHideNotification:(NSNotification*)aNotification
{
    CGFloat aDuration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [_bottomConstraint uninstall];
    
    [UIView animateWithDuration:aDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.tipBox updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).priorityHigh();
        }];
        
    } completion:NULL];
    
    [self layoutIfNeeded];
}

@end
