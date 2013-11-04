//
//  CourseViewController.h
//  courseSwipe
//
//  Created by admin  on 13-10-28.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHttpHeaders.h"
#import "CJSONDeserializer.h"


@interface CourseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIHTTPRequest *asiRequest;

@property(strong, nonatomic) UITableView *courseTableView;
@property(strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (retain, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic) BOOL reloading;

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;

//私有变量
-(void) GetErr:(ASIHTTPRequest *)request;
-(void) GetResult:(ASIHTTPRequest *)request;
@end
