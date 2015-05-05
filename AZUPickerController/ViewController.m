//
//  ViewController.m
//  AZUPickerController
//
//  Created by Yasuhiro Hatta on 2015/02/12.
//  Copyright (c) 2015年 yaslab. All rights reserved.
//

#import "ViewController.h"
#import "AZUPickerController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSample1ButtonClicked:(UIButton *)sender {
    NSString *title = @"Sample 1";
    NSString *message = @"Select time.";
    AZUPickerController *picker = [AZUPickerController pickerControllerWithTitle:title message:message preferredStyle:AZUPickerControllerStylePickerView];
    //picker.modalPresentationStyle = UIModalPresentationFullScreen;

    NSMutableArray *minList = [NSMutableArray new];
    for (int i = 0; i <= 59; i++) {
        [minList addObject:[NSString stringWithFormat:@"%d min", i]];
    }
    [picker addComponent:minList selectedRow:5];

    NSMutableArray *secList = [NSMutableArray new];
    for (int i = 0; i <= 59; i++) {
        [secList addObject:[NSString stringWithFormat:@"%d sec", i]];
    }
    [picker addComponent:secList selectedRow:10];

    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
        NSLog(@"Cancel clicked.");
    }]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
        NSLog(@"Cancel clicked.");
    }]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
        NSLog(@"Cancel clicked.");
    }]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
        NSLog(@"Cancel clicked.");
    }]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
        NSLog(@"Cancel clicked.");
    }]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
        NSLog(@"Cancel clicked.");
    }]];

    [picker addAction:[AZUPickerAction actionWithTitle:@"OK" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action) {
        NSInteger index = [picker.pickerView selectedRowInComponent:0];
        NSString *min = minList[index];
        index = [picker.pickerView selectedRowInComponent:1];
        NSString *sec = secList[index];
        NSLog(@"OK clicked. (%@, %@)", min, sec);
        self.label1.text = [NSString stringWithFormat:@"%@, %@", min, sec];
    }]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"OK" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action) {
        NSInteger index = [picker.pickerView selectedRowInComponent:0];
        NSString *min = minList[index];
        index = [picker.pickerView selectedRowInComponent:1];
        NSString *sec = secList[index];
        NSLog(@"OK clicked. (%@, %@)", min, sec);
        self.label1.text = [NSString stringWithFormat:@"%@, %@", min, sec];
    }]];

    [self presentViewController:picker animated:YES completion:^{}];
}

- (IBAction)onSample2ButtonClicked:(UIButton *)sender {
    NSString *title = @"Sample 2";
    NSString *message = @"Select date and time.";
    AZUPickerController *picker = [AZUPickerController pickerControllerWithTitle:title message:message preferredStyle:AZUPickerControllerStyleDatePicker];

    picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.datePicker.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    picker.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
    picker.datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];

    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
        NSLog(@"Cancel clicked.");
    }]];

    [picker addAction:[AZUPickerAction actionWithTitle:@"OK" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action) {
        NSDate *date = picker.datePicker.date;
        NSLog(@"OK clicked. (%@)", date);
        self.label2.text = [NSString stringWithFormat:@"%@", date];
    }]];

    [self presentViewController:picker animated:YES completion:^{}];
}

@end
