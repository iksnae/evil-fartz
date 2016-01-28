//
//  NSURL+EvilFartz.m
//  EvilFartz
//
//  Created by Khalid on 1/28/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import "NSURL+EvilFartz.h"

@implementation NSURL (EvilFartz)
+ (NSURL *)docDirectory {
    return [NSURL URLWithString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
}
@end
