//
//  PhoneCapchaButton.h
//  Sale_app
//
//  Created by eddy on 2018/1/4.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCapchaButton : UIButton

- (void)startTimer;
- (void)invalidateTimer;

//倒计时是否结束
- (BOOL)countDownOver;

@end
