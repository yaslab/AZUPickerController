//
//  AZUPickerController.m
//  AZUPickerController
//
//  Created by Yasuhiro Hatta on 2015/02/11.
//  Copyright (c) 2015 yaslab. All rights reserved.
//

#import "AZUPickerController.h"

#define kAZUPickerButtonHeight 44.f

// -----------------------------------------------------------------------------
#pragma mark - AZUPickerAction

@interface AZUPickerAction ()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) AZUPickerActionStyle style;
@property (nonatomic, copy) void (^handler)(AZUPickerAction *, NSArray *);

@end

@implementation AZUPickerAction

+ (instancetype)actionWithTitle:(NSString *)title style:(AZUPickerActionStyle)style handler:(void (^)(AZUPickerAction *action, NSArray *selectedRows))handler {
    AZUPickerAction *action = [self new];
    action.title = title;
    action.style = style;
    action.enabled = YES;
    action.handler = handler;
    return action;
}

@end

// -----------------------------------------------------------------------------
#pragma mark - private AZUPickerView

@interface AZUPickerView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, readonly) UIPickerView *pickerView;

@end

@implementation AZUPickerView

{
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    UIPickerView *_pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;

        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [self addSubview:_pickerView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
        _titleLabel.textColor = [UIColor colorWithRed:0.561 green:0.561 blue:0.561 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];

        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont systemFontOfSize:13.f];
        _messageLabel.textColor = [UIColor colorWithRed:0.561 green:0.561 blue:0.561 alpha:1];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat margin = 0.f;
    CGRect frame = CGRectZero;
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX);
    CGSize fitSize;

    margin = 14.f;
    fitSize = [_titleLabel sizeThatFits:maxSize];
    frame.size = fitSize;
    if (_titleLabel.text == nil || [_titleLabel.text isEqualToString:@""]) {
        frame.size.height = 0.f;
    }
    frame.origin.x = (CGRectGetWidth(self.frame) - fitSize.width) / 2.f;
    frame.origin.y = margin;
    _titleLabel.frame = frame;

    margin = 10.f;
    fitSize = [_messageLabel sizeThatFits:maxSize];
    frame.size = fitSize;
    if (_messageLabel.text == nil || [_messageLabel.text isEqualToString:@""]) {
        margin = 0.f;
        frame.size.height = 0.f;
    }
    frame.origin.x = (CGRectGetWidth(self.frame) - fitSize.width) / 2.f;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + margin;
    _messageLabel.frame = frame;

    margin = 0.f;
    fitSize = [_pickerView sizeThatFits:maxSize];
    frame.size = fitSize;
    frame.origin.x = (CGRectGetWidth(self.frame) - fitSize.width) / 2.f;
    frame.origin.y = CGRectGetMaxY(_messageLabel.frame) + margin;
    _pickerView.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat margin = 0.f;
    CGFloat height = 0.f;
    CGSize maxSize = CGSizeMake(size.width, CGFLOAT_MAX);
    CGSize fitSize;

    margin = 14.f;
    fitSize = [_titleLabel sizeThatFits:maxSize];
    if (_titleLabel.text == nil || [_titleLabel.text isEqualToString:@""]) {
        fitSize.height = 0.f;
    }
    height += fitSize.height + margin;

    margin = 10.f;
    fitSize = [_messageLabel sizeThatFits:maxSize];
    if (_messageLabel.text == nil || [_messageLabel.text isEqualToString:@""]) {
        margin = 0.f;
        fitSize.height = 0.f;
    }
    height += fitSize.height + margin;

    margin = 0.f;
    fitSize = [_pickerView sizeThatFits:maxSize];
    height += fitSize.height + margin;

    return CGSizeMake(size.width, height);
}

@end

// -----------------------------------------------------------------------------
#pragma mark - private AZUButtonView

@class AZUButtonView;

@protocol AZUButtonViewDelegate <NSObject>

- (void)buttonView:(AZUButtonView *)buttonView didClickWithAction:(AZUPickerAction *)action;

@end

@interface AZUButtonView : UIView

@property (nonatomic, weak) id<AZUButtonViewDelegate> delegate;

