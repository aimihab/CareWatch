//
//  NSDate+Expend.h
//  BodyScaleBLE
//
//  Created by Jason on 13-1-30.
//  Copyright (c) 2013年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Expend)

+(int)getDaysFrom1970:(NSString*)dateString;
+(NSDate *)getDateByDayPassedFrom1970:(int)passDays;
+(NSDate *)getDateByTimePassedFrom1970:(long long)passTime;
+(int)getCurrentYear;
+(int)getCurrentMonth;
+(int)getCurrentDay;
+(int)getCurrentHour;
+(int)getCurrentMin;
+(int)getCurrentSecond;
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;
+(NSDate*)convertDateFromString:(NSString*)uiDate;
+(NSDate*)preDay:(NSDate*)nowDate Days:(int)dayLength;
+(NSDate*)nextDay:(NSDate*)nowDate Days:(int)dayLength;
+(NSUInteger)getWeekdayFromDate:(NSDate*)date;


-(int)getYear;
-(int)getMon;
-(int)getDay;
-(int)getHour;
-(int)getMin;
-(int)getSecond;

-(int)getGeoYear;
-(int)getGeoMon;
-(int)getGeoDay;
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;
- (BOOL)sameWeekWithDate:(NSDate *)otherDate;
+(NSString*)getEngMon:(int)monNum;
+ (NSString *)getStringWithFormat:(NSString *)format andDate:(NSDate *)date;


//获取每月的天数
+(NSInteger )getDayWithYear:(NSNumber *)year month:(NSNumber *)month;
//判断是否闰年
+(BOOL)isLeapYear:(NSNumber *)year;

@end
