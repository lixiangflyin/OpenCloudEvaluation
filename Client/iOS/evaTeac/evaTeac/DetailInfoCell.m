//
//  DetailInfoCell.m
//  mainSearchView
//
//  Created by admin  on 13-7-6.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "DetailInfoCell.h"

@implementation DetailInfoCell
@synthesize item;
@synthesize content;

-(void)dealloc
{
    item = nil;
    content = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        item = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, 80, 35)];
        item.text = @"职位详情:";
        [item setFont:[UIFont fontWithName:@"Arial" size:17]];
        item.textColor = [UIColor blackColor];
        item.textAlignment = NSTextAlignmentRight;
        item.backgroundColor = [UIColor clearColor];
        
        content = [[UILabel alloc]initWithFrame:CGRectMake(95, 7, 200, 35)];
        content.text = @"职位数据";
        [content setFont:[UIFont fontWithName:@"Arial" size:17]];
        content.textColor = [UIColor blackColor];
        content.textAlignment = NSTextAlignmentLeft;
        content.numberOfLines = 0;
        content.backgroundColor = [UIColor clearColor];
        
        [self addSubview:item];
        [self addSubview:content];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) resizeTheHeight
{
    CGFloat contentWidth = 200;
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:17];
    
    CGSize size = [content.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    [content setFrame:CGRectMake(95, 13, 210, size.height)];
    
    
}
@end
