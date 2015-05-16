//
//  AZUPickerController.m
//  AZUPickerController
//
//  Created by Yasuhiro Hatta on 2015/02/11.
//  Copyright (c) 2015 yaslab. All rights reserved.
//

#import "AZUPickerController.h"

#define kOSVersion ((CGFloat)[[[UIDevice currentDevice] systemVersion] floatValue])
#define kAZUPickerButtonHeight 44.f

// -----------------------------------------------------------------------------
#pragma mark - AZUPickerAction

@interface AZUPickerAction ()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) AZUPickerActionStyle style;
@property (nonatomic, copy) void (^handler)(AZUPickerAction *);

@end

@implementation AZUPickerAction

+ (instancetype)actionWithTitle:(NSString *)title style:(AZUPickerActionStyle)style handler:(void (^)(AZUPickerAction *action))handler {
    AZUPickerAction *action = [self new];
    action.title = title;
    action.style = style;
    action.enabled = YES;
    action.handler = handler;
    return action;
}

@end

// -----------------------------------------------------------------------------
#pragma mark - private AZUPickerPanelView

@interface AZUPickerPanelView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic) UIView *contentView;

- (instancetype)initWithContentView:(UIView *)pickerView;

@end

@implementation AZUPickerPanelView

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;

        _contentView = contentView;
        if (_contentView) {
            [self addSubview:_contentView];
        }

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
    if (_titleLabel.text == nil || [_titleLabel.text isEqualToString:@""]) {
        margin = 0.f;
        fitSize.height = 0.f;
    }
    frame.size = fitSize;
    frame.origin.x = (CGRectGetWidth(self.frame) - fitSize.width) / 2.f;
    frame.origin.y = margin;
    _titleLabel.frame = frame;

    if (_titleLabel.text == nil || [_titleLabel.text isEqualToString:@""]) {
        margin = 14.f;
    }
    else {
        margin = 10.f;
    }
    fitSize = [_messageLabel sizeThatFits:maxSize];
    if (_messageLabel.text == nil || [_messageLabel.text isEqualToString:@""]) {
        margin = 0.f;
        fitSize.height = 0.f;
    }
    frame.size = fitSize;
    frame.origin.x = (CGRectGetWidth(self.frame) - fitSize.width) / 2.f;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + margin;
    _messageLabel.frame = frame;

    if (_contentView) {
        margin = 0.f;
        fitSize = [_contentView sizeThatFits:maxSize];
        if (fitSize.width > CGRectGetWidth(self.frame)) {
            fitSize.width = CGRectGetWidth(self.frame);
        }
        frame.size = fitSize;
        frame.origin.x = (CGRectGetWidth(self.frame) - fitSize.width) / 2.f;
        frame.origin.y = CGRectGetMaxY(_messageLabel.frame) + margin;
        _contentView.frame = frame;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat margin = 0.f;
    CGFloat height = 0.f;
    CGSize maxSize = CGSizeMake(size.width, CGFLOAT_MAX);
    CGSize fitSize;

    margin = 14.f;
    fitSize = [_titleLabel sizeThatFits:maxSize];
    if (_titleLabel.text == nil || [_titleLabel.text isEqualToString:@""]) {
        margin = 0.f;
        fitSize.height = 0.f;
    }
    height += fitSize.height + margin;

    if (_titleLabel.text == nil || [_titleLabel.text isEqualToString:@""]) {
        margin = 14.f;
    }
    else {
        margin = 10.f;
    }
    fitSize = [_messageLabel sizeThatFits:maxSize];
    if (_messageLabel.text == nil || [_messageLabel.text isEqualToString:@""]) {
        margin = 0.f;
        fitSize.height = 0.f;
    }
    height += fitSize.height + margin;

    if (_contentView) {
        margin = 0.f;
        fitSize = [_contentView sizeThatFits:maxSize];
        height += fitSize.height + margin;
    }

    return CGSizeMake(size.width, height);
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    [self addSubview:_contentView];
    [self setNeedsLayout];
}

