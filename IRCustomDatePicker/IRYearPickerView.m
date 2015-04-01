//
//  IRYearPickerView.m
//  IRCustomDatePicker
//
//  Created by Hijazi on 28/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "IRYearPickerView.h"

@implementation IRYearPickerView

#define YEAR_FROM 2005

- (void)awakeFromNib{
    [super awakeFromNib];

    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    if (!self.minYear){
        self.minYear = YEAR_FROM;
    }
    
    //Create Years Array from 1960 to This year
    _years = [[NSMutableArray alloc] init];
    for (int i=YEAR_FROM; i<=i2; i++) {
        [self.years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.dataSource = self;
    self.delegate = self;

    
    [self selectRow:([self.years count]-1) inComponent:0 animated:NO];

}


-(NSDate *)date
{

    
    NSInteger yearCount = [self.years count];
    NSString *year = self.years[([self selectedRowInComponent:0] % yearCount)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"yyyy"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@", year]];
    
    return date;
}

- (void) setDate:(NSDate *)aDate{
    [self setDate:aDate animated:NO];
}

- (void) setDate:(NSDate *)aDate animated:(BOOL)animated{
    
    NSInteger dateYear;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:aDate];

    components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    dateYear = [components year];
    
 
    NSInteger rowIndex = dateYear - self.minYear;
    if (rowIndex < 0) {
        rowIndex = 0;
    }
    
    [self selectRow: rowIndex
        inComponent: 0
           animated: animated];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.years count];
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.years[row];

}

@end
