//
//  LoadingView.h
//  Sale_app
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "BaseTipView.h"

// 加载view 配置
@interface LoadingConfiguration : NSObject

//是否遮盖导航 default yes
@property (nonatomic, assign) BOOL isCoverNavigationBar;

//是否遮盖Tabar default yes
@property (nonatomic, assign) BOOL isCoverTabarBar;

//是否可以交互 default no
@property (nonatomic, assign) BOOL userInteractionEnabled;

/**
 默认配置
 
 @return 配置对象本身
 */
+ (instancetype)defaultConfiguration;

+ (instancetype)configurationWithIsCoverNavigationBar:(BOOL)isCoverNavigationBar
                                      isCoverTabarBar:(BOOL)isCoverTabarBar
                               userInteractionEnabled:(BOOL)userInteractionEnabled;

@end


//loading view
@interface LoadingView : BaseTipView

+ (void)startLoadingWithConfiguration:(LoadingConfiguration *)configuration;

//开始加载
+ (void)startLoading;

//停止加载
+ (void)stopLoading;

@end
