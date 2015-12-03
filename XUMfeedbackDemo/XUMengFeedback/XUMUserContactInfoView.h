//
//  XUMUserContactInfoView.h
//  XUMFeedback
//
//  Created by tenric on 15/12/2.
//  Copyright © 2015年 tenric. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XUMUserContactInfoView;

@protocol XUMUserContactInfoViewDelegate <NSObject>

- (void)userContactInfoView:(XUMUserContactInfoView*)userContactInfoView didUpdateContactInfoWithText:(NSString*)text;

@end

@interface XUMUserContactInfoView : UIView

@property (nonatomic, copy) NSString *contactInfo;

@property (nonatomic, weak) id<XUMUserContactInfoViewDelegate> delegate;

- (void)updateView;

- (void)activate;

@end