@end

// -----------------------------------------------------------------------------
#pragma mark - private AZUButtonView

@class AZUButtonView;

@protocol AZUButtonViewDelegate <NSObject>

- (void)buttonViewDidClick:(AZUButtonView *)buttonView;

@end

@interface AZUButtonView : UIView

@property (nonatomic, weak) id<AZUButtonViewDelegate> delegate;

- (void)addButtonWithAction:(AZUPickerAction *)action;
@property (nonatomic, readonly) NSArray *actions;

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
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.f;

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
        switch (action.style) {
            case AZUPickerActionStyleDefault:
                [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
                break;
            case AZUPickerActionStyleDestructive:
                [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
                [button setTitleColor:[UIColor colorWithRed:1.0 green:0.231 blue:0.188 alpha:1.0] forState:UIControlStateNormal];
                break;
            case AZUPickerActionStyleCancel:
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
                break;
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
    NSInteger index = [_buttons indexOfObject:sender];
    AZUPickerAction *action = _actions[index];
    action.handler(action);

    if (self.delegate) {
        [self.delegate buttonViewDidClick:self];
    }
}

#pragma mark Property Accesser

- (NSArray *)actions {
    return [_actions copy];
}

@end

// -----------------------------------------------------------------------------
#pragma mark - private AZUPickerViewModel

@interface AZUPickerViewModel : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, readonly) NSArray *components;

- (void)addComponent:(NSArray *)rows selectedRow:(NSInteger)rowIndex;

@end

@implementation AZUPickerViewModel

{
    NSMutableArray *_components;
}

- (void)addComponent:(NSArray *)rows selectedRow:(NSInteger)rowIndex {
    [_components addObject:rows];
    [_pickerView reloadAllComponents];

    if (rows.count != 0) {
        // TODO: Exceptionのほうがいい?
        if (rowIndex < 0) {
            NSLog(@"%s: TRIM VALUE %ld to %ld", __PRETTY_FUNCTION__, (long)rowIndex, 0L);
            rowIndex = 0;
        }
        else if (rowIndex >= rows.count) {
            NSLog(@"%s: TRIM VALUE %ld to %ld", __PRETTY_FUNCTION__, (long)rowIndex, (long)(rows.count - 1));
            rowIndex = rows.count - 1;
        }
        NSInteger component = _components.count - 1;
        [_pickerView selectRow:rowIndex inComponent:component animated:YES];
    }
}

#pragma mark Property Accesser

- (void)setPickerView:(UIPickerView *)pickerView {
    _pickerView = pickerView;
    if (_pickerView) {
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
}

- (NSArray *)components {
    return _components;
}

#pragma mark NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _components = [NSMutableArray new];
    }
    return self;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _components.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rows = _components[component];
    return rows.count;
}

#pragma mark UIPickerViewDelegate

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

#define kViewMargin 7.f

@interface AZUPickerController () <AZUButtonViewDelegate>

@end

@implementation AZUPickerController

{
    CGFloat _viewWidth;

    AZUPickerPanelView *_pickerPanelView;
    AZUButtonView *_otherButtonView;
    AZUButtonView *_cancelButtonView;

    AZUPickerControllerStyle _preferredStyle;

    BOOL _visible;

    // For UIPickerView
    AZUPickerViewModel *_pickerViewModel;
}

@dynamic actions;
@synthesize contentView = _contentView;
@dynamic title;
@dynamic message;

