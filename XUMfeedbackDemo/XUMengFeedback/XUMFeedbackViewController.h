//
//  XUMFeedbackViewController.h
//  XUMFeedback
//
//  Created by tenric on 15/12/2.
//  Copyright © 2015年 tenric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"

@class XUMFeedbackViewController;

@protocol XUMFeedbackViewControllerDelegate <NSObject>

- (void)didDismissXUMFeedbackViewController:(XUMFeedbackViewController *)vc;

@end


@class XUMMessageModel;

@interface XUMFeedbackViewController : JSQMessagesViewController

@property (nonatomic, weak) id<XUMFeedbackViewControllerDelegate> delegate;

@property (nonatomic, strong) XUMMessageModel *messageModel;

@end
