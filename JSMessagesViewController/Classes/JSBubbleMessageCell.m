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

#import "JSBubbleMessageCell.h"

#import "JSAvatarImageFactory.h"
#import "UIColor+JSMessagesView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kJSLabelPadding = 5.0f;
static const CGFloat kJSTimeStampLabelHeight = 15.0f;
static const CGFloat kJSNameLabelHeight = 15.0f;
static const CGFloat kJSSubtitleLabelHeight = 15.0f;


@interface JSBubbleMessageCell()

- (void)setup;
- (void)configureTimestampLabel;
- (void)configureAvatarImageView:(UIImageView *)imageView forMessageType:(JSBubbleMessageType)type;
- (void)configureSubtitleLabelForMessageType:(JSBubbleMessageType)type;
- (void)configureNameLabelForMessageType:(JSBubbleMessageType)type;

- (void)configureWithType:(JSBubbleMessageType)type
          bubbleImageView:(UIImageView *)bubbleImageView
                timestamp:(BOOL)hasTimestamp
                   avatar:(BOOL)hasAvatar
				 subtitle:(BOOL)hasSubtitle
               buttonView:(UIButton *)buttonView;

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress;

- (void)handleMenuWillHideNotification:(NSNotification *)notification;
- (void)handleMenuWillShowNotification:(NSNotification *)notification;

@end


@implementation JSBubbleMessageCell

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
    
    self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.layer.borderWidth = 1;
}

- (void)configureTimestampLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kJSLabelPadding,
                                                               kJSLabelPadding,
                                                               self.contentView.frame.size.width - (kJSLabelPadding * 2.0f),
                                                               kJSTimeStampLabelHeight)];
    label.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor js_messagesTimestampColor_iOS6];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    
    label.layer.borderColor = [[UIColor redColor]CGColor];
    label.layer.borderWidth = 1;
    
    [self.contentView addSubview:label];
    [self.contentView bringSubviewToFront:label];
    _timestampLabel = label;
}

- (void)configureAvatarImageView:(UIImageView *)imageView forMessageType:(JSBubbleMessageType)type
{
    CGFloat avatarX = 0.5f;
    if(type == JSBubbleMessageTypeOutgoing) {
        avatarX = (self.contentView.frame.size.width - kJSAvatarImageSize);
    }
    
    CGFloat avatarY = 0.0f;
    if(self.timestampLabel) {
        avatarY += CGRectGetMaxY(self.timestampLabel.frame);
    }
    
    imageView.frame = CGRectMake(avatarX, avatarY, kJSAvatarImageSize, kJSAvatarImageSize);
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin
                                  | UIViewAutoresizingFlexibleRightMargin
                                  | UIViewAutoresizingFlexibleBottomMargin);
    
    [self.contentView addSubview:imageView];
    _avatarImageView = imageView;
    
    imageView.layer.borderColor = [[UIColor redColor]CGColor];
    imageView.layer.borderWidth = 1;
}

- (void)configureNameLabelForMessageType:(JSBubbleMessageType)type
{
    
    CGPoint offset = CGPointZero;
    
    offset.x = kJSLabelPadding;
    offset.y = kJSLabelPadding;
    
    if(type == JSBubbleMessageTypeIncoming) {
        if (self.avatarImageView) {
            offset.x += CGRectGetWidth(self.avatarImageView.frame) + kJSLabelPadding;
        }
    }
    
    if (self.timestampLabel) {
        offset.y = CGRectGetMaxY(self.timestampLabel.frame);
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offset.x,
                                                               offset.y,
                                                               CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.avatarImageView.frame) - (kJSLabelPadding * 2.0f),
                                                               kJSNameLabelHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = (type == JSBubbleMessageTypeOutgoing) ? NSTextAlignmentRight : NSTextAlignmentLeft;
    label.textColor = [UIColor js_messagesTimestampColor_iOS6];
    label.font = [UIFont systemFontOfSize:12.5f];
    
    [self.contentView addSubview:label];
    _nameLabel = label;
    _nameLabel.layer.borderWidth = 1;
    _nameLabel.layer.borderColor = [[UIColor redColor]CGColor];
}


- (void)configureSubtitleLabelForMessageType:(JSBubbleMessageType)type
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kJSLabelPadding,
                                                               self.contentView.frame.size.height - kJSSubtitleLabelHeight,
                                                               self.contentView.frame.size.width - (kJSLabelPadding * 2.0f),
                                                               kJSSubtitleLabelHeight)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = (type == JSBubbleMessageTypeOutgoing) ? NSTextAlignmentRight : NSTextAlignmentLeft;
    label.textColor = [UIColor js_messagesTimestampColor_iOS6];
    label.font = [UIFont systemFontOfSize:12.5f];
    
    [self.contentView addSubview:label];
    _subtitleLabel = label;
    _subtitleLabel.layer.borderWidth = 1;
    _subtitleLabel.layer.borderColor = [[UIColor redColor]CGColor];
}

