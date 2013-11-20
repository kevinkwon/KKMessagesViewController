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

#import "KKAvatarImageFactory.h"
#import "UIImage+KKMessagesView.h"

CGFloat const kKKAvatarImageSize = 50.0f;

@implementation KKAvatarImageFactory

+ (UIImage *)avatarImageNamed:(NSString *)filename
                        style:(KKAvatarImageStyle)style
                        shape:(KKAvatarImageShape)shape
{
    UIImage *image = [UIImage imageNamed:filename];
    
    return [image kk_imageAsCircle:(shape == KKAvatarImageShapeCircle)
                       withDiamter:kKKAvatarImageSize
                       borderColor:(style == KKAvatarImageStyleClassic) ? [UIColor colorWithHue:0.0f saturation:0.0f brightness:0.8f alpha:1.0f] : nil
                       borderWidth:(style == KKAvatarImageStyleClassic) ? 1.0f : 0.0f
                      shadowOffSet:(style == KKAvatarImageStyleClassic) ? CGSizeMake(0.0f, 1.0f) : CGSizeZero];
}

@end
