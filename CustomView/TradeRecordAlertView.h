//
//  TradeRecordAlertView.h
//  Sale_app
//
//  Created by targetios on 2018/12/5.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSUInteger, TradeRecordAlertActionStyle) {
    TradeRecordAlertActionStyleWhiteBackgroundColor = 0,//白色
    TradeRecordAlertActionStyleMainBackgroundColor = 1, //绿色
};

@interface TradeRecordAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(TradeRecordAlertActionStyle)style handler:(void (^)(TradeRecordAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) TradeRecordAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@interface TradeRecordAlertView : BaseView

@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, assign) BOOL isShowing;

+ (instancetype)tipViewWithTitle:(NSString *)title dataSource:(NSArray <NSString *>*)dataSource;

- (void)addAction:(TradeRecordAlertAction *)action;

- (void)showInView:(UIView *)view;

- (void)hideInView:(UIView *)view;

@end
