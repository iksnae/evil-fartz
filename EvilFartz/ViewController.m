//
//  ViewController.m
//  EvilFartz
//
//  Created by Khalid on 1/27/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import "ViewController.h"
#import "SoundZipDownloader.h"
#import "NSURL+EvilFartz.h"
#import <MBProgressHUD/MBProgressHUD.h>


static NSString * fartzURL = @"https://s3-us-west-2.amazonaws.com/evilapples-scratch/Fartz.zip";

@interface ViewController ()<SoundZipDownloaderDelegate>
@property (nonatomic, strong) SoundZipDownloader *downloader;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.downloader = [SoundZipDownloader new];
    self.downloader.delegate = self;
    [[self downloader] downloadSoundZipWithURL:[NSURL URLWithString:fartzURL]];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
}

- (void)refreshSounds {
    NSError *listDirError = nil;
    NSString *pathToSounds = [[[NSURL docDirectory] absoluteString] stringByAppendingPathComponent:@"Sounds"];
    NSArray * files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:pathToSounds error:&listDirError];
    if (listDirError == nil) {
        NSLog(@"fetched Sound files: %lu",(unsigned long)files.count);
        for (NSString *file in files) {
            NSLog(@"%@",file);
        }
    }else{
        NSLog(@"failed to list Sound files");
    }
    
}

#pragma mark -- SoundZipDownloaderDelegate

- (void)soundZipDownloaderDidCompleteSuccessfully
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshSounds];
        [self.hud setLabelText:@"Finished"];
        [self.hud hide:YES afterDelay:1];
    });
}

- (void)soundZipDownloader:(SoundZipDownloader *)downloader didUpdateWithProgress:(CGFloat)progress andStatus:(NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud setLabelText:status];
        [self.hud setProgress:progress];
    });
}

- (void)soundZipDownloaderDidFail
{
    
}



@end
