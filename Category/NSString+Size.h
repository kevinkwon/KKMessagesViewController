//
//  NSString+Size.h
//  resizeTextView
//
//  Created by Kevin on 2013. 11. 21..
//  Copyright (c) 2013년 Kevin Kwon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

/**
 * Return size to fit given constraints size
 * iOS7, iOS6, SDK6, SDK7
 */
- (CGSize)boundingSize:(CGSize)size font:(UIFont*)font;

- (CGSize)boundingTextViewSize:(CGSize)size font:(UIFont*)font;

@end