+ (instancetype)pickerControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AZUPickerControllerStyle)preferredStyle {
    AZUPickerController *picker = [[self alloc] initWithNibName:nil bundle:nil];
    if (kOSVersion >= 8.0) {
        picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    picker->_preferredStyle = preferredStyle;
    [picker azu_initialize];
    picker.title = title;
    picker.message = message;
    return picker;
}

// FIXME: DEBUG
- (void)dealloc {
    NSLog(@"DEALLOC %s", __PRETTY_FUNCTION__);
}

- (void)dismiss {
    _visible = NO;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.4f delay:0.1f usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];

    [self dismissViewControllerAnimated:YES completion:^{
        // Clean up objects that holding blocks.
        // This is to avoid the circular reference problem.
        if (_contentView) {
            [_contentView removeFromSuperview];
            _contentView = nil;
        }
        [_pickerPanelView removeFromSuperview];
        _pickerPanelView = nil;
        [_otherButtonView removeFromSuperview];
        _otherButtonView = nil;
        [_cancelButtonView removeFromSuperview];
        _cancelButtonView = nil;
    }];
}

- (void)azu_initialize {
    self.view.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.4f];

    CGRect bounds = [UIScreen mainScreen].bounds;
    _viewWidth = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    _viewWidth -= kViewMargin * 2.f;

    switch (_preferredStyle) {
        case AZUPickerControllerStylePickerView:
            _contentView = [[UIPickerView alloc] initWithFrame:CGRectZero];
            _pickerViewModel = [AZUPickerViewModel new];
            _pickerViewModel.pickerView = (UIPickerView *)_contentView;
            break;
        case AZUPickerControllerStyleDatePicker:
            _contentView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            break;
        case AZUPickerControllerStyleCustom:
            _contentView = nil;
            break;
    }

    _pickerPanelView = [[AZUPickerPanelView alloc] initWithContentView:_contentView];
    _pickerPanelView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    [self.view addSubview:_pickerPanelView];

    _otherButtonView = [[AZUButtonView alloc] initWithFrame:CGRectZero];
    _otherButtonView.backgroundColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
    _otherButtonView.delegate = self;
    [self.view addSubview:_otherButtonView];

    _cancelButtonView = [[AZUButtonView alloc] initWithFrame:CGRectZero];
    _cancelButtonView.backgroundColor = [UIColor whiteColor];
    _cancelButtonView.delegate = self;
    [self.view addSubview:_cancelButtonView];

    _visible = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (kOSVersion < 8.0) {
        // Take a screenshot.
        CALayer *layer = [[[UIApplication sharedApplication] keyWindow] layer];
        CGFloat scale = [[UIScreen mainScreen] scale];
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [layer renderInContext:ctx];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        UIImageView *imageView = [[UIImageView alloc] initWithImage:screenshot];
        CGRect frame = CGRectMake(0.f, 0.f, screenshot.size.width, screenshot.size.height);
        imageView.frame = frame;
        [self.view insertSubview:imageView atIndex:0];

        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.frame = frame;
        view.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.4f];
        [self.view insertSubview:view aboveSubview:imageView];
    }

    if (!_visible) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        _visible = YES;
        [self.view setNeedsLayout];
        [UIView animateWithDuration:0.4f delay:0.1f usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {}];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGSize maxSize = CGSizeMake(_viewWidth, CGFLOAT_MAX);
    CGSize fitSize;

    fitSize = [_cancelButtonView sizeThatFits:maxSize];
    CGRect cancelButtonFrame = _cancelButtonView.frame;
    cancelButtonFrame.size = fitSize;
    cancelButtonFrame.origin.x = (CGRectGetWidth(self.view.frame) - fitSize.width) / 2.f;
    cancelButtonFrame.origin.y = CGRectGetHeight(self.view.frame) - fitSize.height;
    cancelButtonFrame.origin.y -= kViewMargin;

    fitSize = [_otherButtonView sizeThatFits:maxSize];
    CGRect otherButtonFrame = _otherButtonView.frame;
    otherButtonFrame.size = fitSize;
    otherButtonFrame.origin.x = (CGRectGetWidth(self.view.frame) - fitSize.width) / 2.f;
    otherButtonFrame.origin.y = CGRectGetMinY(cancelButtonFrame) - fitSize.height;
    if ((int)CGRectGetHeight(cancelButtonFrame) != 0) {
        otherButtonFrame.origin.y -= kViewMargin;
    }

    fitSize = [_pickerPanelView sizeThatFits:maxSize];
    CGRect pickerPanelFrame = _pickerPanelView.frame;
    pickerPanelFrame.size = fitSize;
    pickerPanelFrame.origin.x = (CGRectGetWidth(self.view.frame) - fitSize.width) / 2.f;
    pickerPanelFrame.origin.y = CGRectGetMinY(otherButtonFrame) - fitSize.height;
    if ((int)CGRectGetHeight(otherButtonFrame) != 0) {
        pickerPanelFrame.origin.y -= kViewMargin;
    }

    if (!_visible) {
        CGFloat yOffset = CGRectGetHeight(self.view.frame) - CGRectGetMinY(pickerPanelFrame);
        cancelButtonFrame.origin.y += yOffset;
        otherButtonFrame.origin.y += yOffset;
        pickerPanelFrame.origin.y += yOffset;
    }

    _cancelButtonView.frame = cancelButtonFrame;
    _otherButtonView.frame = otherButtonFrame;
    _pickerPanelView.frame = pickerPanelFrame;
}

