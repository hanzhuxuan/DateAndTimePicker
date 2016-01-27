//
//  DateAndTimePickerView.h
//  时间选择器
//
//  Created by aj on 15/10/27.
//  Copyright (c) 2015年 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateAndTimePickerViewDelegate <NSObject>
@optional
- (void)confirmDateAndTime:(NSString *)time withIndexPath:(NSIndexPath *)indexPath;
- (void)cancelDateAndTime;
@end
@interface DateAndTimePickerView : UIView
@property (nonatomic, strong)id delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isNeedHour;

@end
