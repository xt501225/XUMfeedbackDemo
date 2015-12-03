//
//  XUMFeedbackViewController.m
//  XUMFeedback
//
//  Created by tenric on 15/12/2.
//  Copyright © 2015年 tenric. All rights reserved.
//

#import "XUMFeedbackViewController.h"
#import "XUMMessageModel.h"
#import "UMFeedback.h"
#import "XUMUserContactInfoView.h"
#import "XUMFeedback.h"

static int kUserContactInfoHeight = 44.0f;

@interface XUMFeedbackViewController ()
<XUMUserContactInfoViewDelegate>

@property (nonatomic, strong) UMFeedback *feedback;

@property (nonatomic, strong) XUMUserContactInfoView *userContactInfoView;

@property (nonatomic, copy) NSString *messageText;

@property (nonatomic, strong) NSDate *messageDate;

@end

@implementation XUMFeedbackViewController

#pragma mark - Life Circle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.title = @"用户反馈";
        
        self.senderId = kXUMAvatarIdMe;
        self.senderDisplayName = kXUMAvatarDisplayNameMe;
        
        self.messageModel = [[XUMMessageModel alloc] init];
        self.feedback = [UMFeedback sharedInstance];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, kUserContactInfoHeight);
    self.userContactInfoView = [[XUMUserContactInfoView alloc] initWithFrame:rect];
    self.userContactInfoView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    self.userContactInfoView.delegate = self;
    [self.view addSubview:self.userContactInfoView];
    
    self.userContactInfoView.contactInfo = self.messageModel.contactInfo;
    [self.userContactInfoView updateView];
    
    __weak __typeof(self) weakSelf = self;
    
    [self.feedback get:^(NSError *error) {
        
        if (error == nil) {
            
            [weakSelf buildMessages];
            
            [self.collectionView reloadData];
            
            [self scrollToBottomAnimated:YES];
        }
        else {
            NSLog(@"Query Error:%@",error.localizedDescription);
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegate) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (void)closePressed:(UIBarButtonItem *)sender
{
    if ([self.delegate respondsToSelector:@selector(didDismissXUMFeedbackViewController:)]) {
        [self.delegate didDismissXUMFeedbackViewController:self];
    }
}


#pragma mark - Private methods

- (void)buildMessages
{
    NSArray *topicAndReplies = self.feedback.topicAndReplies;
    for (NSDictionary* replyDic in topicAndReplies) {
        
        NSString *senderId = kXUMAvatarIdMe;
        NSString *senderDisplayName = kXUMAvatarDisplayNameMe;
        NSString *messageContent = replyDic[@"content"];
        NSNumber *timeInterval = replyDic[@"created_at"];
        NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]/1000];
        
        if ([replyDic[@"type"] isEqualToString:@"dev_reply"]){
            senderId = kXUMAvatarIdAdmin;
            senderDisplayName = kXUMAvatarDisplayNameAdmin;
        }
        
        
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                                 senderDisplayName:senderDisplayName
                                                              date:messageDate
                                                              text:messageContent];
        
        [self.messageModel.messages addObject:message];
    }
}

- (void)sendMessageWithText:(NSString*)text
                   senderId:(NSString *)senderId
          senderDisplayName:(NSString *)senderDisplayName
                       date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.messageModel.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    
    [self.feedback post:@{@"content":text} completion:^(NSError *error) {
        if (error) {
            NSLog(@"Send Error:%@",error.localizedDescription);
        }
    }];
}

#pragma mark - XUMUserContactInfoViewDelegate

- (void)userContactInfoView:(XUMUserContactInfoView*)userContactInfoView didUpdateContactInfoWithText:(NSString*)text
{
    self.messageModel.contactInfo = text;
    
    [[NSUserDefaults standardUserDefaults] setObject:text forKey:kXUMContactInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!text) {
        text = @"";
    }
    
    NSDictionary* userInfoDic = @{
                                  @"contact": @{
                                      @"email":@"",
                                      @"phone":@"",
                                      @"qq": @"",
                                      @"plain": text
                                      }
                                  };
    [self.feedback updateUserInfo:userInfoDic completion:^(NSError *error) {
        if (error) {
            NSLog(@"Update Contact Info Error:%@",error.localizedDescription);
        }
    }];
    
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    self.messageText = text;
    self.messageDate = date;
    
    if (!self.messageModel.contactInfo || self.messageModel.contactInfo.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要发送反馈吗？"
                                                            message:@"您还没有添加联系方式\n我们可能无法更好地与您沟通"
                                                           delegate:self
                                                  cancelButtonTitle:@"发送"
                                                  otherButtonTitles:@"添加联系方式", nil];
        [alertView show];
        
        return;
    }
    
    [self sendMessageWithText:text senderId:senderId senderDisplayName:senderDisplayName date:date];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self sendMessageWithText:self.messageText
                         senderId:self.senderId
                senderDisplayName:self.senderDisplayName
                             date:self.messageDate];
    }
    else {
        [self.userContactInfoView activate];
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    
}


#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messageModel.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageModel.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.messageModel.outgoingBubbleImageData;
    }
    
    return self.messageModel.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageModel.messages objectAtIndex:indexPath.item];
    return [self.messageModel.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageModel.messages objectAtIndex:indexPath.item];
    return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageModel.messages objectAtIndex:indexPath.item];

    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }

    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messageModel.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messageModel.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *currentMessage = [self.messageModel.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}



@end
