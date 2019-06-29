//
//  PriceInputLimitTextField.h
//  Sale_app
//
//  Created by targetios on 2018/9/3.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EDPriceTextFieldLimit;

@interface PriceInputLimitTextField : UITextField

- (EDPriceTextFieldLimit *)limit;

@end

@protocol EDPriceTextFieldLimitDelegate;

@interface EDPriceTextFieldLimit : NSObject <UITextFieldDelegate>

@property (nonatomic, assign) id <EDPriceTextFieldLimitDelegate> limitDelegate;
@property (nonatomic, strong) NSString *max; // 默认99999.99

- (void)valueChange:(id)sender;

@end

@protocol EDPriceTextFieldLimitDelegate <NSObject>

- (void)valueChange:(id)sender;

@end
