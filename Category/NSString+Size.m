//
//  NSString+Size.m
//  resizeTextView
//
//  Created by Kevin on 2013. 11. 21..
//  Copyright (c) 2013년 Kevin Kwon. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)boundingSize:(CGSize)size font:(UIFont*)font
{
    CGSize resultSize;
    
#ifdef __IPHONE_7_0
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        NSLog(@"iOS7, sdk7");
        resultSize = [self boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil].size;
    }
    else {
//        NSLog(@"iOS6, sdk7");
//#   pragma clang diagnostic push
//#   pragma clang diagnostic ignored "-Wdeprecated-declarations"
        resultSize = [self sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
//#   pragma clang diagnostic pop
    }
#else
//#   pragma clang diagnostic push
//#   pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    NSLog(@"iOS6, sdk6");
    resultSize = [self sizeWithFont:font
                  constrainedToSize:size
                      lineBreakMode:NSLineBreakByWordWrapping];
//#   pragma clang diagnostic pop
#endif
    resultSize.width = ceil(resultSize.width);
    resultSize.height = ceil(resultSize.height);
    
    return resultSize;
}

- (CGSize)boundingTextViewSize:(CGSize)size font:(UIFont*)font
{
    CGSize newSize = CGSizeZero;

    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, size.width, CGFLOAT_MAX)];
    textView.font = font;
    textView.text = self;
    newSize = [textView sizeThatFits:size];

    return newSize;

}

@end
