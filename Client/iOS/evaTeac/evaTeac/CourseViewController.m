//
//  CourseViewController.m
//  courseSwipe
//
//  Created by admin  on 13-10-28.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "CourseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MCSwipeTableViewCell.h"
#import "RNGridMenu.h"
#import "Course.h"
#import "LeftViewController.h"

typedef enum RequestStage
{
    ReloadingStage,
    AssessingStage,
} RequestStage;  //解析状态

@interface CourseViewController ()<MCSwipeTableViewCellDelegate,RNGridMenuDelegate>

@property (nonatomic) RequestStage signStage;
@property (nonatomic) int cellNumber;

@end

@implementation CourseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"评教";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(showLeft)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [_courseTableView setBackgroundView:backgroundView];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //[self.view insertSubview:HUD atIndex:0];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"载入中...";
	[_HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
}

-(void)firstTimeLoad
{
    //创建tableview
    _courseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44) style: UITableViewStylePlain];
    _courseTableView.delegate = self;
    _courseTableView.dataSource = self;
    //视图添加
    [self.view addSubview:_courseTableView];
    
    //实现下拉刷新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -self.courseTableView.frame.size.height, self.view.frame.size.width, self.courseTableView.frame.size.height)];
        view.delegate = self;
        
        [self.courseTableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];

    //以下三句可以换成这个函数
    _dataArr = [[NSMutableArray alloc]init];

    [self loadData];
}

-(void)loadData
{
    _signStage = ReloadingStage;  //请求标志
    NSMutableString *urlstr = [COMMON_API mutableCopy];
    [urlstr appendFormat:@"%@", @"/schedule/thisweek"];
    
	NSURL *myurl = [NSURL URLWithString:urlstr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:myurl];
	//设置表单提交项
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(GetResult:)];
	[request setDidFailSelector:@selector(GetErr:)];
	[request startAsynchronous];
}

