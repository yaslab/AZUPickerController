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

@interface AZUPickerAction : NSObject

/// selectedRows: Array of NSNumber
+ (instancetype)actionWithTitle:(NSString *)title style:(AZUPickerActionStyle)style handler:(void (^)(AZUPickerAction *action, NSArray *selectedRows))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) AZUPickerActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

// -----------------------------------------------------------------------------
@interface AZUPickerController : UIViewController

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

+ (instancetype)pickerControllerWithTitle:(NSString *)title message:(NSString *)message;

- (void)addComponent:(NSArray *)rows;
- (void)addAction:(AZUPickerAction *)action;

@end