@property (nonatomic) BOOL useBoldFont;
@property (nonatomic) UIColor *buttonTitleColor;

- (void)addButtonWithAction:(AZUPickerAction *)action;

@end

@implementation AZUButtonView

{
    NSMutableArray *_buttons;
    NSMutableArray *_actions;
}

#pragma mark UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.contentMode = UIViewContentModeRedraw;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.f;

        _useBoldFont = NO;
        _buttonTitleColor = nil;

        _buttons = [NSMutableArray new];
        _actions = [NSMutableArray new];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = CGRectZero;
    CGSize targetSize = [self sizeThatFits:self.bounds.size];

    for (NSInteger i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        AZUPickerAction *action = _actions[i];
        frame.size = CGSizeMake(targetSize.width, kAZUPickerButtonHeight);
        frame.origin = CGPointMake(0.f, kAZUPickerButtonHeight * i);
        button.frame = frame;
        button.enabled = action.enabled;
        CGFloat fontSize = 21.f;
        if (self.useBoldFont) {
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
        }
        else {
            [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        }
        if (self.buttonTitleColor) {
            [button setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, kAZUPickerButtonHeight * _buttons.count);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGContextBeginPath(ctx);
    CGContextSetAllowsAntialiasing(ctx, false);
    CGContextSetShouldAntialias(ctx, false);
    CGContextSetLineWidth(ctx, 0.5f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1].CGColor);

    CGFloat width = CGRectGetWidth(self.frame);

    NSInteger count = _buttons.count;
    for (int i = 1; i < count; i++) {
        CGFloat y = kAZUPickerButtonHeight * (CGFloat)i;
        CGContextMoveToPoint(ctx, 0.f, y);
        CGContextAddLineToPoint(ctx, width, y);
    }

    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    CGContextRestoreGState(ctx);
}

#pragma mark AZUButtonView

- (void)addButtonWithAction:(AZUPickerAction *)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:action.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [_buttons addObject:button];
    [_actions addObject:action];
}

- (void)onButtonClicked:(UIButton *)sender {
    if (self.delegate) {
        NSInteger index = [_buttons indexOfObject:sender];
        AZUPickerAction *action = _actions[index];
        [self.delegate buttonView:self didClickWithAction:action];
    }
}

@end

// -----------------------------------------------------------------------------
#pragma mark - private AZUPickerViewModel

@interface AZUPickerViewModel : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

- (void)addComponent:(NSArray *)rows;

@end

@implementation AZUPickerViewModel

{
    NSMutableArray *_components;
}

- (void)addComponent:(NSArray *)rows {
    [_components addObject:rows];
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _components = [NSMutableArray new];
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _components.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rows = _components[component];
    return rows.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *rows = _components[component];
    return rows[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    return;
}

@end

// -----------------------------------------------------------------------------
#pragma mark - AZUPickerController

@interface AZUPickerController () <AZUButtonViewDelegate>

@end

@implementation AZUPickerController

{
    AZUPickerView *_pickerView;
    AZUButtonView *_destructiveButtonView;
    AZUButtonView *_normalButtonView;
    AZUButtonView *_cancelButtonView;

    AZUPickerViewModel *_pickerViewModel;
}

@dynamic title, message;

+ (instancetype)pickerControllerWithTitle:(NSString *)title message:(NSString *)message {
    AZUPickerController *picker = [[self alloc] initWithNibName:nil bundle:nil];
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    picker.title = title;
    picker.message = message;
    return picker;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commomInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commomInit];
    }
    return self;
}

