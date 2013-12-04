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

#import "JSBubbleView.h"

#import "JSMessageInputView.h"
#import "JSAvatarImageFactory.h"
#import "NSString+JSMessagesView.h"
#import "NSString+Size.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+JSMessagesView.h"

CGFloat const kMarginTop = 4.0f;
CGFloat const kMarginBottom = 4.0f;
CGFloat const kPaddingTop = 8.0f;
CGFloat const kPaddingBottom = 12.0f;
CGFloat const kBubblePaddingRight = 30.0f;
CGFloat const kButtonHeight = 33.0f; // 버튼 높이
CGFloat const kKKPadding = 4.0f;

@interface JSBubbleView()
{
    CGFloat _maxWidth;
}

- (void)setup;

- (CGSize)textSizeForText:(NSString *)txt;
- (CGSize)bubbleSizeForText:(NSString *)txt;
- (CGSize)bubbleSizeForText:(NSString *)txt button:(UIButton *)button;

@end


@implementation JSBubbleView

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
                   bubbleType:(JSBubbleMessageType)bubleType
              bubbleImageView:(UIImageView *)bubbleImageView
                   buttonView:(UIButton *)buttonView
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        
        _maxWidth = [UIScreen mainScreen].applicationFrame.size.width * 0.50f;
        
        _type = bubleType;
        
        bubbleImageView.userInteractionEnabled = YES;
        [self addSubview:bubbleImageView];
        _bubbleImageView = bubbleImageView;
        
        UILabel *textView = [[UILabel alloc] initWithFrame:CGRectZero];
        textView.font = [UIFont systemFontOfSize:16.0f];
        textView.textColor = [UIColor blackColor];
        textView.userInteractionEnabled = YES;
        textView.lineBreakMode = NSLineBreakByWordWrapping;
        textView.numberOfLines= 0;
        textView.backgroundColor = [UIColor clearColor];
        [self addSubview:textView];
        [self bringSubviewToFront:textView];
        _textView = textView;
        
        if (buttonView) {
            [self addSubview:buttonView];
            _button = buttonView;
        }
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.textColor = [UIColor js_messagesTimestampColor_iOS6];
        timeLabel.font = [UIFont systemFontOfSize:12.5f];
        timeLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
        
//        NOTE: TODO: textView frame & text inset
//        --------------------
//        future implementation for textView frame
//        in layoutSubviews : "self.textView.frame = textFrame;" is not needed
//        when setting the property : "_textView.textContainerInset = UIEdgeInsetsZero;"
//        unfortunately, this API is available in iOS 7.0+
//        update after dropping support for iOS 6.0
//        --------------------
    }
    return self;
}

- (void)dealloc
{
    _bubbleImageView = nil;
    _textView = nil;
}

#pragma mark - Setters

- (void)setType:(JSBubbleMessageType)type
{
    _type = type;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    self.textView.text = text;
    [self setNeedsLayout];
}

- (void)setTime:(NSString *)time
{
    self.timeLabel.text = time;
    [self.timeLabel sizeToFit];
    [self setNeedsLayout];
}


- (void)setFont:(UIFont *)font
{
    self.textView.font = font;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textView.textColor = textColor;
    [self setNeedsLayout];
}

- (void)setButton:(UIButton *)button
{
    _button = button;
    [self setNeedsLayout];
}

#pragma mark - Getters

- (NSString *)text
{
    return self.textView.text;
}

- (NSString *)time
{
    return self.timeLabel.text;
}

- (UIFont *)font
{
    return self.textView.font;
}

- (UIColor *)textColor
{
    return self.textView.textColor;
}

- (CGRect)bubbleFrame
{
    CGSize bubbleSize = [self bubbleSizeForText:self.textView.text button:self.button];
    
    return CGRectMake((self.type == JSBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width : 0.0f),
                      kMarginTop,
                      bubbleSize.width,
                      bubbleSize.height);
}

// 셀에서 필요한 버블뷰 높이
- (CGFloat)neededHeightForCell;
{
    // 버블사이즈에 상단마진, 하단마진을 더한다.
    CGFloat height = [self bubbleSizeForText:self.textView.text button:self.button].height + kMarginTop + kMarginBottom;
    return height;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bubbleImageView.frame = [self bubbleFrame];
    
    CGFloat textX = self.bubbleImageView.frame.origin.x + 10;
    
    if(self.type == JSBubbleMessageTypeIncoming) {
        textX += (self.bubbleImageView.image.capInsets.left / 2.0f);
    }
    
    
    CGSize textSize = [self textSizeForText:self.textView.text];
    
    CGRect textFrame = CGRectMake(textX,
                                  CGRectGetMinY(self.bubbleImageView.frame) + kPaddingTop,
                                  textSize.width,
                                  textSize.height);
    self.textView.frame = textFrame;
    
    if (self.button) {
        self.button.frame = CGRectMake(CGRectGetMinX(self.textView.frame),
                                       CGRectGetMaxY(self.textView.frame) + kKKPadding,
                                       self.bubbleImageView.frame.size.width - 30,
                                       kButtonHeight);
    }
    
    // 오른정렬
    if (self.type == JSBubbleMessageTypeIncoming) {
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.bubbleImageView.frame),
                                          CGRectGetMaxY(self.bubbleImageView.frame) - CGRectGetHeight(self.timeLabel.frame),
                                          CGRectGetWidth(self.timeLabel.frame),
                                          CGRectGetHeight(self.timeLabel.frame));
    }
    // 왼쪽정렬
    else {
        self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.bubbleImageView.frame) - CGRectGetWidth(self.timeLabel.frame),
                                          CGRectGetMaxY(self.bubbleImageView.frame) - CGRectGetHeight(self.timeLabel.frame),
                                          CGRectGetWidth(self.timeLabel.frame),
                                          CGRectGetHeight(self.timeLabel.frame));
    }

}

#pragma mark - Bubble view

- (CGSize)textSizeForText:(NSString *)txt
{
    CGSize size = [txt boundingSize:CGSizeMake(_maxWidth, CGFLOAT_MAX) font:self.textView.font];

    return size;
}

- (CGSize)bubbleSizeForText:(NSString *)txt
{
	CGSize textSize = [self textSizeForText:txt];
    
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

- (CGSize)bubbleSizeForText:(NSString *)txt button:(UIButton *)button
{
    CGSize textSizeWithButton = [self bubbleSizeForText:txt];
    
    if (button) {
        textSizeWithButton.width = _maxWidth;
        textSizeWithButton.height += kKKPadding + kButtonHeight;
    }
    
    return textSizeWithButton;
}

@end