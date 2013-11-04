//
//  Course.m
//  evaTeac
//
//  Created by admin  on 13-11-4.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "Course.h"

@implementation Course

- (id)initWithCourseDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.teacher_id = [dictionary objectForKey:@"teacher_id"];
        self.teacher_name = [dictionary objectForKey:@"teacher_name"];
        self.room = [dictionary objectForKey:@"room"];
        self.title = [dictionary objectForKey:@"title"];
        self.time = [dictionary objectForKey:@"time"];
        self.date = [dictionary objectForKey:@"date"];
        self.course_id = [dictionary objectForKey:@"course_id"];
    }
    
    return self;
}

+(NSString *)getAddress:(Course *)course
{
    return [NSString stringWithFormat:@"%@第%@%@",course.date,course.time,course.room];
}

- (void)dealloc
{
    _teacher_id = nil;
    _teacher_name = nil;
    _room = nil;
    _title = nil;
    _time = nil;
    _date = nil;
    _course_id = nil;
}


@end
