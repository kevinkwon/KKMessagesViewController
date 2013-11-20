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

#import "KKBubbleImageViewFactory.h"
#import "UIImage+KKMessagesView.h"

static NSDictionary *bubbleImageDictionary;

@interface KKBubbleImageViewFactory()

+ (UIImageView *)bubbleImageViewForStyle:(KKBubbleImageViewStyle)style isOutgoing:(BOOL)isOutgoing;
+ (UIImage *)highlightedBubbleImageForStyle:(KKBubbleImageViewStyle)style;
+ (UIEdgeInsets)bubbleImageCapInsetsForStyle:(KKBubbleImageViewStyle)style isOutgoing:(BOOL)isOutgoing;

@end



@implementation KKBubbleImageViewFactory

#pragma mark - Initialization

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bubbleImageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"bubble-classic-gray", @(KKBubbleImageViewStyleClassicGray),
                                 @"bubble-classic-blue", @(KKBubbleImageViewStyleClassicBlue),
                                 @"bubble-classic-green", @(KKBubbleImageViewStyleClassicGreen),
                                 @"bubble-classic-square-gray", @(KKBubbleImageViewStyleClassicSquareGray),
                                 @"bubble-classic-square-blue", @(KKBubbleImageViewStyleClassicSquareBlue),
                                 nil];
    });
}

#pragma mark - Public

+ (UIImageView *)bubbleImageViewForType:(KKBubbleMessageType)type
                                  style:(KKBubbleImageViewStyle)style
{
    return [KKBubbleImageViewFactory bubbleImageViewForStyle:style
                                                  isOutgoing:type == KKBubbleMessageTypeOutgoing];
}

#pragma mark - Private

+ (UIImageView *)bubbleImageViewForStyle:(KKBubbleImageViewStyle)style isOutgoing:(BOOL)isOutgoing
{
    UIImage *image = [UIImage imageNamed:[bubbleImageDictionary objectForKey:@(style)]];
    UIImage *highlightedImage = [KKBubbleImageViewFactory highlightedBubbleImageForStyle:style];
    
    if(!isOutgoing) {
        image = [image kk_imageFlippedHorizontal];
        highlightedImage = [highlightedImage kk_imageFlippedHorizontal];
    }
    
    UIEdgeInsets capInsets = [KKBubbleImageViewFactory bubbleImageCapInsetsForStyle:style
                                                                         isOutgoing:isOutgoing];
    
    return [[UIImageView alloc] initWithImage:[image kk_stretchableImageWithCapInsets:capInsets]
                             highlightedImage:[highlightedImage kk_stretchableImageWithCapInsets:capInsets]];
}

+ (UIImage *)highlightedBubbleImageForStyle:(KKBubbleImageViewStyle)style
{
    switch (style) {
        case KKBubbleImageViewStyleClassicGray:
        case KKBubbleImageViewStyleClassicBlue:
        case KKBubbleImageViewStyleClassicGreen:
            return [UIImage imageNamed:@"bubble-classic-selected"];
            
        case KKBubbleImageViewStyleClassicSquareGray:
        case KKBubbleImageViewStyleClassicSquareBlue:
            return [UIImage imageNamed:@"bubble-classic-square-selected"];
            
        default:
            return nil;
    }
}

+ (UIEdgeInsets)bubbleImageCapInsetsForStyle:(KKBubbleImageViewStyle)style isOutgoing:(BOOL)isOutgoing
{
    switch (style) {
        case KKBubbleImageViewStyleClassicGray:
        case KKBubbleImageViewStyleClassicBlue:
        case KKBubbleImageViewStyleClassicGreen:
            return UIEdgeInsetsMake(15.0f, 20.0f, 15.0f, 20.0f);
            
        case KKBubbleImageViewStyleClassicSquareGray:
        case KKBubbleImageViewStyleClassicSquareBlue:
            return isOutgoing ? UIEdgeInsetsMake(15.0f, 18.0f, 16.0f, 23.0f) : UIEdgeInsetsMake(15.0f, 25.0f, 16.0f, 23.0f);
            
        default:
            return UIEdgeInsetsZero;
    }
}

@end
