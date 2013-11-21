//
//  NSString+KKMessageView.h
//  resizeTextView
//
//  Created by Kevin on 2013. 11. 21..
//  Copyright (c) 2013년 Kevin Kwon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KKMessageView)

/**
 * Return size to fit given constraints size
 */
- (CGSize)sizeTextViewWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
