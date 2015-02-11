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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSample1ButtonClicked:(UIButton *)sender {
    NSString *title = @"Sample";
    NSString *message = @"Select time.";
    AZUPickerController *picker = [AZUPickerController pickerControllerWithTitle:title message:message];

    NSMutableArray *minList = [NSMutableArray new];
    for (int i = 0; i <= 59; i++) {
        [minList addObject:[NSString stringWithFormat:@"%d min", i]];
    }
    [picker addComponent:minList];

    NSMutableArray *secList = [NSMutableArray new];
    for (int i = 0; i <= 59; i++) {
        [secList addObject:[NSString stringWithFormat:@"%d sec", i]];
    }
    [picker addComponent:secList];

    [picker addAction:[AZUPickerAction actionWithTitle:@"Cancel" style:AZUPickerActionStyleCancel handler:^(AZUPickerAction *action, NSArray *selectedRows) {
        NSLog(@"Cancel clicked.");
    }]];

    [picker addAction:[AZUPickerAction actionWithTitle:@"OK" style:AZUPickerActionStyleDefault handler:^(AZUPickerAction *action, NSArray *selectedRows) {
        NSNumber *index = selectedRows[0];
        NSString *min = minList[index.integerValue];
        index = selectedRows[1];
        NSString *sec = secList[index.integerValue];
        NSLog(@"OK clicked. (%@, %@)", min, sec);
    }]];

    [self presentViewController:picker animated:YES completion:^{}];
}

@end
