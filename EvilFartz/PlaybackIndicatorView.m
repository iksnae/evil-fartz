//
//  PlaybackIndicatorView.m
//  EvilFartz
//
//  Created by Khalid on 1/28/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import "PlaybackIndicatorView.h"

@interface PlaybackIndicatorView ()
@property (nonatomic, strong) UIImageView *spinnerView;
@end

@implementation PlaybackIndicatorView
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.spinnerView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,50,50}];
        self.spinnerView.animationImages = [self animationFrames];
        self.spinnerView.backgroundColor = [UIColor clearColor];
        self.spinnerView.animationDuration = 0.5;
        self.spinnerView.animationRepeatCount = 0;
        [self addSubview:self.spinnerView];
    }
    return self;
}


- (NSArray*)animationFrames {
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger totalFrames = 24;
    NSInteger frameNum = 1;
    while (frameNum < totalFrames) {
        NSString *imageName = [NSString stringWithFormat:@"spinner%04ld", (long)frameNum];
        UIImage *image = [UIImage imageNamed:imageName];
        [arr addObject:image];
        frameNum ++;
    }
    return arr;
}

- (void)start
{
    [self.spinnerView startAnimating];
}

- (void)stop
{
    [self.spinnerView stopAnimating];
}
@end
