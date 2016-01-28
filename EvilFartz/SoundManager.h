//
//  SoundManager.h
//  EvilFartz
//
//  Created by Khalid on 1/28/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SoundManagerDelegate;


@interface SoundManager : NSObject
@property (nonatomic, weak) NSObject<SoundManagerDelegate> *delegate;
+ (instancetype) sharedManager;
- (void)playSoundWithAtPath:(NSString*)path;
@end


@protocol SoundManagerDelegate <NSObject>

- (void)soundStartedPlaying;
- (void)soundFinishedPlaying;
- (void)soundFailedToPlay;

@end