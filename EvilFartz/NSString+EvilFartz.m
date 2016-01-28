//
//  NSString+EvilFartz.m
//  EvilFartz
//
//  Created by Khalid on 1/28/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import "NSString+EvilFartz.h"

@implementation NSString (EvilFartz)
-(NSString*)fancyFileName {
    return [[[[self stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"-" withString:@" "] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
}
@end
