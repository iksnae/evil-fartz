//
//  SoundZipDownloader.m
//  EvilFartz
//
//  Created by Khalid on 1/27/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import "SoundZipDownloader.h"
#import "NSURL+EvilFartz.h"

#import <UnzipKit/UnzipKit.h>




@implementation SoundZipDownloader
{
    CGFloat dowloadSize;
    NSMutableData *downloadedData;
}

- (void)downloadSoundZipWithURL:(NSURL *)url {
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:req];
    [task resume];
}

- (void)unzipSoundsAtPath:(NSString*)path {
    NSError *archiveErr = nil;
    UZKArchive *archive = [[UZKArchive alloc] initWithPath:path error:&archiveErr];
    if (archiveErr == nil) {
        NSLog(@"created archive");
        NSError *extractErr = nil;
        NSString *output = [[NSURL docDirectory]absoluteString];
        NSLog(@"%@",output);
        [archive extractFilesTo:output overwrite:YES progress:^(UZKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
            if ([self delegate]) {
                [[self delegate] soundZipDownloader:self didUpdateWithProgress:percentArchiveDecompressed andStatus:@"Extracting"];
            }
        } error:&extractErr];
        if (extractErr== nil) {
            NSLog(@"successfully extracted sounds");
            [[self delegate] soundZipDownloaderDidCompleteSuccessfully];
        }else{
            NSLog(@"failed to extract files: %@", extractErr);
            if ([self delegate]) {
                [[self delegate] soundZipDownloaderDidFail];
            }
        }
        
    }else{
        NSLog(@"failed to create archive");
        if ([self delegate]) {
            [[self delegate] soundZipDownloaderDidFail];
        }
    }
}


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [downloadedData appendData:data];
    if ([self delegate]) {
        CGFloat progress = data.length / dowloadSize;
        [[self delegate] soundZipDownloader:self didUpdateWithProgress:progress andStatus:@"Downloading"];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    downloadedData = [NSMutableData data];
    if ([self delegate]) {
        dowloadSize = [response expectedContentLength];
        [[self delegate] soundZipDownloader:self didUpdateWithProgress:0 andStatus:@"Downloading"];
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *path = [[[NSURL docDirectory]absoluteString]stringByAppendingString:@"/tmp.zip"];
    NSData *d = [NSData dataWithContentsOfURL:location];
    [d writeToFile:path atomically:YES];
    [self unzipSoundsAtPath:path];
}



-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat prog = (float)totalBytesWritten/totalBytesExpectedToWrite;
    if ([self delegate]) {
        [[self delegate] soundZipDownloader:self didUpdateWithProgress:prog andStatus:@"Downloading"];
    }
    
}

@end

