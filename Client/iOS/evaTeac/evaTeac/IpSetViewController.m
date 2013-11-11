//
//  IpSetViewController.m
//  evaTeac
//
//  Created by admin  on 13-11-10.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "IpSetViewController.h"
#import "MBProgressHUD.h"

@interface IpSetViewController ()

@end

@implementation IpSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设定IP";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	CGRect rect = [[UIScreen mainScreen] bounds];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIButton *backGround = [UIButton buttonWithType:UIButtonTypeCustom];
    backGround.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-44);
    [backGround setTitle: @"" forState:UIControlStateNormal];
    //[backGround setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backGround addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backGround];
    
    _ipTxt = [[UITextField alloc]initWithFrame:CGRectMake(20, 32, 280, 28)];
    [_ipTxt setBorderStyle:UITextBorderStyleBezel];
    _ipTxt.delegate = self;
    [_ipTxt setTextColor:[UIColor blackColor]];
    [_ipTxt setFont:[UIFont fontWithName:@"Arial" size:17]];
    [_ipTxt setPlaceholder:@"223.3.98.209"];
    [self.view addSubview:_ipTxt];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureBtn.frame = CGRectMake(20, 80, 280, 38);
    [sureBtn setTitle: @"确定" forState:UIControlStateNormal];
    //[sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(setIp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clicked
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//搞成单例模式
+ (BOOL)isValidatIP:(NSString *)ipAddress{
    
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    
    return NO;
}

-(void)setIp
{
    if(_ipTxt.text == nil)
        return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ip = [NSString stringWithFormat:@"http://%@:8080",_ipTxt.text];
    [defaults setObject:ip forKey:@"ipAddress"];
    
    if([IpSetViewController isValidatIP:_ipTxt.text]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"设置成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"IP格式错误";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
