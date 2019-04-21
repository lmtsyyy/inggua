//
//  NSString+URL.h
//  GLSH
//
//  Created by hua on 2017/5/2.
//
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;

@end
