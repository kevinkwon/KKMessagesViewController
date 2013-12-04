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

#import "DemoViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "UIButton+JSMessagesView.h"
#import "JSAvatarImageFactory.h"

#define kSubtitleJobs @"Jobs"
#define kSubtitleWoz @"Steve Wozniak"
#define kSubtitleCook @"Mr. Cook"

@implementation DemoViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";
    
    self.messageInputView.textView.placeHolder = @"Message";
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"JSMessagesViewController 한글이 지원되지 않는다. 그래서 수정한다. JSMessagesViewController 한글이 지원되지 않는다. 그래서 수정한다. JSMessagesViewController 한글이 지원되지 않는다. 그래서 수정한다. JSMessagesViewController 한글이 지원되지 않는다. 그래서 수정한다. JSMessagesViewController 한글이 지원되지 않는다. 그래서 수정한다. JSMessagesViewController 한글이 지원되지 않는다. 그래서 수정한다.",
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
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-jobs" style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeSquare], kSubtitleJobs,
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-woz" style:JSAvatarImageStyleClassic shape:JSAvatarImageShapeCircle], kSubtitleWoz,
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-cook" style:JSAvatarImageStyleClassic shape:JSAvatarImageShapeCircle], kSubtitleCook,
                    nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self
                                                                                           action:@selector(buttonPressed:)];
}

- (void)buttonPressed:(UIButton *)sender
{
    // Testing pushing/popping messages view
    DemoViewController *vc = [[DemoViewController alloc] initWithNibName:nil bundle:nil];
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
        [JSMessageSoundEffect playMessageSentSound];
        
        [self.subtitles addObject:arc4random_uniform(100) % 2 ? kSubtitleCook : kSubtitleWoz];
    }
    else {
        [JSMessageSoundEffect playMessageReceivedSound];
        
        [self.subtitles addObject:kSubtitleJobs];
    }
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          style:JSBubbleImageViewStyleClassicBlue];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type style:JSBubbleImageViewStyleClassicSquareGray];
}

- (UIButton *)buttonViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"testbutton" forState:UIControlStateNormal];
        return button;
    }
    return nil;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyIncomingOnly;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyNone;
}

- (JSMessagesViewNamePolicy)namePolicy
{
    return JSMessagesViewNamePolicyIncomingOnly;
}

#pragma mark - Messages view delegate: OPTIONAL

//  *** Implement to customize cell further
//
//  - (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
//  {
//      [cell.bubbleView setFont:[UIFont boldSystemFontOfSize:9.0]];
//      [cell.bubbleView setTextColor:[UIColor whiteColor]];
//  }

//  *** Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
- (UIButton *)sendButtonForInputView
{
    return [UIButton js_defaultSendButton_iOS6];
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

- (NSString *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [self.timestamps objectAtIndex:indexPath.row];
    NSString *timestamp = [NSDateFormatter localizedStringFromDate:date
                                                         dateStyle:NSDateFormatterMediumStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    return timestamp;
}

- (NSString *)timeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [self.timestamps objectAtIndex:indexPath.row];
    NSString *time = [NSDateFormatter localizedStringFromDate:date
                                                    dateStyle:NSDateFormatterNoStyle
                                                    timeStyle:NSDateFormatterLongStyle];
    return time;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *subtitle = [self.subtitles objectAtIndex:indexPath.row];
    UIImage *image = [self.avatars objectForKey:subtitle];
    return [[UIImageView alloc] initWithImage:image];
}

- (NSString *)nameForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.subtitles[indexPath.row];
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
