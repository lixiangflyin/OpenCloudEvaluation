//
//  LeftViewController.h
//  evaTeac
//
//  Created by admin  on 13-10-30.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
#import "IpSetViewController.h"

@interface LeftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *leftTableView;
@property (strong, nonatomic) NSArray *listItem;
@property (strong, nonatomic) NSArray *setInfo;

@end
