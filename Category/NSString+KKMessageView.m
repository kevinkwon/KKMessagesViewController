//
//  NSString+KKMessageView.m
//  resizeTextView
//
//  Created by Kevin on 2013. 11. 21..
//  Copyright (c) 2013년 Kevin Kwon. All rights reserved.
//

#import "NSString+KKMessageView.h"

@implementation NSString (KKMessageView)

- (CGSize)sizeTextViewWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize newSize = CGSizeZero;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, size.width, CGFLOAT_MAX)];
    textView.font = font;
    textView.text = self;
    newSize = [textView sizeThatFits:size];
    
    return newSize;
}

@end