- (void)commomInit {
    _pickerView = [[AZUPickerView alloc] initWithFrame:CGRectZero];
    _pickerView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    [self.view addSubview:_pickerView];

    _destructiveButtonView = [[AZUButtonView alloc] initWithFrame:CGRectZero];
    _destructiveButtonView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    _destructiveButtonView.delegate = self;
    _destructiveButtonView.buttonTitleColor = [UIColor redColor];
    [self.view addSubview:_destructiveButtonView];

    _normalButtonView = [[AZUButtonView alloc] initWithFrame:CGRectZero];
    _normalButtonView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    _normalButtonView.delegate = self;
    [self.view addSubview:_normalButtonView];

    _cancelButtonView = [[AZUButtonView alloc] initWithFrame:CGRectZero];
    _cancelButtonView.useBoldFont = YES;
    _cancelButtonView.delegate = self;
    [self.view addSubview:_cancelButtonView];

    _pickerViewModel = [AZUPickerViewModel new];
    _pickerView.pickerView.dataSource = _pickerViewModel;
    _pickerView.pickerView.delegate = _pickerViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.4f];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.view addGestureRecognizer:gesture];

    [_pickerView.pickerView reloadAllComponents];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat margin = 7.f;
    CGRect frame;
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.frame) - margin - margin, CGFLOAT_MAX);
    CGSize fitSize;

    fitSize = [_cancelButtonView sizeThatFits:maxSize];
    frame = _cancelButtonView.frame;
    frame.size = fitSize;
    frame.origin.x = margin;
    frame.origin.y = CGRectGetHeight(self.view.frame) - fitSize.height;
    frame.origin.y -= margin;
    _cancelButtonView.frame = frame;

    fitSize = [_normalButtonView sizeThatFits:maxSize];
    frame = _normalButtonView.frame;
    frame.size = fitSize;
    frame.origin.x = margin;
    frame.origin.y = CGRectGetMinY(_cancelButtonView.frame) - fitSize.height;
    if ((int)CGRectGetHeight(_cancelButtonView.frame) != 0) {
        frame.origin.y -= margin;
    }
    _normalButtonView.frame = frame;

    fitSize = [_destructiveButtonView sizeThatFits:maxSize];
    frame = _destructiveButtonView.frame;
    frame.size = fitSize;
    frame.origin.x = margin;
    frame.origin.y = CGRectGetMinY(_normalButtonView.frame) - fitSize.height;
    if ((int)CGRectGetHeight(_normalButtonView.frame) != 0) {
        frame.origin.y -= margin;
    }
    _destructiveButtonView.frame = frame;

    fitSize = [_pickerView sizeThatFits:maxSize];
    frame = _pickerView.frame;
    frame.size = fitSize;
    frame.origin.x = margin;
    frame.origin.y = CGRectGetMinY(_destructiveButtonView.frame) - fitSize.height;
    if ((int)CGRectGetHeight(_destructiveButtonView.frame) != 0) {
        frame.origin.y -= margin;
    }
    _pickerView.frame = frame;
}

- (void)addComponent:(NSArray *)rows {
    [_pickerViewModel addComponent:rows];
}

- (void)addAction:(AZUPickerAction *)action {
    switch (action.style) {
        case AZUPickerActionStyleDefault:
            [_normalButtonView addButtonWithAction:action];
            break;
        case AZUPickerActionStyleDestructive:
            [_destructiveButtonView addButtonWithAction:action];
            break;
        case AZUPickerActionStyleCancel:
            [_cancelButtonView addButtonWithAction:action];
            break;
    }
}

- (void)onTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches == 1) {
            CGPoint location = [sender locationInView:self.view];
            if (location.y < CGRectGetMinY(_pickerView.frame)) {
                // TODO: 閉じる前に専用のキャンセルを発火する?
                [self dismissViewControllerAnimated:YES completion:^{}];
            }
        }
    }
}

#pragma mark - Dynamic Proprery

- (NSString *)title {
    return [_pickerView.titleLabel.text copy];
}

- (void)setTitle:(NSString *)title {
    _pickerView.titleLabel.text = [title copy];
}

- (NSString *)message {
    return [_pickerView.messageLabel.text copy];
}

- (void)setMessage:(NSString *)message {
    _pickerView.messageLabel.text = [message copy];
}

#pragma mark - AZUButtonViewDelegate

- (void)buttonView:(AZUButtonView *)buttonView didClickWithAction:(AZUPickerAction *)action {
    NSInteger count = [_pickerView.pickerView numberOfComponents];
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        NSInteger selectedRow = [_pickerView.pickerView selectedRowInComponent:i];
        [rows addObject:@(selectedRow)];
    }
    action.handler(action, [rows copy]);
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
