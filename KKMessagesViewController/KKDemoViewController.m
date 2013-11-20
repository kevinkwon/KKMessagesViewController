//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "KKDemoViewController.h"

#import "UIButton+KKMessagesView.h"
#import "KKAvatarImageFactory.h"

#define kSubtitleJobs @"Jobs"
#define kSubtitleWoz @"Steve Wozniak"
#define kSubtitleCook @"Mr. Cook"

@implementation KKDemoViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";
    
    self.messageInputView.textView.placeHolder = @"Message";
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"KKMessagesViewController is simple and easy to use.",
                     @"It's highly customizable.",
                     @"It even has data detectors. You can call me tonight. My cell number is 452-123-4567. \nMy website is www.hexedbits.com.",
                     @"Group chat is possible. Sound effects and images included. Animations are smooth. Messages can be of arbitrary size!",
                     nil];
    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];
    
    self.subtitles = [[NSMutableArray alloc] initWithObjects:
                      kSubtitleJobs,
                      kSubtitleWoz,
                      kSubtitleJobs,
                      kSubtitleCook, nil];
    
    self.avatars = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [KKAvatarImageFactory avatarImageNamed:@"demo-avatar-jobs" style:KKAvatarImageStyleFlat shape:KKAvatarImageShapeSquare], kSubtitleJobs,
                    [KKAvatarImageFactory avatarImageNamed:@"demo-avatar-woz" style:KKAvatarImageStyleClassic shape:KKAvatarImageShapeCircle], kSubtitleWoz,
                    [KKAvatarImageFactory avatarImageNamed:@"demo-avatar-cook" style:KKAvatarImageStyleClassic shape:KKAvatarImageShapeCircle], kSubtitleCook,
                    nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self
                                                                                           action:@selector(buttonPressed:)];
}

- (void)buttonPressed:(UIButton *)sender
{
    // Testing pushing/popping messages view
    KKDemoViewController *vc = [[KKDemoViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text
{
    [self.messages addObject:text];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messages.count - 1) % 2) {
        [KKMessageSoundEffect playMessageSentSound];
        
        [self.subtitles addObject:arc4random_uniform(100) % 2 ? kSubtitleCook : kSubtitleWoz];
    }
    else {
        [KKMessageSoundEffect playMessageReceivedSound];
        
        [self.subtitles addObject:kSubtitleJobs];
    }
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (KKBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? KKBubbleMessageTypeIncoming : KKBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(KKBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2) {
        return [KKBubbleImageViewFactory bubbleImageViewForType:type
                                                          style:KKBubbleImageViewStyleClassicBlue];
    }
    
    return [KKBubbleImageViewFactory bubbleImageViewForType:type style:KKBubbleImageViewStyleClassicSquareGray];
}

- (KKMessagesViewTimestampPolicy)timestampPolicy
{
    return KKMessagesViewTimestampPolicyEveryThree;
}

- (KKMessagesViewAvatarPolicy)avatarPolicy
{
    return KKMessagesViewAvatarPolicyAll;
}

- (KKMessagesViewSubtitlePolicy)subtitlePolicy
{
    return KKMessagesViewSubtitlePolicyAll;
}

#pragma mark - Messages view delegate: OPTIONAL

//  *** Implement to customize cell further
//
//  - (void)configureCell:(KKBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
//  {
//      [cell.bubbleView setFont:[UIFont boldSystemFontOfSize:9.0]];
//      [cell.bubbleView setTextColor:[UIColor whiteColor]];
//  }

//  *** Required if using `KKMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
- (UIButton *)sendButtonForInputView
{
    return [UIButton kk_defaultSendButton_iOS6];
}

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *subtitle = [self.subtitles objectAtIndex:indexPath.row];
    UIImage *image = [self.avatars objectForKey:subtitle];
    return [[UIImageView alloc] initWithImage:image];
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.subtitles objectAtIndex:indexPath.row];
}

@end
