//
//  LoadingView.m
//  Sale_app
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "LoadingView.h"
#import "DGActivityIndicatorView.h"

static LoadingView *loadingView;
static DGActivityIndicatorView *activityIndicatorView;

@implementation LoadingConfiguration

- (instancetype)initWithIsCoverNavigationBar:(BOOL)isCoverNavigationBar isCoverTabarBar:(BOOL)isCoverTabarBar userInteractionEnabled:(BOOL)userInteractionEnabled
{
    self = [super init];
    
    if (self)
    {
        self.isCoverNavigationBar = isCoverNavigationBar;
        self.isCoverTabarBar = isCoverTabarBar;
        self.userInteractionEnabled = userInteractionEnabled;
    }
    return self;
}

+ (instancetype)defaultConfiguration
{
    return [self configurationWithIsCoverNavigationBar:YES isCoverTabarBar:YES userInteractionEnabled:NO];
}

+ (instancetype)configurationWithIsCoverNavigationBar:(BOOL)isCoverNavigationBar isCoverTabarBar:(BOOL)isCoverTabarBar userInteractionEnabled:(BOOL)userInteractionEnabled
{
    return [[self alloc] initWithIsCoverNavigationBar:isCoverNavigationBar isCoverTabarBar:isCoverTabarBar userInteractionEnabled:userInteractionEnabled];
}

@end

//
@implementation LoadingView

- (instancetype)initWithConfiguration:(LoadingConfiguration *)configuration
{
    self = [super init];
    
    if (self)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        
        if (configuration != nil)
        {
            self.userInteractionEnabled = configuration.userInteractionEnabled;
            
            if (!configuration.isCoverNavigationBar)
            {
                frame.size.height = frame.size.height - kTopHeight;
            }
            
            if (!configuration.isCoverTabarBar)
            {
                frame.size.height = frame.size.height - kTabBarHeight;
            }
        }
        
        [self setFrame:frame];
        [self setCenter:[UIApplication sharedApplication].keyWindow.center];
        
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallRotate];
        [activityIndicatorView setTintColor:[UIColor navTitleColor]];
        
        [self addSubview:activityIndicatorView];
        
        [activityIndicatorView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(100, 100));
            make.center.equalTo(self);
        }];
    }
    
    return self;
}

+ (void)startLoadingWithConfiguration:(LoadingConfiguration *)configuration
{
    if (configuration == nil)
    {
        configuration = [LoadingConfiguration defaultConfiguration];
    }
    
    loadingView = [[LoadingView alloc] initWithConfiguration:configuration];
    loadingView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.2];
    [loadingView show];
    
    [activityIndicatorView startAnimating];
}

+ (void)startLoading
{
    loadingView = [[LoadingView alloc] initWithConfiguration:nil];
    loadingView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.2];
    [loadingView show];
    
    [activityIndicatorView startAnimating];
}

+ (void)stopLoading
{
    [activityIndicatorView stopAnimating];
    
    [loadingView hide];
}

@end