- (void)configureWithType:(JSBubbleMessageType)type
          bubbleImageView:(UIImageView *)bubbleImageView
                timestamp:(BOOL)hasTimestamp
                   avatar:(BOOL)hasAvatar
				 subtitle:(BOOL)hasSubtitle
               buttonView:(UIButton *)buttonView
{
    _type = type;
    
    // 위치 정해짐
    if (hasTimestamp) {
        [self configureTimestampLabel];
    }
    
    // 서브타이틀을 만든다.
    if (hasSubtitle) {
		[self configureSubtitleLabelForMessageType:type];
	}
    
    if (hasAvatar) {
        [self configureAvatarImageView:[[UIImageView alloc] init] forMessageType:type];
    }
    
    // 이름은 무조건 들어감
    [self configureNameLabelForMessageType:type];
    
    JSBubbleView *bubbleView = [[JSBubbleView alloc] initWithFrame:CGRectZero
                                                        bubbleType:type
                                                   bubbleImageView:bubbleImageView
                                                        buttonView:buttonView];
    
    [self.contentView addSubview:bubbleView];
    [self.contentView sendSubviewToBack:bubbleView];
    _bubbleView = bubbleView;
}

#pragma mark - Initialization
- (instancetype)initWithBubbleType:(JSBubbleMessageType)type
                   bubbleImageView:(UIImageView *)bubbleImageView
                      hasTimestamp:(BOOL)hasTimestamp
                         hasAvatar:(BOOL)hasAvatar
                       hasSubtitle:(BOOL)hasSubtitle
                        buttonView:(UIButton *)buttonView
                   reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        
        [self configureWithType:type
                bubbleImageView:bubbleImageView
                      timestamp:hasTimestamp
                         avatar:hasAvatar
                       subtitle:hasSubtitle
                     buttonView:buttonView];
    }
    return self;
}

- (void)dealloc
{
    _bubbleView = nil;
    _timestampLabel = nil;
    _avatarImageView = nil;
    _subtitleLabel = nil;
    _nameLabel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Setters

- (void)setMessage:(NSString *)msg
{
    self.bubbleView.text = msg;
}

- (void)setTimestamp:(NSString *)date
{
    self.timestampLabel.text = date;
}

- (void)setAvatarImageView:(UIImageView *)imageView
{
    [_avatarImageView removeFromSuperview];
    _avatarImageView = nil;
    
    [self configureAvatarImageView:imageView forMessageType:[self messageType]];
}

- (void)setSubtitle:(NSString *)subtitle
{
	self.subtitleLabel.text = subtitle;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (void)setTime:(NSString *)time
{
    self.bubbleView.time = time;
}

#pragma mark - Getters

- (JSBubbleMessageType)messageType
{
    return self.bubbleView.type;
}

- (CGFloat)height
{
    CGFloat timestampHeight = (self.timestampLabel) ? kJSTimeStampLabelHeight : 0.0f;
    CGFloat nameHeight = self.nameLabel ? CGRectGetHeight(self.nameLabel.frame) : 0.0f;
    CGFloat avatarHeight = (self.avatarImageView) ? kJSAvatarImageSize : 0.0f;
	CGFloat subtitleHeight = self.subtitleLabel ? kJSSubtitleLabelHeight : 0.0f;

    CGFloat subviewHeights = kJSLabelPadding + timestampHeight + nameHeight + subtitleHeight ;
    
    subviewHeights = subviewHeights + MAX(avatarHeight, [self.bubbleView neededHeightForCell]);

    return subviewHeights;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat bubbleY = 0.0f; // 버블뷰 offset
    CGFloat bubbleX = 0.0f;
    
    CGFloat offsetX = 0.0f;
    
    
    bubbleY += CGRectGetMaxY(self.nameLabel.frame);
    
    if (self.avatarImageView) {
        offsetX = 4.0f;
        bubbleX = kJSAvatarImageSize;
        if(self.type == JSBubbleMessageTypeOutgoing) {
            offsetX = kJSAvatarImageSize - 4.0f;
        }
    }
    
    CGRect frame = CGRectMake(bubbleX - offsetX,
                              bubbleY,
                              self.contentView.frame.size.width - bubbleX,
                              CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(_nameLabel.frame) - CGRectGetHeight(_subtitleLabel.frame));
 
    self.bubbleView.frame = frame;
    
    if(self.subtitleLabel) {
        self.subtitleLabel.frame = CGRectMake(kJSLabelPadding,
                                              self.contentView.frame.size.height - kJSSubtitleLabelHeight,
                                              self.contentView.frame.size.width - (kJSLabelPadding * 2.0f),
                                              kJSSubtitleLabelHeight);
    }
}

#pragma mark - Copying

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:[self.bubbleView text]];
    [self resignFirstResponder];
}

#pragma mark - Gestures

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    CGRect targetRect = [self convertRect:[self.bubbleView bubbleFrame]
                                 fromView:self.bubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    self.bubbleView.bubbleImageView.highlighted = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    self.bubbleView.bubbleImageView.highlighted = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

@end