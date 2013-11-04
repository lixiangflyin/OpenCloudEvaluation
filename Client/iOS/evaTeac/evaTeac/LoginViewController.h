//
//  LoginViewController.h
//  evaTeac
//
//  Created by admin  on 13-10-29.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpHeaders.h"
#import "CJSONDeserializer.h"
#import "MBProgressHUD.h"
#import "PPRevealSideViewController.h"


@protocol LoginViewControllerDelegate <NSObject>
-(void)LoginSuccess;
@end

@interface LoginViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate,PPRevealSideViewControllerDelegate>

@property(nonatomic, assign)id<LoginViewControllerDelegate> mDelegate;

@property (strong, nonatomic) IBOutlet UITextField *nameFld;
@property (strong, nonatomic) IBOutlet UITextField *psdFld;
@property (strong, nonatomic) IBOutlet UIToolbar *loginBar;
- (IBAction)login:(id)sender;
- (IBAction)tapBack:(id)sender;

@property (retain, nonatomic) MBProgressHUD *HUD;

@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@end
