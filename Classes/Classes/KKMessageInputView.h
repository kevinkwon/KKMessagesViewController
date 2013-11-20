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
#import "KKMessageTextView.h"

/**
 *  An instance of `KKMessageInputView` defines the input toolbar for composing a new message that is to be displayed above the keyboard.
 */
@interface KKMessageInputView : UIImageView

/**
 *  Returns the textView into which a new message is composed. This property is never `nil`.
 */
@property (weak, nonatomic, readonly) KKMessageTextView *textView;

/**
 *  The send button for the input view. The default value is `nil`.
 */
@property (weak, nonatomic) UIButton *sendButton;

#pragma mark - Initialization

/**
 *  Initializes and returns an input view having the given frame, delegate, keyboardDelegate, and panGestureRecognizer
 *
 *  @param frame                A rectangle specifying the initial location and size of the bubble view in its superview's coordinates.
 *  @param delegate             An object that conforms to the `UITextViewDelegate` protocol.
 *  @param keyboardDelegate     An object that conforms to the `KKDismissiveTextViewDelegate` protocol. @see KKDismissiveTextViewDelegate.
 *  @param panGestureRecognizer A `UIPanGestureRecognizer` used to dismiss the input view by dragging down.
 *
 *  @return An initialized `KKMessageInputView` object or `nil` if the object could not be successfully initialized.
 */
- (instancetype)initWithFrame:(CGRect)frame
             textViewDelegate:(id<UITextViewDelegate>)delegate
             keyboardDelegate:(id<KKDismissiveTextViewDelegate>)keyboardDelegate
         panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

#pragma mark - Message input view

/**
 *  Adjusts the input view's frame height by the given value.
 *
 *  @param changeInHeight The delta value by which to increase or decrease the existing height for the input view.
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

/**
 *  @return A constant indicating the height of one line of text in the input view.
 */
+ (CGFloat)textViewLineHeight;

/**
 *  @return A contant indicating the maximum number of lines of text that can be displayed in the textView.
 */
+ (CGFloat)maxLines;

/**
 *  @return The maximum height of the input view as determined by `maxLines` and `textViewLineHeight`. This value is used for controlling the animation of the growing and shrinking of the input view as the text changes in the textView.
 */
+ (CGFloat)maxHeight;

/**
 *  @return A constant indicating the default height of the input view when no text is displayed in the textView.
 */
+ (CGFloat)defaultHeight;

@end