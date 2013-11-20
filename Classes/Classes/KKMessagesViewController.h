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

#import <UIKit/UIKit.h>
#import "KKBubbleMessageCell.h"
#import "KKMessageInputView.h"
#import "KKMessageSoundEffect.h"

/**
 *  The frequency with which timestamps are displayed in the messages table view.
 */
typedef NS_ENUM(NSUInteger, KKMessagesViewTimestampPolicy) {
    /**
     *  Displays a timestamp above every message bubble.
     */
    KKMessagesViewTimestampPolicyAll,
    /**
     *  Displays a timestamp above every second message bubble.
     */
    KKMessagesViewTimestampPolicyAlternating,
    /**
     *  Displays a timestamp above every third message bubble.
     */
    KKMessagesViewTimestampPolicyEveryThree,
    /**
     *  Displays a timestamp above every fifth message bubble.
     */
    KKMessagesViewTimestampPolicyEveryFive,
    /**
     *  Displays a timestamp based on the result of the optional delegate method `hasTimestampForRowAtIndexPath:`. 
     *  @see KKMessagesViewDelegate.
     */
    KKMessagesViewTimestampPolicyCustom
};

/**
 *  The method by which avatars are displayed in the messages table view.
 */
typedef NS_ENUM(NSUInteger, KKMessagesViewAvatarPolicy) {
    /**
     *  Displays an avatar for all incoming and all outgoing messages.
     */
    KKMessagesViewAvatarPolicyAll,
    /**
     *  Displays an avatar for incoming messages only.
     */
    KKMessagesViewAvatarPolicyIncomingOnly,
    /**
     *  Display an avatar for outgoing messages only.
     */
    KKMessagesViewAvatarPolicyOutgoingOnly,
    /**
     *  Does not display any avatars.
     */
    KKMessagesViewAvatarPolicyNone
};

/**
 *  The method by which subtitles are displayed in the messages table view.
 */
typedef NS_ENUM(NSUInteger, KKMessagesViewSubtitlePolicy) {
    /**
     *  Displays a subtitle for all incoming and all outgoing messages.
     */
    KKMessagesViewSubtitlePolicyAll,
    /**
     *  Displays a subtitle for incoming messages only.
     */
    KKMessagesViewSubtitlePolicyIncomingOnly,
    /**
     *  Displays a subtitle for outgoing messages only.
     */
    KKMessagesViewSubtitlePolicyOutgoingOnly,
    /**
     *  Does not display any subtitles.
     */
    KKMessagesViewSubtitlePolicyNone
};

/**
 *  The delegate of a `KKMessagesViewController` must adopt the `KKMessagesViewDelegate` protocol.
 */
@protocol KKMessagesViewDelegate <NSObject>

@required

/**
 *  Tells the delegate that the specified text has been sent. Hook into your own backend here.
 *
 *  @param text A string containing the text that was present in the messageInputView's textView when the send button was pressed.
 */
- (void)didSendText:(NSString *)text;

/**
 *  Asks the delegate for the message type for the row at the specified index path.
 *
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return A constant describing the message type. 
 *  @see KKBubbleMessageType.
 */
