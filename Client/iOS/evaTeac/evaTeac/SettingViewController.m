//
//  SettingViewController.m
//  evaTeac
//
//  Created by admin  on 13-10-31.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize settingTableView;
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
	//创建tableview
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44) style: UITableViewStyleGrouped];
    settingTableView.scrollEnabled = YES;
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    //背景颜色
    //UIImageView *tableBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44)];
    //[tableBack setImage:[UIImage imageNamed:@"paperbackground2.png"]];
    //[self.settingTableView setBackgroundView:tableBack];
    
    [self.view addSubview:self.settingTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    if(section == 1){
        return 1;
    }
    if (section == 2) {
        return 3;
    }
    if (section == 3) {
        return 1;
    }
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"当前用户";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17];
                    cell.detailTextLabel.font = cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    BOOL isLogined = [defaults boolForKey:@"isLogined"];
                    
                    if (isLogined == YES)
                        cell.detailTextLabel.text = [defaults objectForKey:@"id"];
                    else
                        cell.detailTextLabel.text = @"未登录";
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"消除缓存";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                }
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"意见反馈";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                }
                    
                case 1:
                {
                    cell.textLabel.text = @"打分微评教";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                }
                case 2:
                    cell.textLabel.text = @"关于微评教";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                default:
                    break;
            }
            break;
        case 3:
        {
            UIButton *logOutButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [logOutButton setFrame:CGRectMake(0, 0, 300, 47)];
            [logOutButton setImage:[UIImage imageNamed:@"LogOutNormal.png"] forState:UIControlStateNormal];
            [logOutButton setImage:[UIImage imageNamed:@"LogOutPress.png"] forState:UIControlStateHighlighted];
            [logOutButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setBackgroundView:logOutButton];
            [cell.contentView setHidden:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showActionSheet:(id)sender
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                 initWithTitle:@"确定登出微评教？"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:@"退出登录"
                                 otherButtonTitles:nil, nil];
    
    //actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"" forKey:@"id"];
        [defaults setValue:@"" forKey:@"pwd"];
        [defaults setBool:NO forKey:@"isLogined"];
        
        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        nav.modalTransitionStyle = UIModalPresentationFormSheet;
        AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appDele.window.rootViewController = nav;
        [self presentViewController:nav animated:YES completion:nil];
        
        //[mDelegate logout];
        //[self back:self];
    }
}

@end
