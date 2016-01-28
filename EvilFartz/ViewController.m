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
@property (nonatomic, strong) NSArray *sounds;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.soundsTableView setDelegate:self];
    [self.soundsTableView setDataSource:self];
    
    self.downloader = [SoundZipDownloader new];
    self.downloader.delegate = self;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    [self refreshSounds];
    
    if (self.sounds.count == 0) {
        [[self downloader] downloadSoundZipWithURL:[NSURL URLWithString:fartzURL]];
    }else{
        [self.hud hide:YES];
    }
}

- (void)refreshSounds {
    NSArray *acceptedExtensions = @[@"aif",@"wav",@"mp3"];
    NSError *listDirError = nil;
    NSString *pathToSounds = [[[NSURL docDirectory] absoluteString] stringByAppendingPathComponent:@"Sounds"];
    NSArray * files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:pathToSounds error:&listDirError];
    if (listDirError == nil) {
        NSLog(@"fetched Sound files: %lu",(unsigned long)files.count);
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSString *file in files) {
            NSLog(@"%@",file);
            if ([acceptedExtensions containsObject:file.pathExtension]) {
                [tmp addObject:file];
            }
        }
        [self setSounds:tmp];
        [self.soundsTableView reloadData];
    }else{
        NSLog(@"failed to list Sound files");
    }
    
}

#pragma mark - SoundZipDownloaderDelegate

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

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sounds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.sounds objectAtIndex:indexPath.row];
    
    return cell;
}

@end
