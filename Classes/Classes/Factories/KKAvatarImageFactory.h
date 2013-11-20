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

extern CGFloat const kKKAvatarImageSize;

typedef NS_ENUM(NSUInteger, KKAvatarImageStyle) {
    KKAvatarImageStyleClassic,
    KKAvatarImageStyleFlat
};


typedef NS_ENUM(NSUInteger, KKAvatarImageShape) {
    KKAvatarImageShapeCircle,
    KKAvatarImageShapeSquare
};


@interface KKAvatarImageFactory : NSObject

+ (UIImage *)avatarImageNamed:(NSString *)filename
                        style:(KKAvatarImageStyle)style
                        shape:(KKAvatarImageShape)shape;

@end
