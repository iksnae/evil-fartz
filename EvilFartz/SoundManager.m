//
//  SoundManager.m
//  EvilFartz
//
//  Created by Khalid on 1/28/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import "SoundManager.h"
#import <AVFoundation/AVFoundation.h>


@interface SoundManager ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer * player;
@end


@implementation SoundManager

+ (instancetype) sharedManager {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

- (instancetype)init{
    self = [super init];
    return  self;
}

- (void)playSoundWithAtPath:(NSString *)path
{
    NSError *playbackError = nil;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:&playbackError];
    [self.player setDelegate:self];
    [self.player prepareToPlay];
    [self.player play];
    if(playbackError){
        NSLog(@"%@",playbackError.localizedDescription);
        if ([self delegate]) {
            [[self delegate] soundFailedToPlay];
        }
    }else{
        if ([self delegate]) {
            [[self delegate] soundStartedPlaying];
        }
    }
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if ([self delegate]) {
        [[self delegate] soundFailedToPlay];
    }
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([self delegate]) {
        [[self delegate] soundFinishedPlaying];
    }
}





@end