- (KKBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Asks the delegate for the bubble image view for the row at the specified index path with the specified type.
 *
 *  @param type      The type of message for the row located at indexPath.
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return A `UIImageView` with both `image` and `highlightedImage` properties set. 
 *  @see KKBubbleImageViewFactory.
 */
- (UIImageView *)bubbleImageViewWithType:(KKBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Asks the delegate for the timestamp policy.
 *
 *  @return A constant describing the timestamp policy. 
 *  @see KKMessagesViewTimestampPolicy.
 */
- (KKMessagesViewTimestampPolicy)timestampPolicy;

/**
 *  Asks the delegate for the avatar policy.
 *
 *  @return A constant describing the avatar policy. 
 *  @see KKMessagesViewAvatarPolicy.
 */
- (KKMessagesViewAvatarPolicy)avatarPolicy;

/**
 *  Asks the delegate for the subtitle policy.
 *
 *  @return A constant describing the subtitle policy. 
 *  @see KKMessagesViewSubtitlePolicy.
 */
- (KKMessagesViewSubtitlePolicy)subtitlePolicy;

@optional

/**
 *  Tells the delegate to configure or further customize the given cell at the specified index path.
 *
 *  @param cell      The message cell to configure.
 *  @param indexPath The index path for cell.
 */
- (void)configureCell:(KKBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  Asks the delegate if the row at the specified index path should display a timestamp. You should only implement this method if using `KKMessagesViewTimestampPolicyCustom`. @see KKMessagesViewTimestampPolicy.
 *
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return `YES` if the row should display a timestamp, `NO` otherwise.
 */
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Asks the delegate if should always scroll to bottom automatically when new messages are sent or received.
 *
 *  @return `YES` if you would like to prevent the table view from being scrolled to the bottom while the user is scrolling the table view manually, `NO` otherwise.
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling;

/**
 *  Asks the delegate for the send button to be used in messageInputView. Implement this method if you wish to use a custom send button. The button must be a `UIButton` or a subclass of `UIButton`. The button's frame is set for you.
 *
 *  @return A custom `UIButton` to use in messageInputView.
 */
- (UIButton *)sendButtonForInputView;

@end



@protocol KKMessagesViewDataSource <NSObject>

@required

/**
 *  Asks the data source for the text to display for the row at the specified index path.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return A string containing text for a message. This value must not be `nil`.
 */
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Asks the data source for the date to display in the timestamp label *above* the row at the specified index path.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return A date object specifying when the message at indexPath was sent. This value may be `nil`.
 */
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Asks the data source for the imageView to display for the row at the specified index path. The imageView must have its `image` property set.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return An image view specifying the avatar for the message at indexPath. This value may be `nil`.
 */
- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Asks the data source for the text to display in the subtitle label *below* the row at the specified index path.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return A string containing the subtitle for the message at indexPath. This value may be `nil`.
 */
- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


/**
 *  An instance of `KKMessagesViewController` is a subclass of `UIViewController` specialized to display a messaging interface.
 */
@interface KKMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

/**
 *  The object that acts as the delegate of the receiving messages view.
 */
@property (weak, nonatomic) id<KKMessagesViewDelegate> delegate;

/**
 *  The object that acts as the data source of receiving messages view.
 */
@property (weak, nonatomic) id<KKMessagesViewDataSource> dataSource;

/**
 *  Returns the message input view with which new messages are composed.
 */
@property (weak, nonatomic, readonly) KKMessageInputView *messageInputView;

#pragma mark - Messages view controller

/**
 *  Animates and resets the text view in messageInputView. Call this method at the end of the delegate method `didSendText:`. 
 *  @see KKMessagesViewDelegate.
 */
- (void)finishSend;


/**
 *  Sets the background color of the table view, the table view cells, and the table view separator.
 *
 *  @param color The color to be used as the new background color.
 */
- (void)setBackgroundColor:(UIColor *)color;

/**
 *  Scrolls the table view such that the bottom most cell is completely visible, above the messageInputView. 
 *
 *  This method respects the delegate method `shouldPreventScrollToBottomWhileUserScrolling`. 
 *
 *  @see KKMessagesViewDelegate.
 *
 *  @param animated `YES` if you want to animate scrolling, `NO` if it should be immediate.
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 *  Scrolls the receiver until a row identified by index path is at a particular location on the screen. 
 *
 *  This method respects the delegate method `shouldPreventScrollToBottomWhileUserScrolling`. 
 *
 *  @see KKMessagesViewDelegate.
 *
 *  @param indexPath An index path that identifies a row in the table view by its row index and its section index.
 *  @param position  A constant defined in `UITableViewScrollPosition` that identifies a relative position in the receiving table view.
 *  @param animated  `YES` if you want to animate the change in position, `NO` if it should be immediate.
 */
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated;

@end