//
//  Created by Evgeny Yagrushkin on 2012-08-15.
//  Copyright (c) 2012 Evgeny Yagrushkin. All rights reserved.
// TODO disable months for max and min years
// TODO return last date of the month date and last date, next last date
// TODO add to guthub
// TODO optional selection for the current month and date

#import "IRMonthYearPicker.h"

// Identifiers of components
#define MONTH ( 0 )
#define YEAR ( 1 )

// Identifies for component views
#define LABEL_TAG 43

@interface IRMonthYearPicker()

@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

-(NSArray *)nameOfYears;
-(NSArray *)nameOfMonths;
-(CGFloat)componentWidth;

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(NSIndexPath *)todayPath;
-(NSInteger)bigRowMonthCount;
-(NSInteger)bigRowYearCount;
-(NSString *)currentMonthName;
-(NSString *)currentYearName;

@end

@implementation IRMonthYearPicker

const NSInteger bigRowCount = 1;
NSInteger minYear;
NSInteger maxYear;
const CGFloat rowHeight = 30.f;
const NSInteger numberOfComponents = 2;

@synthesize todayIndexPath;
@synthesize months;
@synthesize years = _years;
@synthesize _delegate = _privateDelegate;
@synthesize maximumDate;
@synthesize minimumDate;

#define YEAR_FROM 2005

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    minYear = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]].year;
    if (self.minYear) {
        minYear = self.minYear;
    }else{
        minYear = YEAR_FROM;
    }
    
    
    maxYear = minYear + 15;
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    [self reloadAllComponents];
    
    self.todayIndexPath = [self todayPath];
    
    self.delegate = self;
    self.dataSource = self;
    
    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    int currentMonth  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    NSLog(@"mon %d",currentMonth);
    
    [self selectRow:(currentMonth-1) inComponent:0 animated:NO];
    [self selectRow:([self.years count]-1) inComponent:1 animated:NO];
    
}

- (void) setMaximumDate:(NSDate *)aMaximumDate{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:aMaximumDate];
    maxYear = [components year];
    if (maxYear < minYear) {
        minYear = maxYear;
        minimumDate = aMaximumDate;
    }
    maximumDate = aMaximumDate;
    self.years = [self nameOfYears];
    
    [self reloadComponent:YEAR];
}

- (void) setMinimumDate:(NSDate *)aMinimumDate{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:aMinimumDate];
    minYear = [components year];
    if (maxYear < minYear) {
        maxYear = minYear;
        maximumDate = aMinimumDate;
    }
    minimumDate = aMinimumDate;
    self.years = [self nameOfYears];
    [self reloadComponent:YEAR];
}

- (void) setDate:(NSDate *)aDate{
    [self setDate:aDate animated:NO];
}

- (void) setDate:(NSDate *)aDate animated:(BOOL)animated{
    
    NSInteger dateYear;
    NSInteger dateMonth;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:aDate];
    dateMonth = [components month];
    
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    dateYear = [components year];
    
    [self selectRow: dateMonth - 1
        inComponent: MONTH
           animated: NO];
    
    NSInteger rowIndex = dateYear - minYear;
    if (rowIndex < 0) {
        rowIndex = 0;
    }
    
    [self selectRow: rowIndex
        inComponent: YEAR
           animated: animated];
}

-(NSDate *)date
{
    NSInteger monthCount = [self.months count];
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
    
    NSInteger yearCount = [self.years count];
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"MMMM:yyyy"];
    
    if (self.locale) {
        [formatter setLocale:self.locale];
    }
    
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@", month, year]];
    
    return date;
}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView
           viewForRow: (NSInteger)row
         forComponent: (NSInteger)component
          reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = [self.months count];
        NSString *monthName = self.months[(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName])
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger yearCount = [self.years count];
        NSString *yearName = self.years[(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName])
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent: component selected: selected];
    }
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self._delegate) {
        if ([self._delegate respondsToSelector:@selector(pickerView:didChangeDate:)]) {
            [self._delegate pickerView:self didChangeDate:self.date];
        }
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
    }
    return [self bigRowYearCount];
}

#pragma mark - Util
-(NSInteger)bigRowMonthCount
{
    return [self.months count]  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return [self.years count]  * bigRowCount;
}

-(CGFloat)componentWidth
{
    return CGRectGetWidth(self.bounds) / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = [self.months count];
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = [self.years count];
    return [self.years objectAtIndex:(row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected
{
    CGRect frame = CGRectMake(0.f, 0.f, [self componentWidth],rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    //    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.userInteractionEnabled = NO;
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if (self.locale) {
        [dateFormatter setLocale:self.locale];
    }
    
    return [dateFormatter standaloneMonthSymbols];
}

- (void)setLocale:(NSLocale *)locale{
    _locale = locale;
    
    self.months = [self nameOfMonths];
    
    [self reloadAllComponents];
    
}

-(NSArray *)nameOfYears
{
    
    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    if (self.locale) {
        [formatter setLocale:self.locale];
    }
    
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    NSMutableArray *years = [NSMutableArray array];
    
    for (int i = minYear; i <= i2; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    return years;
}

-(void)selectToday
{
    [self selectRow: self.todayIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self selectRow: self.todayIndexPath.section
        inComponent: YEAR
           animated: NO];
}

-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    if (self.locale) {
        [formatter setLocale:self.locale];
    }
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    if (self.locale) {
        [formatter setLocale:self.locale];
    }
    return [formatter stringFromDate:[NSDate date]];
}


@end