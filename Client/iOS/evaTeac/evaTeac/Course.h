//
//  Course.h
//  evaTeac
//
//  Created by admin  on 13-11-4.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (strong, nonatomic) NSString *teacher_id;
@property (strong, nonatomic) NSString *teacher_name;
@property (strong, nonatomic) NSString *room;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *course_id;

- (id)initWithCourseDictionary:(NSDictionary *)dictionary;
+(NSString *)getAddress:(Course *)course;

@end
