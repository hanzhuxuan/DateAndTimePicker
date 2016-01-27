//
//  DateAndTimePickerView.m
//  时间选择器
//
//  Created by aj on 15/10/27.
//  Copyright (c) 2015年 1. All rights reserved.
//

#define ColumnTitleH      25  // 年月日的高度
#define CustomPickerH     180 // picker的高度
#define ViewCancelDoneH   44  //取消和确定的高度

#define currentMonth [currentMonthString integerValue]
#define DEFAULT_FONT  @"STHeitiSC-Light"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "DateAndTimePickerView.h"

@interface DateAndTimePickerView() <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    NSMutableArray *secondsArray;
    
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
}

@property (nonatomic, strong)UIView *viewCancelDone;
@property (nonatomic, strong)UIView *viewColumnTitle;
@property (nonatomic, strong)UIPickerView *customPicker;

@end
@implementation DateAndTimePickerView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        selectedMonthRow = -1;
        // PickerView -  Years data
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy"];
//        NSString *endYear = [dateFormatter stringFromDate:[NSDate date]];
////        [dateFormatter setDateFormat:@"MM"];
////        NSString *endYue = [dateFormatter stringFromDate:[NSDate date]];
////        [dateFormatter setDateFormat:@"dd"];
////        NSString *endDay = [dateFormatter stringFromDate:[NSDate date]];
////        int intDay = [endDay intValue];
////        int intYue = [endYue intValue];
//        int intYear = [endYear intValue];
//        
        
        yearArray = [[NSMutableArray alloc] init];
        for (int i = 1976; i <= 2099 ; i++)
        {
            [yearArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        // PickerView -  Months data
        monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
        
        // PickerView -  days data
        DaysArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 31; i++)
        {
            [DaysArray addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        
        // PickerView -  Hours data
        hoursArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",
                       @"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00"];
        
        // PickerView -  Hours data
        minutesArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 60; i++)
        {
            [minutesArray addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        
        // PickerView -  Seconds data
        secondsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 60; i++)
        {
            [secondsArray addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    return self;
}

- (UIView *)viewColumnTitle
{
    if (!_viewColumnTitle)
    {
        CGFloat FONTSIZE;
        if (self.isNeedHour) {
            FONTSIZE = 18;
        }
        else
        {
            FONTSIZE = 20;
        }
        _viewColumnTitle = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-CustomPickerH-ColumnTitleH, self.width, ColumnTitleH)];
        _viewColumnTitle.backgroundColor = [UIColor whiteColor];
        
        CGFloat widthLab;
        if (self.isNeedHour) {
            widthLab = self.width/4;
        }
        else
        {
            widthLab = self.width/3;
        }
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthLab, ColumnTitleH)];
        lbl.font = [UIFont fontWithName:DEFAULT_FONT size:FONTSIZE];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"年";
        [_viewColumnTitle addSubview:lbl];
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(widthLab, 0, widthLab, ColumnTitleH)];
        lbl.font = [UIFont fontWithName:DEFAULT_FONT size:FONTSIZE];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"月";
        [_viewColumnTitle addSubview:lbl];
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(widthLab*2, 0, widthLab, ColumnTitleH)];
        lbl.font = [UIFont fontWithName:DEFAULT_FONT size:FONTSIZE];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"日";
        [_viewColumnTitle addSubview:lbl];
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(widthLab*3, 0, widthLab, ColumnTitleH)];
        lbl.font = [UIFont fontWithName:DEFAULT_FONT size:FONTSIZE];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"时";
        if (self.isNeedHour) {
            [_viewColumnTitle addSubview:lbl];
        }
        
//        lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width*4/5, 0, self.width/5, ColumnTitleH)];
//        lbl.font = [UIFont fontWithName:DEFAULT_FONT size:15.0];
//        lbl.textAlignment = NSTextAlignmentCenter;
//        lbl.text = @"分";
//        [_viewColumnTitle addSubview:lbl];
        
//        lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width*5/6, 0, self.width/6, ColumnTitleH)];
//        lbl.font = [UIFont fontWithName:DEFAULT_FONT size:15.0];
//        lbl.textAlignment = NSTextAlignmentCenter;
//        lbl.text = @"秒";
//        [_viewColumnTitle addSubview:lbl];
    }
    return _viewColumnTitle;
}

