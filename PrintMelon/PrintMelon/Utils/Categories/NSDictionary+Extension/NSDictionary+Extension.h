//
//  NSDictionary+Extension.h
//  xiaozhu
//
//  Created by fuchenglong on 2017/7/21.
//  Copyright © 2017年 fuchenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
/**
 *MD5+RSA加密
 */
- (NSDictionary *)dicByRSAAndMD5ToDicWithMd5Value:(NSString *)md5Value;


#pragma mark ==========ELSE==========

-(id)objectForKeyOrNil:(id)key;
@end
