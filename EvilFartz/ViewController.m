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
#import "NSString+EvilFartz.h"
#import "SoundManager.h"
#import "SoundCell.h"


static NSString * fartzURL = @"https://s3-us-west-2.amazonaws.com/evilapples-scratch/Fartz.zip";

@interface ViewController ()<SoundZipDownloaderDelegate, SoundManagerDelegate>
@property (nonatomic, strong) SoundZipDownloader *downloader;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSArray *sounds;
@property (nonatomic, strong) NSIndexPath *playingIndexPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Evil Fartz";
    
    [self.soundsTableView setDelegate:self];
    [self.soundsTableView setDataSource:self];
    [self.soundsTableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    [[SoundManager sharedManager]setDelegate:self];
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshSounds];
        [self.hud setLabelText:@"Failed to download Sounds"];
        [self.hud hide:YES afterDelay:1];
    });
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.playingIndexPath = indexPath;
    NSString *soundFile = [[self sounds]objectAtIndex:indexPath.row];
    NSString *pathToSound = [[[[NSURL docDirectory] absoluteString] stringByAppendingPathComponent:@"Sounds"] stringByAppendingPathComponent:soundFile];
    [[SoundManager sharedManager] playSoundWithAtPath:pathToSound];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sounds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
    NSString *fileName =  [self.sounds objectAtIndex:indexPath.row];
    cell.nameLabel.text = [[self.sounds objectAtIndex:indexPath.row] fancyFileName];
    cell.infoLabel.text = [NSString stringWithFormat:@"Type: %@",[[fileName pathExtension] uppercaseString]];
    cell.playing = (self.playingIndexPath == indexPath);
    return cell;
}

#pragma mark - SoundManagerDelegate

- (void)soundStartedPlaying
{
    [self.soundsTableView reloadData];
}

- (void)soundFinishedPlaying
{
    self.playingIndexPath = nil;
    [self.soundsTableView reloadData];
}

- (void)soundFailedToPlay
{
    
}

@end
