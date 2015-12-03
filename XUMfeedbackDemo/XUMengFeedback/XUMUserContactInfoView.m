//
//  XUMUserContactInfoView.m
//  XUMFeedback
//
//  Created by 敏杰 倪 on 15/12/2.
//  Copyright © 2015年 QiCool. All rights reserved.
//

#import "XUMUserContactInfoView.h"
#import "XUMFeedback.h"

@interface XUMUserContactInfoView()

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation XUMUserContactInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(15, 0, frame.size.width-85, frame.size.height);
        self.titleLabel = [[UILabel alloc] initWithFrame:rect];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0];
        [self addSubview:self.titleLabel];
        
        rect = CGRectMake(frame.size.width-55, 8, 40, frame.size.height-16);
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.editButton setTitleColor:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.editButton.frame = rect;
        self.editButton.layer.cornerRadius = 5;
        self.editButton.layer.borderColor = [UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0].CGColor;
        self.editButton.layer.borderWidth = 1.0;
        [self.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.editButton];
        
        rect = CGRectMake(15, 8, frame.size.width-85, frame.size.height-16);
        self.textField = [[UITextField alloc] initWithFrame:rect];
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.textColor = [UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0];
        self.textField.placeholder = @"输入联系方式";
        self.textField.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textField];
        
        rect = CGRectMake(frame.size.width-55, 8, 40, frame.size.height-16);
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.saveButton setTitleColor:[UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.saveButton.frame = rect;
        self.saveButton.layer.cornerRadius = 5;
        self.saveButton.layer.borderColor = [UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0].CGColor;
        self.saveButton.layer.borderWidth = 1.0;
        [self.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveButton];
        
    }
    
    return self;
}


- (void)updateView
{
    self.titleLabel.hidden = self.isEditing;
    self.editButton.hidden = self.isEditing;
    self.textField.hidden = !self.isEditing;
    self.saveButton.hidden = !self.isEditing;
    
    if (self.isEditing) {
        if (self.contactInfo.length > 0) {
            self.textField.text = self.contactInfo;
            
        }
        else {
            self.textField.text = @"";
            
        }
        
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    else {
        if (self.contactInfo.length > 0) {
            self.titleLabel.text = [NSString stringWithFormat:@"联系方式：%@",self.contactInfo];
            [self.editButton setTitle:@"修改" forState:UIControlStateNormal];
        }
        else {
            self.titleLabel.text = @"反馈前请添加联系方式(手机、QQ等)";
            [self.editButton setTitle:@"添加" forState:UIControlStateNormal];
        }
    }
    
}

- (void)activate
{
    [self editButtonClicked:nil];
}

- (void)editButtonClicked:(id)sender
{
    self.isEditing = YES;
    [self updateView];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    animation.startProgress = 0.0;
    animation.endProgress = 1.0;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"animation"];
    
    [self.textField becomeFirstResponder];
}

- (void)saveButtonClicked:(id)sender
{
    NSString *contactInfo = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.contactInfo = contactInfo;
    
    if ([self.delegate respondsToSelector:@selector(userContactInfoView:didUpdateContactInfoWithText:)]) {
        [self.delegate userContactInfoView:self didUpdateContactInfoWithText:self.contactInfo];
    }
    
    
    self.isEditing = NO;
    [self updateView];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    animation.startProgress = 0.0;
    animation.endProgress = 1.0;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:@"animation"];
    
    [self.textField resignFirstResponder];
}

@end