- (UIView *)viewCancelDone
{
    if (!_viewCancelDone)
    {
        CGFloat FONTSIZE;
        if (self.isNeedHour) {
            FONTSIZE = 18;
        }
        else
        {
            FONTSIZE = 20;
        }
        _viewCancelDone = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-CustomPickerH-ColumnTitleH- ViewCancelDoneH, self.width, ViewCancelDoneH)];
        _viewCancelDone.backgroundColor = [UIColor whiteColor];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(self.width-10-50, 7, 50, 30);
        confirmBtn.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:FONTSIZE];
        [confirmBtn setTitleColor:UIColorFromRGB(0X0079FF) forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self
                       action:@selector(confirm)
             forControlEvents:UIControlEventTouchUpInside];
        [_viewCancelDone addSubview:confirmBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(10, 7, 50, 30);
        cancelBtn.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:FONTSIZE];
        [cancelBtn setTitleColor:UIColorFromRGB(0X0079FF) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self
                      action:@selector(cancel)
            forControlEvents:UIControlEventTouchUpInside];
        [_viewCancelDone addSubview:cancelBtn];
    }
    
    return _viewCancelDone;
}

- (UIPickerView *)customPicker
{
    if (!_customPicker)
    {
        _customPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.height-CustomPickerH, self.width, CustomPickerH)];
        _customPicker.backgroundColor = [UIColor whiteColor];
        _customPicker.delegate = self;
        _customPicker.dataSource = self;
    }
    return _customPicker;
}

- (void)drawRect:(CGRect)rect
{
    firstTimeLoad = YES;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Get Current Year
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYearString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current Month
    [formatter setDateFormat:@"MM"];
    currentMonthString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current  Hour
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current  Minutes
//    [formatter setDateFormat:@"mm"];
//    NSString *currentMinutesString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current  Seconds
//    [formatter setDateFormat:@"ss"];
//    NSString *currentSecondsString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // PickerView - Default Selection as per current Date
    [self.customPicker selectRow:[yearArray indexOfObject:currentYearString] inComponent:0 animated:YES];
    [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    [self.customPicker selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    
    if (self.isNeedHour) {
        [self.customPicker selectRow:[hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
    }
    
//    [self.customPicker selectRow:[minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
//    [self.customPicker selectRow:[secondsArray indexOfObject:currentSecondsString] inComponent:5 animated:YES];
    
    [self addSubview:self.viewCancelDone];
    [self addSubview:self.viewColumnTitle];
    [self addSubview:self.customPicker];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadComponent:1];
        [self.customPicker reloadComponent:2];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadComponent:2];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
    }
}

#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
        CGFloat FONTSIZE;
        if (self.isNeedHour) {
            FONTSIZE = 18;
        }
        else
        {
            FONTSIZE = 20;
        }
        pickerLabel.font = [UIFont fontWithName:DEFAULT_FONT size:FONTSIZE];
    }
    
    if (component == 0)
    {
        pickerLabel.text = [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text = [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text = [DaysArray objectAtIndex:row]; // Date
    }
    else if (component == 3)
    {
        pickerLabel.text = [hoursArray objectAtIndex:row]; // Hours
    }
//    else if (component == 4)
//    {
//        pickerLabel.text = [minutesArray objectAtIndex:row]; // Mins
//    }
//    else
//    {
//        pickerLabel.text = [secondsArray objectAtIndex:row]; // Mins
//    }
    
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.isNeedHour) {
        return 4;
    }
    else
    {
        return 3;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [yearArray count];
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    { // day
        if (firstTimeLoad)
        {
            firstTimeLoad = NO;
            selectedMonthRow = currentMonth - 1;
            if (currentMonth == 1 || currentMonth == 3
                || currentMonth == 5 || currentMonth == 7
                || currentMonth == 8 || currentMonth == 10
                || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                NSInteger yearint = [[yearArray objectAtIndex:selectedYearRow] integerValue];
                
                if(((yearint % 4 == 0) && (yearint % 100 != 0))
                   ||(yearint % 400 == 0))
                {
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
        else
        {
            if (selectedMonthRow == 0 || selectedMonthRow == 2
                || selectedMonthRow == 4 || selectedMonthRow == 6
                || selectedMonthRow == 7 || selectedMonthRow == 9
                || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                NSInteger yearint = [[yearArray objectAtIndex:selectedYearRow] intValue];
                
                if(((yearint % 4 == 0) && (yearint % 100 != 0))
                   ||(yearint % 400 == 0))
                {
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
    }
    else if (component == 3)
    { // hour
        return 24;
    }
    else
    { // min
        return 60;
    }
}

- (void)cancel
{
    [self.delegate cancelDateAndTime];
}

- (void)confirm
{
    NSString *formatTime = nil;
    if (self.isNeedHour) {
        formatTime = [NSString stringWithFormat:@"%@-%@-%@ %@:00",
                      [yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],
                      [monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],
                      [DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]],
                      [hoursArray objectAtIndex:[self.customPicker selectedRowInComponent:3]]
                      //                            [minutesArray objectAtIndex:[self.customPicker selectedRowInComponent:4]]
                      ];
    }
    else
    {
        formatTime = [NSString stringWithFormat:@"%@-%@-%@",
                      [yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],
                      [monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],
                      [DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]
                      ];
    }
   
    [self.delegate confirmDateAndTime:formatTime withIndexPath:self.indexPath];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
