//
//  ViewController.h
//  IRCustomDatePicker
//
//  Created by Hijazi on 28/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRYearPickerView.h"
#import "IRMonthYearPicker.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *std_datePicker;
@property (weak, nonatomic) IBOutlet IRYearPickerView *year_picker;
@property (weak, nonatomic) IBOutlet IRMonthYearPicker *month_yearPicker;

@end

