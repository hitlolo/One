//
//  ONEMonthPickerController.h
//  One
//
//  Created by Lolo on 16/4/20.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ONEMonthPickerDelegate;
@interface ONEMonthPickerController : UIViewController

@property(nonatomic, assign)ONEContentType contentType;
@property(nonatomic, weak)id<ONEMonthPickerDelegate> delegate;
@end

@protocol ONEMonthPickerDelegate <NSObject>

- (void)monthPickerController:(ONEMonthPickerController*)monthPicker didSelectedDate:(NSString*)selectedDate;
@end
