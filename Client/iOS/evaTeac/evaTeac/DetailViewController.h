//
//  DetailViewController.h
//  evaTeac
//
//  Created by admin  on 13-11-11.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface DetailViewController : UITableViewController

@property(strong, nonatomic) Course *course;

@end
