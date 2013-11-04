//
//  SettingViewController.h
//  evaTeac
//
//  Created by admin  on 13-10-31.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol SettingViewControllerDelegate <NSObject>
-(void)logout;
@end

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (strong, nonatomic) UITableView *settingTableView;

@property(nonatomic, strong) id mDelegate;

@end
