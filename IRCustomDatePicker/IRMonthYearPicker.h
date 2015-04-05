//
//
//  Created by Evgeny Yagrushkin on 2012-08-15.
//  Copyright (c) 2012 Evgeny Yagrushkin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIMonthYearPickerValueChangeBlock)(NSDate *newDate);

@protocol UIMonthYearPickerDelegate

@optional
- (void)pickerView:(UIPickerView *)pickerView didChangeDate:(NSDate*)newDate;
@end

@interface IRMonthYearPicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id _delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

//NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ms"];
//[dateFormatter setLocale:locale];
@property (strong, nonatomic) NSLocale *locale;

@property (assign) NSInteger minYear;



- (void)selectToday;

@end
