//
//  XUMMessageModel.h
//  XUMFeedback
//
//  Created by tenric on 15/12/2.
//  Copyright © 2015年 tenric. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSQMessagesBubbleImage;

@interface XUMMessageModel : NSObject

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSDictionary *users;

@property (nonatomic, strong) NSDictionary *avatars;

@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (nonatomic, copy)   NSString *contactInfo;

@end