- (void)addAction:(AZUPickerAction *)action {
    switch (action.style) {
        case AZUPickerActionStyleDefault:
        case AZUPickerActionStyleDestructive:
            [_otherButtonView addButtonWithAction:action];
            break;
        case AZUPickerActionStyleCancel:
            NSAssert(_cancelButtonView.actions.count == 0, @"");
            [_cancelButtonView addButtonWithAction:action];
            break;
    }
}

- (void)onTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches == 1) {
            CGPoint location = [sender locationInView:self.view];

            CGRect contentArea = _pickerPanelView.frame;
            contentArea = CGRectUnion(contentArea, _otherButtonView.frame);
            contentArea = CGRectUnion(contentArea, _cancelButtonView.frame);
            contentArea = CGRectInset(contentArea, -1.f * kViewMargin, -1.f * kViewMargin);

            if (!CGRectContainsPoint(contentArea, location)) {
                [self dismiss];
            }
        }
    }
}

#pragma mark For UIPickerView

- (void)addComponent:(NSArray *)rows selectedRow:(NSInteger)rowIndex {
    [_pickerViewModel addComponent:rows selectedRow:rowIndex];
}

- (NSArray *)components {
    return _pickerViewModel.components;
}

#pragma mark Proprery Accesser

- (NSArray *)actions {
    NSMutableArray *actions = [NSMutableArray new];
    [actions addObjectsFromArray:_otherButtonView.actions];
    [actions addObjectsFromArray:_cancelButtonView.actions];
    return [actions copy];
}

- (UIPickerView *)pickerView {
    if (_preferredStyle != AZUPickerControllerStylePickerView) {
        return nil;
    }
    return (UIPickerView *)_contentView;
}

- (UIDatePicker *)datePicker {
    if (_preferredStyle != AZUPickerControllerStyleDatePicker) {
        return nil;
    }
    return (UIDatePicker *)_contentView;
}

- (void)setContentView:(UIView *)contentView {
    NSAssert(_preferredStyle == AZUPickerControllerStyleCustom, @"");
    _contentView = contentView;
    _pickerPanelView.contentView = contentView;
    [self.view setNeedsLayout];
}

- (NSString *)title {
    return [_pickerPanelView.titleLabel.text copy];
}

- (void)setTitle:(NSString *)title {
    _pickerPanelView.titleLabel.text = [title copy];
}

- (NSString *)message {
    return [_pickerPanelView.messageLabel.text copy];
}

- (void)setMessage:(NSString *)message {
    _pickerPanelView.messageLabel.text = [message copy];
}

#pragma mark AZUButtonViewDelegate

- (void)buttonViewDidClick:(AZUButtonView *)buttonView {
    [self dismiss];
}

@end