#pragma mark -
#pragma mark Request Methods
//获取请求结果
- (void)GetResult:(ASIHTTPRequest *)request
{
    //提示框消失
    [_HUD removeFromSuperview];
    _HUD = nil;
    
    NSData *data =[request responseData];
    if(_signStage == ReloadingStage){
        
        NSArray *arr = [[CJSONDeserializer deserializer] deserializeAsArray:data error:nil];
        if ([arr count] > 0)
        {
            [_dataArr removeAllObjects];
//            //获取数据
//            NSURL *url = [[NSBundle mainBundle] URLForResource:@"course" withExtension:@"plist"];
//            _dataArr = [NSMutableArray arrayWithContentsOfURL:url];
            
            for(int i = 0; i < [arr count]; i++)
            {
                Course *course = [[Course alloc]initWithCourseDictionary:[arr objectAtIndex:i]];
                [_dataArr addObject:course];
                course = nil;
            }
            
            [_courseTableView reloadData];
            
        }
        
    }
    else if(_signStage == AssessingStage)
    {
        NSString *str = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
        if ([str length] > 0)
        {
            [self updateTableView];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"评教成功";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
    }

}

//连接错误调用这个函数
- (void) GetErr:(ASIHTTPRequest *)request{
    
    [_HUD removeFromSuperview];
    _HUD = nil;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"网络错误,连接不到服务器";
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

//修改评教后的显示
-(void)updateTableView
{
    NSIndexPath * index = [NSIndexPath indexPathForItem:_cellNumber inSection:0];
    MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *)[_courseTableView cellForRowAtIndexPath:index];
    
    Course *current = [_dataArr objectAtIndex:_cellNumber];

    for(UIView *label in [cell.contentView subviews]){
        if (label.tag == 1000) {
            
            [(UILabel *)label setText:current.title];
        }
        else if(label.tag == 1001) {
        
            [(UILabel *)label setText:current.teacher_name];
        }
        else if(label.tag == 1002) {
        
            [(UILabel *)label setText:[Course getAddress:current]];
        }
        else if(label.tag == 1003) {
        
            [(UILabel *)label setText:@"已评"];
            [(UILabel *)label setTextColor:[UIColor redColor]];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//重新加载时调用
-(void)reloadTableViewDataSource
{
    //NSLog(@"sdfasg");
    //[self.courseTableView reloadData];
    //reloading = YES;
    [self loadData];
}

//完成加载时调用
-(void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.courseTableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLeft
{
    LeftViewController *c = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    
    [self.revealSideViewController pushViewController:c onDirection:PPRevealSideDirectionLeft withOffset:70 animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIView *aView = [[UIView alloc]initWithFrame:cell.contentView.frame];
        aView.backgroundColor = [UIColor greenColor];
        cell.selectedBackgroundView = aView;
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    else{
        for(UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    [cell setDelegate:self];
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
            secondStateIconName:@"cross.png"
                    secondColor:[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
                  thirdIconName:@"clock.png"
                     thirdColor:[UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]
                 fourthIconName:@"list.png"
                    fourthColor:[UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0]];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:_courseTableView.backgroundView.backgroundColor];
    
    //
    //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Course *current = [_dataArr objectAtIndex:indexPath.row];
    [self modCell:cell withName:current.title course:current.teacher_name address:[Course getAddress:current]];
    
    cell.modeForState1 = MCSwipeTableViewCellModeSwitch;
    cell.modeForState2 = MCSwipeTableViewCellModeExit;
    cell.modeForState3 = MCSwipeTableViewCellModeSwitch;
    cell.modeForState4 = MCSwipeTableViewCellModeSwitch;
    
    return cell;
}

//自定义cell
-(void) modCell:(MCSwipeTableViewCell *) aCell withName:(NSString*)name course:(NSString *) course address:(NSString *) address
{
    //title
    UILabel *title1 =[[UILabel alloc] initWithFrame:CGRectMake(16,9,114,25)];
    [title1 setText:name];
    title1.tag = 1000;
    [title1 setTextAlignment:NSTextAlignmentLeft];
    [title1 setFont:[UIFont fontWithName:@"Helvetica" size:17.0f]];
    [title1 setTextColor:[UIColor blackColor]];
    [title1 setBackgroundColor:[UIColor clearColor]];
    
    //section
    UILabel *title2 =[[UILabel alloc] initWithFrame:CGRectMake(165,11,135,21)];
    [title2 setText:course];
    title2.tag = 1001;
    [title2 setTextAlignment:NSTextAlignmentRight];
    [title2 setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [title2 setTextColor:[UIColor lightGrayColor]];
    [title2 setBackgroundColor:[UIColor clearColor]];
    
    //time
    UILabel *title3 =[[UILabel alloc] initWithFrame:CGRectMake(16,41,234,27)];
    [title3 setText:address];
    title3.tag = 1002;
    [title3 setTextAlignment:NSTextAlignmentLeft];
    [title3 setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [title3 setTextColor:[UIColor lightGrayColor]];
    [title3 setBackgroundColor:[UIColor clearColor]];
    
    //time
    UILabel *title4 =[[UILabel alloc] initWithFrame:CGRectMake(258,44,42,21)];
    [title4 setText:@"未评"];
    title4.tag = 1003;
    [title4 setTextAlignment:NSTextAlignmentRight];
    [title4 setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [title4 setTextColor:[UIColor blackColor]];
    [title4 setBackgroundColor:[UIColor clearColor]];
    
    //add to cell
    [aCell.contentView addSubview:title1];
    [aCell.contentView addSubview:title2];
    [aCell.contentView addSubview:title3];
    [aCell.contentView addSubview:title4];
    title1 = nil;
    title2 = nil;
    title3 = nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //CourseViewController *tableViewController = [[CourseViewController alloc] init];
    //[self.navigationController pushViewController:tableViewController animated:YES];
}

#pragma mark - MCSwipeTableViewCellDelegate
// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
    NSLog(@"Did start swiping the cell!");
}

/*
 // When the user is dragging, this method is called and return the dragged percentage from the border
 - (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipWithPercentage:(CGFloat)percentage {
 NSLog(@"Did swipe with percentage : %f", percentage);
 }
 */

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode {
    NSLog(@"Did end swipping with IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [_courseTableView indexPathForCell:cell], state, mode);
    _cellNumber = [[_courseTableView indexPathForCell:cell] row];
    
    if (mode == MCSwipeTableViewCellModeExit) {
        [_dataArr removeObjectAtIndex:[[_courseTableView indexPathForCell:cell] row]];
        NSLog(@"%@",_dataArr);
        [_courseTableView deleteRowsAtIndexPaths:@[[_courseTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
        //[courseTableView reloadData];
        NSLog(@"delete sucess!");
    }
    else if(state == 1){
        NSLog(@"left 1");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知" message:@"你点中了左边第二个键，你可以实现其他功能！" delegate:nil cancelButtonTitle:@"很好，不错！" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
    else if(state == 3){
        NSLog(@"right 1");
        [self showGrid];
    }
    else if(state == 4){
        NSLog(@"right 2");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"评语"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"棒极啦！", @"挺不错的！", @"还行啦！", @"马马虎虎！", @"不好说啦！",  nil];
        [actionSheet showInView:self.view];
        actionSheet = nil;
    }

}

#pragma mark - RNGridMenuDelegate
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    
    Course *current = [_dataArr objectAtIndex:_cellNumber];
    
    _signStage = AssessingStage;
    NSMutableString *urlstr = [COMMON_API mutableCopy];
    [urlstr appendFormat:@"/evaluate/%@/%@/%@", current.course_id,item.title,@"good"];
    
	NSURL *myurl = [NSURL URLWithString:urlstr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:myurl];
	//设置表单提交项
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(GetResult:)];
	[request setDidFailSelector:@selector(GetErr:)];
	[request startAsynchronous];
}

#pragma mark - Private
- (void)showImagesOnly {
    NSInteger numberOfOptions = 5;
    NSArray *images = @[
                        [UIImage imageNamed:@"arrow"],
                        [UIImage imageNamed:@"attachment"],
                        [UIImage imageNamed:@"block"],
                        [UIImage imageNamed:@"bluetooth"],
                        [UIImage imageNamed:@"cube"],
                        [UIImage imageNamed:@"download"],
                        [UIImage imageNamed:@"enter"],
                        [UIImage imageNamed:@"file"],
                        [UIImage imageNamed:@"github"]
                        ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showList {
    NSInteger numberOfOptions = 5;
    NSArray *options = @[
                         @"0",
                         @"20",
                         @"40",
                         @"50",
                         @"60",
                         @"70",
                         @"80",
                         @"90",
                         @"100"
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGrid {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"0"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"20"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"40"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"50"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"60"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"70"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"80"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"90"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"100"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGridWithPath {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"Next"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

#pragma mark -
- (void)reload:(id)sender {
    [_courseTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
