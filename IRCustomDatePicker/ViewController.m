//
//  ViewController.m
//  IRCustomDatePicker
//
//  Created by Hijazi on 28/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)segmented_select:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.std_datePicker];
            break;
        case 1:
            [self.view bringSubviewToFront:self.month_yearPicker];
            
            break;
        case 2:
            [self.view bringSubviewToFront:self.year_picker];

            break;
            
        default:
            break;
    } ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.std_datePicker.backgroundColor = [UIColor whiteColor];
    self.std_datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ms"];
    
    self.month_yearPicker.locale = [NSLocale localeWithLocaleIdentifier:@"ms"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)set:(id)sender {
    
    NSLog(@"date %@",self.std_datePicker.date);
    NSLog(@"year %@",self.year_picker.date);
    NSLog(@"month year %@",self.month_yearPicker.date);
    
    
    
}

@end
