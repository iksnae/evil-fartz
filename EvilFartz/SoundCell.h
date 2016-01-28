//
//  SoundCell.h
//  EvilFartz
//
//  Created by Khalid on 1/28/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybackIndicatorView.h"


@interface SoundCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PlaybackIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, assign) BOOL playing;
@end
