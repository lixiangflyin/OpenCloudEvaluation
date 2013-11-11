//
//  DetailInfoCell.h
//  mainSearchView
//
//  Created by admin  on 13-7-6.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInfoCell : UITableViewCell

@property (strong, nonatomic) UILabel *item;
@property (strong, nonatomic) UILabel *content;

-(void) resizeTheHeight;
@end
