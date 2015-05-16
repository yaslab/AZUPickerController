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

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        picker.popoverPresentationController.sourceView = self.view;
        picker.popoverPresentationController.sourceRect = CGRectMake(20.f, 20.f, 1.f, 1.f);
    }
    
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
    //NSString *title = @"Sample 2";
    //NSString *message = @"Select date and time.";
    NSString *title = nil;//@"Sample 3";
    NSString *message = nil;//@"Custom view.";
    AZUPickerController *picker = [AZUPickerController pickerControllerWithTitle:title message:message preferredStyle:AZUPickerControllerStyleDatePicker];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        picker.popoverPresentationController.sourceView = self.view;
        picker.popoverPresentationController.sourceRect = CGRectMake(20.f, 20.f, 1.f, 1.f);
    }

    picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.datePicker.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    picker.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
    picker.datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];

//    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
//        NSLog(@"Cancel clicked.");
//    }]];
//
//    [picker addAction:[AZUPickerAction actionWithTitle:@"OK" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action) {
//        NSDate *date = picker.datePicker.date;
//        NSLog(@"OK clicked. (%@)", date);
//        self.label2.text = [NSString stringWithFormat:@"%@", date];
//    }]];

    [picker addAction:[AZUPickerAction actionWithTitle:@"Default" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action) {}]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Destructive" style:AZUPickerActionStyleDestructive handler:^(AZUPickerAction *action) {}]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {}]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Default2" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action) {}]];
    [picker addAction:[AZUPickerAction actionWithTitle:@"Destructive2" style:AZUPickerActionStyleDestructive handler:^(AZUPickerAction *action) {}]];
    //[picker addAction:[AZUPickerAction actionWithTitle:@"Cancel2" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {}]];

    [self presentViewController:picker animated:YES completion:^{}];
}

- (IBAction)onSample3ButtonClicked:(UIButton *)sender {
    NSString *title = nil;//@"Sample 3";
    NSString *message = nil;//@"Custom view.";
    AZUPickerController *picker = [AZUPickerController pickerControllerWithTitle:title message:message preferredStyle:AZUPickerControllerStyleCustom];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        picker.popoverPresentationController.sourceView = self.view;
        picker.popoverPresentationController.sourceRect = CGRectMake(20.f, 20.f, 1.f, 1.f);
    }

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.frame = CGRectMake(0.f, 0.f, 900.f, 100.f);
    contentView.backgroundColor = [UIColor redColor];
    picker.contentView = contentView;

//    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action) {
//        NSLog(@"Cancel clicked.");
//    }]];
//
//    [picker addAction:[AZUPickerAction actionWithTitle:@"OK" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action) {
//        NSDate *date = picker.datePicker.date;
//        NSLog(@"OK clicked. (%@)", date);
//        self.label2.text = [NSString stringWithFormat:@"%@", date];
//    }]];

    [self presentViewController:picker animated:YES completion:^{}];
}

@end
