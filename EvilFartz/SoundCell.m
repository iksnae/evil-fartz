//
//  SoundCell.m
//  EvilFartz
//
//  Created by Khalid on 1/28/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import "SoundCell.h"


@implementation SoundCell
- (void)setPlaying:(BOOL)playing{
    _playing = playing;
    if (_playing) {
        self.nameLabel.textColor = [UIColor redColor];
        self.indicatorView.alpha = 1;
        [self.indicatorView start];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        self.indicatorView.alpha = 0;
        [self.indicatorView stop];
    }
}
@end
