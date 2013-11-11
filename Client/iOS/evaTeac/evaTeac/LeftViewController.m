//
//  LeftViewController.m
//  evaTeac
//
//  Created by admin  on 13-10-30.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "LeftViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CourseViewController.h"
#import "SettingViewController.h"
#import "GHMenuCell.h"

@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize leftTableView, listItem, setInfo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 20, rect.size.width, rect.size.height)];
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.view.backgroundColor = bgColor;
    
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 6, 250, 32)];
    idLabel.textColor = [UIColor whiteColor];
    idLabel.textAlignment = NSTextAlignmentLeft;
    idLabel.backgroundColor = [UIColor clearColor];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *title = [defaults valueForKey:@"title"];
    if([title isEqualToString:@"teacher"])
        idLabel.text = @"当前身份：教师";
    else if([title isEqualToString:@"master"])
        idLabel.text = @"当前身份：督导";
    else
        idLabel.text = @"当前身份：学生";
    [self.view addSubview:idLabel];
    
    //创建tableview
    leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 460-44) style: UITableViewStylePlain];
    leftTableView.scrollEnabled = YES;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:leftTableView];
    
    //获取数据
    listItem = [[NSArray alloc]initWithObjects:@"我的评教",@"个人信息", nil];
    setInfo = [[NSArray alloc]initWithObjects:@"设置",@"设定IP", nil];
    [self setExtraCellLineHidden:self.leftTableView];
}

//tableView隐藏多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [listItem count];
    }
    else
    {
        return [setInfo count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 21.0f;
    }
    else
        return 21.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSObject *headerText;
    if(section == 0)
        headerText = @"我的信息";
    if(section == 1)
        headerText = @"其它信息";
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = headerView.bounds;
		gradient.colors = @[
                      (id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
                      (id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
                      ];
		[headerView.layer insertSublayer:gradient atIndex:0];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.9f)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
		[headerView addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f];
		[headerView addSubview:bottomLine];
	}
	return headerView;
}


/*
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 40;
 }
 */
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GHMenuCell";
    GHMenuCell *cell = (GHMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    if ([indexPath section] == 0)
    {
        cell.textLabel.text = [self.listItem objectAtIndex:row];
    }
    if ([indexPath section] == 1)
    {
        cell.textLabel.text = [self.setInfo objectAtIndex:row];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger row = [indexPath row];
    if ([indexPath section] == 0){
        if (row == 0) {
            CourseViewController *centerController = [[CourseViewController alloc]init];
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:centerController];
            //[nav setNavigationBarHidden:YES];
            [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
        }

    }
    else if ([indexPath section] == 1)
    {
        if (row == 0) {
            SettingViewController *setting = [[SettingViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setting];
            //setting.mDelegate = self;
            [self presentViewController:nav animated:YES completion:nil];
        }
        if (row == 1) {
            IpSetViewController *ipset = [[IpSetViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ipset];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }

}
@end
