//
//  IRYearPickerView.h
//  IRCustomDatePicker
//
//  Created by Hijazi on 28/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRYearPickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate> {
    

    
}
@property (assign) NSInteger minYear;
@property (strong, nonatomic) NSMutableArray *years;
@property (nonatomic, strong) NSDate *date;

@end
