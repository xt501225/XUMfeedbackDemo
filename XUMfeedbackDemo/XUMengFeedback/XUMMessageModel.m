//
//  XUMMessageModel.m
//  XUMFeedback
//
//  Created by tenric on 15/12/2.
//  Copyright © 2015年 tenric. All rights reserved.
//

#import "XUMMessageModel.h"
#import "XUMFeedback.h"
#import "JSQMessages.h"

@implementation XUMMessageModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        JSQMessagesAvatarImage *meImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"我"
                                                                                     backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                           textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                font:[UIFont systemFontOfSize:16.0f]
                                                                                            diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *adminImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:kXUMAvatarImageNameAdmin]
                                                                                        diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        
        self.avatars = @{ kXUMAvatarIdMe : meImage,
                          kXUMAvatarIdAdmin : adminImage };
        
        
        self.users = @{ kXUMAvatarIdMe : kXUMAvatarDisplayNameMe,
                        kXUMAvatarIdAdmin : kXUMAvatarDisplayNameAdmin };
        
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
        self.messages = [NSMutableArray array];
        
        self.contactInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kXUMContactInfoKey];
        
    }
    
    return self;
}



@end
