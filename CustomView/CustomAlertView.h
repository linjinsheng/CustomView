//
//  CustomAlertView.h
//  Sale_app
//
//  Created by targetios on 2018/8/31.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "BaseView.h"
#import "CommonModuleTextField.h"

typedef NS_ENUM(NSUInteger, AlertActionStyle) {
    AlertActionStyleWhiteBackgroundColor = 0,//白色
    AlertActionStyleMainBackgroundColor = 1, //绿色
};

@interface AlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(AlertActionStyle)style handler:(void (^)(AlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) AlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@interface CustomAlertView : BaseView

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) NSAttributedString *attributedString;

@property (nonatomic, strong) CommonModuleTextField *nickNameTextfield;

@property (nonatomic, assign) BOOL isShowing;

+ (instancetype)tipViewWithTitle:(NSString *)title;

- (void)addAction:(AlertAction *)action;

- (void)showInView:(UIView *)view;

- (void)hideInView:(UIView *)view;

@end
