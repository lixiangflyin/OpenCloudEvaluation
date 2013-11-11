//
//  DetailViewController.m
//  evaTeac
//
//  Created by admin  on 13-11-11.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailInfoCell.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _course.title;
    self.view.backgroundColor = [UIColor whiteColor];
	//CGRect rect = [[UIScreen mainScreen] bounds];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    [self setExtraCellLineHidden:self.tableView];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIView *aView = [[UIView alloc]initWithFrame:cell.contentView.frame];
        aView.backgroundColor = [UIColor greenColor];
        cell.selectedBackgroundView = aView;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    NSInteger cellNum = indexPath.row;
    switch (cellNum) {
        case 0:
            cell.item.text = @"教师编号";
            cell.content.text = _course.teacher_id;
            cell.selectionStyle = UITableViewCellAccessoryNone;
            //[cell resizeTheHeight];
            return cell;
            break;
        case 1:
            cell.item.text = @"教师姓名";
            cell.content.text = _course.teacher_name;
            cell.selectionStyle = UITableViewCellAccessoryNone;
            //[cell resizeTheHeight];
            return cell;
            break;
        case 2:
            cell.item.text = @"上课地点";
            cell.content.text = _course.room;
            cell.selectionStyle = UITableViewCellAccessoryNone;
            //[cell resizeTheHeight];
            return cell;
            break;
        case 3:
            cell.item.text = @"上课时间";
            cell.content.text = _course.time;
            cell.selectionStyle = UITableViewCellAccessoryNone;
            [cell resizeTheHeight];
            return cell;
            break;
        case 4:
            cell.item.text = @"上课日期";
            cell.content.text = _course.date;  //工作地点
            cell.selectionStyle = UITableViewCellAccessoryNone;
            //[cell resizeTheHeight];
            return cell;
            break;
        case 5:
            cell.item.text = @"课程编号";
            cell.content.text = _course.course_id;
            //[cell resizeTheHeight];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            return cell;
            break;
        default:
            break;
    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
