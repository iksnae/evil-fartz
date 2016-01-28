//
//  SoundZipDownloader.h
//  EvilFartz
//
//  Created by Khalid on 1/27/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SoundZipDownloaderDelegate;

typedef void(^SoundFetch)(id responseObject, NSError *error);

@interface SoundZipDownloader : NSObject<NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, weak) NSObject<SoundZipDownloaderDelegate> *delegate;
- (void)downloadSoundZipWithURL:(NSURL*)url;
@end

@protocol SoundZipDownloaderDelegate <NSObject>
- (void)soundZipDownloaderDidFail;
- (void)soundZipDownloaderDidCompleteSuccessfully;
- (void)soundZipDownloader:(SoundZipDownloader*)downloader didUpdateWithProgress:(CGFloat)progress andStatus:(NSString*)status;
@end

