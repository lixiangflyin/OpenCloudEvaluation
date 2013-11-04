//
//  LoginViewController.m
//  evaTeac
//
//  Created by admin  on 13-10-29.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "LoginViewController.h"
#import "CourseViewController.h"

@interface LoginViewController ()

-(void) GetErr:(ASIHTTPRequest *)request;
-(void) GetResult:(ASIHTTPRequest *)request;
//判断是否为空
-(BOOL) isEmptyOrNull:(NSString*)str;

@end

@implementation LoginViewController
@synthesize nameFld, psdFld;
@synthesize mDelegate;
@synthesize HUD;
@synthesize revealSideViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
//    UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backgroundBtn.frame = CGRectMake(0, 0, 320, 416);
//    [backgroundBtn setTitle: @"" forState:UIControlStateNormal];
//    [backgroundBtn setBackgroundColor:[UIColor clearColor]];
//    [backgroundBtn addTarget:self action:@selector(tapBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:backgroundBtn atIndex:4];
    
    nameFld.delegate = self;
    psdFld.delegate = self;
    psdFld.secureTextEntry = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma textField delegate ---about textfield

//check wether keyboard shelter from textfield when editing
- (void) moveViewWhenTxtFldHidden:(UITextField *)txtFld
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder = nil;
    [self moveViewWhenTxtFldHidden:textField];
}


- (IBAction)login:(id)sender {
    
    if(nameFld.text == nil || psdFld.text ==nil || [nameFld.text isEqualToString:@""] || [psdFld.text isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户名或密码为空";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
        return;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.labelText = @"登录中...";
	[HUD show:YES];

    NSMutableString *urlstr = [COMMON_API mutableCopy];
    [urlstr appendFormat:@"/login/%@", nameFld.text];
    //[urlstr appendFormat:@"&pass=%@",psdFld.text];
    
	NSURL *myurl = [NSURL URLWithString:urlstr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:myurl];
	//设置表单提交项
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(GetResult:)];
	[request setDidFailSelector:@selector(GetErr:)];
	[request startAsynchronous];

}

- (IBAction)tapBack:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//获取请求结果
- (void)GetResult:(ASIHTTPRequest *)request
{
    NSData *data =[request responseData];
    NSArray *array = [[CJSONDeserializer deserializer] deserializeAsArray: data error:nil];  //不能用
    //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];    //原生态
    //输出接收到的字符串
	//NSString *str = [NSString stringWithUTF8String:[data bytes]];

    //提示框消失
    [HUD removeFromSuperview];
    
    //判断是否登陆成功
    NSDictionary *dic = [array objectAtIndex:0];
    if ([[dic objectForKey:@"success"]boolValue] == YES)
    {
        [mDelegate LoginSuccess];  //委托实现
        
        NSDictionary *dictionary = [array objectAtIndex:1];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:nameFld.text forKey:@"id"];
        [defaults setValue:psdFld.text forKey:@"pwd"];
        [defaults setBool:YES forKey:@"isLogined"];
        [defaults setValue:[dictionary objectForKey:@"title"] forKey:@"title"];
        
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登陆成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
        CourseViewController *course = [[CourseViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:course];
        revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
        revealSideViewController.delegate = self;
        
        //表示可以手势滑动
        [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
        
        revealSideViewController.modalTransitionStyle = UIModalPresentationPageSheet;
        [self presentViewController:revealSideViewController animated:YES completion:nil];
        
		return;
    }
    else
    {
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"输入的账户信息有误";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
		return;
	}
}

//连接错误调用这个函数
- (void) GetErr:(ASIHTTPRequest *)request{
    
    [HUD removeFromSuperview];
    //[tooles MsgBox:@"网络错误,连接不到服务器"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"网络错误,连接不到服务器";
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

//登陆成功写入plist文件
-(void)LoginSuccess
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:@"lixiang" forKey:@"UserName"];
    [defaults setValue:@"122378" forKey:@"UserID"];
    [defaults setBool:YES forKey:@"isLogined"];
    
    BOOL test = [defaults boolForKey:@"isLogined"];
    NSLog(@"test=%d",test);
    /*
     NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
     [data setObject:@"YES" forKey:@"isLogined"];
     NSLog(@"%@",data);
     
     NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
     NSString *documentDirectory = [path objectAtIndex:0];
     NSLog(@"%@",path);
     NSString *plistPath = [documentDirectory stringByAppendingPathComponent:@"myInfo.plist"];
     NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
     if(dic == nil)
     {
     NSFileManager *fm = [NSFileManager defaultManager];
     [fm createFileAtPath:plistPath contents:nil attributes:nil];
     }
     else
     {
     }
     
     [data writeToFile:plistPath atomically:YES];
     
     NSMutableDictionary *data1 = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
     NSLog(@"%@",data1);
     */
}

//判断是否字符串为空
-(BOOL) isEmptyOrNull:(NSString*)str
{
    if (str == nil)
        return YES;
    if(str == NULL)
        return YES;
    NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([trimedString length] == 0)
        return YES;
    return FALSE;
}
@end
