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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KKBubbleMessageType) {
    KKBubbleMessageTypeIncoming,
    KKBubbleMessageTypeOutgoing
};


typedef NS_ENUM(NSUInteger, KKBubbleImageViewStyle) {
    KKBubbleImageViewStyleClassicGray,
    KKBubbleImageViewStyleClassicBlue,
    KKBubbleImageViewStyleClassicGreen,
    KKBubbleImageViewStyleClassicSquareGray,
    KKBubbleImageViewStyleClassicSquareBlue
};


@interface KKBubbleImageViewFactory : NSObject

+ (UIImageView *)bubbleImageViewForType:(KKBubbleMessageType)type
                                  style:(KKBubbleImageViewStyle)style;

@end
