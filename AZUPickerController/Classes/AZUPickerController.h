//
//  AZUPickerController.h
//  AZUPickerController
//
//  Created by Yasuhiro Hatta on 2015/02/11.
//  Copyright (c) 2015 yaslab. All rights reserved.
//

#import <UIKit/UIKit.h>

// -----------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, AZUPickerActionStyle) {
    AZUPickerActionStyleDefault = 0,
    AZUPickerActionStyleCancel,
    AZUPickerActionStyleDestructive,
};

// -----------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, AZUPickerControllerStyle) {
    AZUPickerControllerStylePickerView = 0,
    AZUPickerControllerStyleDatePicker
};

// -----------------------------------------------------------------------------
@interface AZUPickerAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title style:(AZUPickerActionStyle)style handler:(void (^)(AZUPickerAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) AZUPickerActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

// -----------------------------------------------------------------------------
@interface AZUPickerController : UIViewController

+ (instancetype)pickerControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AZUPickerControllerStyle)preferredStyle;

- (void)addAction:(AZUPickerAction *)action;
@property (nonatomic, readonly) NSArray *actions;

// For UIPickerView
- (void)addComponent:(NSArray *)rows selectedRow:(NSInteger)rowIndex;
@property (nonatomic, readonly) NSArray *components;
@property (nonatomic, readonly) UIPickerView *pickerView;

// For UIDatePicker
@property (nonatomic, readonly) UIDatePicker *datePicker;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) AZUPickerControllerStyle preferredStyle;

@end
