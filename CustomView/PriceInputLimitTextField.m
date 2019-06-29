//
//  PriceInputLimitTextField.m
//  Sale_app
//
//  Created by targetios on 2018/9/3.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "PriceInputLimitTextField.h"
#import "HUDHelper.h"

@class EDPriceTextFieldLimit;

@interface PriceInputLimitTextField ()

@property (nonatomic, strong) EDPriceTextFieldLimit *limit;

@end

@implementation PriceInputLimitTextField

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.delegate = self.limit;
        [self addTarget:self.limit
                 action:@selector(valueChange:)
       forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

// 禁止 粘贴、剪切、选择、选择全部
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    //禁止粘贴
    if (action == @selector(paste:))
    {
        return NO;
    }
    if (action == @selector(cut:))
    {
        return NO;
    }
    if (action == @selector(copy:))
    {
        return NO;
    }
    if (action == @selector(select:))
    {
        return NO;
    }
    if (action == @selector(selectAll:))
    {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (EDPriceTextFieldLimit *)limit
{
    if (!_limit)
    {
        _limit = [[EDPriceTextFieldLimit alloc] init];
    }
    
    return _limit;
}

@end

// **********
@interface EDPriceTextFieldLimit ()

@property (nonatomic, strong) NSString *tempText;
@property (nonatomic, assign) NSRange tempRange;
@property (nonatomic, strong) NSString *tempString;

@end

@implementation EDPriceTextFieldLimit

- (instancetype)init
{
    if (self = [super init])
    {
        _max = @"999999999.99";
    }
    
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _tempText = textField.text;
    _tempRange = range;
    _tempString = string;
    
    if (string && string.length > 0)
    {
        // 输入
        if (_tempText.length == 0)
        {
            if ([string isEqualToString:@"."])
            {
                _tempText = @"0";
            }

            return YES;

        }
        else if (_tempText.length == 1)
        {
            if ([_tempText isEqualToString:@"0"])
            {
                if ([string isEqualToString:@"."])
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
        }
        // 输入后不可超过 '99999.99'
        if ([_tempText stringByAppendingString:string].floatValue > [_max floatValue])
        {
            [HUDHelper showTip:@"不能超过可提取余额"];
            return NO;
        }
        // 不可超过8位
        if (_tempText.length >= _max.length)
        {
            return NO;
        }
        
        NSRange docRange = [_tempText rangeOfString:@"."];
        if (docRange.location != NSNotFound)
        {
            // 已输入小数点, 禁止再输入小数点
            if ([string isEqualToString:@"."])
            {
                return NO;
            }
            // 小数点后位数
            NSUInteger decimals = _tempText.length - (docRange.location + docRange.length);
            if (decimals == 2)
            {
                // 小数点后两位,禁止输入任何字符
                return NO;
            }
            else if (decimals == 1)
            {
                // 小数点后一位,禁止输入 '0'
                if ([string isEqualToString:@"0"])
                {
                    return NO;
                }
            }
        }
        else
        {
            if (_tempText.length == 0)
            {
                // 第一位
                if ([string isEqualToString:@"."] || [string isEqualToString:@"0"])
                {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

#pragma mark TextFieleActions

- (void)valueChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    
    NSRange docRange = [_tempText rangeOfString:@"."];
    if (_tempString && _tempString.length > 0)
    {
        // 输入
        if (docRange.location != NSNotFound)
        {
            // 有小数点
            textField.text = [NSString stringWithFormat:@"%@%@",_tempText,_tempString];
        }
        else
        {
            // 无小数点
            if ([_tempString isEqualToString:@"."])
            {
                // 是小数点
                textField.text = [NSString stringWithFormat:@"%@%@",_tempText,_tempString];
            }
            else
            {
                // 不是小数点
                textField.text = [NSString stringWithFormat:@"%ld",_tempText.integerValue * 10 + _tempString.integerValue];
            }
        }
    }
    else
    {
        // 删除
        textField.text = [_tempText substringToIndex:_tempText.length - 1];
    }
    
    if (_limitDelegate && [_limitDelegate respondsToSelector:@selector(valueChange:)])
    {
        [_limitDelegate valueChange:sender];
    }
}

@end
