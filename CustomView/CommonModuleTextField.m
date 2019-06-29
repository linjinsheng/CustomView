//
//  CommonModuleTextField.m
//  Sale_app
//
//  Created by targetios on 2018/11/30.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "CommonModuleTextField.h"

static CGFloat const kPadding = 15.0;

@implementation CommonModuleTextField

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.layer setCornerRadius:20];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:[UIColor colorWithHex:0xECECEC].CGColor];
    }
    
    return self;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

- (UIFont *)placeholderFont
{
    return [self valueForKeyPath:@"_placeholderLabel.font"];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGFloat leftWidth = 0;
    
    if (self.leftView != nil)
    {
        leftWidth = self.leftView.frame.size.width;
    }
    
    CGFloat rightWidth = 0;
    
    if (self.rightView != nil)
    {
        rightWidth = self.rightView.frame.size.width;
    }
    
    return CGRectMake(bounds.origin.x + kPadding + leftWidth,
                      bounds.origin.y,
                      bounds.size.width - kPadding * 2 - leftWidth - rightWidth,
                      bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat leftWidth = 0;
    
    if (self.leftView != nil)
    {
        leftWidth = self.leftView.frame.size.width;
    }
    
    CGFloat rightWidth = 0;
    
    if (self.rightView != nil)
    {
        rightWidth = self.rightView.frame.size.width;
    }
    
    return CGRectMake(bounds.origin.x + kPadding + leftWidth,
                      bounds.origin.y,
                      bounds.size.width - kPadding * 2 - leftWidth - rightWidth,
                      bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGFloat leftWidth = 0;
    
    if (self.leftView != nil)
    {
        leftWidth = self.leftView.frame.size.width;
    }
    
    CGFloat rightWidth = 0;
    
    if (self.rightView != nil)
    {
        rightWidth = self.rightView.frame.size.width;
    }
    
    return CGRectMake(bounds.origin.x + kPadding + leftWidth,
                      bounds.origin.y,
                      bounds.size.width - kPadding * 2 - leftWidth - rightWidth,
                      bounds.size.height);
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    if ([self.rightView isKindOfClass:[UIView class]])
    {
        if ([self.rightView.subviews.lastObject isKindOfClass:[UIButton class]])
        {
            UIButton *rightBtn = (UIButton *)self.rightView.subviews.lastObject;
            
            if ([rightBtn.titleLabel.text rangeOfString:LocalizedString(@"获取验证码")].location != NSNotFound ||
                rightBtn.titleLabel.text.length > 0)
            {
                CGRect textRect = [super rightViewRectForBounds:bounds];
                textRect.origin.x -= 2.5;
                
                return textRect;
            }
        }
    }
    
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    
    return textRect;
}

@end
