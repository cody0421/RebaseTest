//
//  ViewController.m
//  12345
//
//  Created by Cody on 2017/8/15.
//  Copyright © 2017年 hotBear. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dateText;

@end

@implementation ViewController
- (IBAction)commitAction:(id)sender {
    
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate * date = [formatter dateFromString:_dateText.text];
    
    NSDate * d = [self getWorkdayWithCurrentDate:date postponeDay:1];
    
    NSString * s = [formatter stringFromDate:d];
    
    NSLog(@"%@",s);

}

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSArray * arr = @[@{@"number":@"12"},
//                      @{@"number":@"13"},
//                      @{@"number":@"14"},
//                      @{@"number":@"15"},
//                      @{@"number":@"16"},
//                      @{@"number":@"17"},
//                      @{@"number":@"12"},];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.number IN %@)", @[@"12",@"13"]];
//    NSArray  * aa = [arr filteredArrayUsingPredicate:predicate];
//    
//    NSLog(@"%@",aa);
    
    
    
}

//节假日顺延天数后第几个交易日(postponeDay = 0 表示第一个交易日,依次类推)
- (NSDate *)getWorkdayWithCurrentDate:(NSDate *)currentDate  postponeDay:(NSInteger)postponeDay{
    BOOL isHolidays = [self isFestival:currentDate];
    
    if (!isHolidays) {//不是节假日就直接返回是了
        return currentDate;
    }else{
    
        NSInteger addDay = 1;
        NSDate * mDate;
        while (isHolidays) {
            mDate = [self getPriousDateFromDate:currentDate withDay:addDay];
            isHolidays = [self isFestival:mDate];
            addDay ++;
        }
        
        //添加顺延天数
        mDate = [self getPriousDateFromDate:mDate withDay:postponeDay];
        
        return mDate;
        
    }
    
    
}

//判断是否为节假日
- (BOOL)isFestival:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags =  NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    //判断是否为周末
    if (comps.weekday == 7 || comps.weekday == 1) {
        return YES;
    }
    
    //判断是否为公历节日(劳动节、国庆节、元旦节、清明节)
    NSArray * gregorianHolidays = @[@"0501",//劳动节
                                   @"1001",@"1002",@"1003",@"1004",@"1005",@"1006",@"1007",//国庆节
                                   @"0101",//元旦
                                   @"0404"//清明
                                   ];
    NSString * gregorianDateString = [NSString stringWithFormat:@"%02ld%02ld",comps.month,comps.day];;
    BOOL isContain = [gregorianHolidays containsObject:gregorianDateString];
    
    if (isContain) {
        return YES;
    }
    
    
    //判断是否为农历节日(端午节、春节、中秋节)
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned chineseUnitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:chineseUnitFlags fromDate:date];
    NSString * chineseDateString = [NSString stringWithFormat:@"%02ld%02ld",localeComp.month,localeComp.day];
    
    NSArray * chineseHolidays = @[@"0505",//端午
                                 @"1230",@"0101",@"0102",@"0103",@"0104",@"0105",@"0106",//春节
                                 @"0815"//中秋节
                                 ];
      isContain = [chineseHolidays containsObject:chineseDateString];
    
    if (isContain) {
        return YES;
    }
    
    return NO;

}

//时间穿梭机 (+-天数)
-(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
