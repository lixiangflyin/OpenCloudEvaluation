//
//  IpSetViewController.h
//  evaTeac
//
//  Created by admin  on 13-11-10.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IpSetViewController : UIViewController<UITextFieldDelegate>

@property(strong, nonatomic) UITextField *ipTxt;
//此处代理变量用来回调方法所用
@property (nonatomic, assign) id mDelegate;

@end
