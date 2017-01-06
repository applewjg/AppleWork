#import "AppDelegate.h"

typedef bool OBJC_BOOL;

@interface AppDelegate ()

@end

@implementation AppDelegate

// Given The path of a file or directory.
// Return allocated size.
static long long MSOFileSizeAtPath(NSString *filePath) {
    __block NSError *error = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    OBJC_BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir] == NO) {
        return -1;
    }
    if (isDir == NO) {
        NSDictionary *fileDictionary = [fileManager attributesOfItemAtPath:filePath error:&error];
        if (fileDictionary == nil) {
            return -1;
        }
        return [fileDictionary fileSize];
    }
    
    long long fileSize = 0;
    
    NSArray *properties = @[
                            NSURLLocalizedNameKey,
                            NSURLIsDirectoryKey,
                            NSURLIsRegularFileKey,
                            NSURLFileSizeKey,
                            NSURLFileAllocatedSizeKey,
                            NSURLTotalFileSizeKey,
                            NSURLTotalFileAllocatedSizeKey
                            ];
    
    OBJC_BOOL (^errorHandler)(NSURL *, NSError *) = ^(__unused NSURL *url, NSError *localError) {
        error = localError;
        return NO;
    };
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:url
                                          includingPropertiesForKeys:properties
                                                             options:(NSDirectoryEnumerationOptions)0
                                                        errorHandler:errorHandler];
    
    for (NSURL *itemURL in enumerator) {
        if (error != nil) {
            return -1;
        }
        NSNumber *isRegularFile;
        if (! [itemURL getResourceValue:&isRegularFile forKey:NSURLIsRegularFileKey error:&error]) {
            return -1;
        }
        if (! [isRegularFile boolValue]) {
            continue;
        }
        
        NSNumber *fileAllocatedSize;
        if (! [itemURL getResourceValue:&fileAllocatedSize forKey:NSURLTotalFileAllocatedSizeKey error:&error]) {
            return -1;
        }
        
        if (fileAllocatedSize == nil) {
            if (! [itemURL getResourceValue:&fileAllocatedSize forKey:NSURLFileAllocatedSizeKey error:&error]) {
                return -1;
            }
            if (fileAllocatedSize == nil) {
                return -1;
            }
        }
        
        fileSize += [fileAllocatedSize longLongValue];
    }
    
    return fileSize;
}

void generateFilesAtPath(NSString *dirPath, NSInteger fileCount) {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    if (error != nil) {
        NSLog(@"ERROR:%@ createDirectoryAtPath:%@", error, dirPath);
        return;
    }
    
    NSMutableData *data = [NSMutableData data];
    NSData *someBytes = [NSData dataWithBytes:(uint8_t[16]){0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15} length:16];
    
    for (NSInteger i = 0; i < fileCount; ++i) {
        NSString *tmpFileName = [NSString stringWithFormat:@"testfile_%04ld", (long)i];
        NSString *path = [dirPath stringByAppendingPathComponent:tmpFileName];
        [data writeToFile:path atomically:YES];
        [data appendData:someBytes];
    }
}

void MSODiskUsage() {
    //App Path
    NSString *homePath = NSHomeDirectory();
    NSLog(@"Home：%@",homePath);
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSLog(@"Documents：%@", documentDir);
    
    //Cache
    NSArray *cPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cPath objectAtIndex:0];
    NSLog(@"Cache：%@",cachePath);
    
    //Library
    NSArray *lPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [lPath objectAtIndex:0];
    NSLog(@"Library：%@",libPath);
    
    //temp
    NSString *tempPath = NSTemporaryDirectory();
    NSLog(@"temp：%@",tempPath);
    
    NSString *testDirectory = [documentDir stringByAppendingPathComponent:@"test"];
   
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:testDirectory] == YES) {
        [fileManager removeItemAtPath:testDirectory error:&error];
        
        if (error != nil) {
            NSLog(@"ERROR:%@, failed to remove directory:%@", error, testDirectory);
            return;
        }
    }
    NSInteger fileCount = 1000;
    generateFilesAtPath(testDirectory, fileCount / 2);
    generateFilesAtPath([testDirectory stringByAppendingPathComponent:@"SubDirectory"], fileCount / 2);
    
    //testDirectory = [documentDir stringByAppendingPathComponent:@"test/testfile_0499"];
    long long fsize = MSOFileSizeAtPath(testDirectory);
    if (error != nil) {
        NSLog(@"ERROR: getDiskUsage, %@", error);
    } else {
        NSByteCountFormatter *sizeFormatter = [[NSByteCountFormatter alloc] init];
        sizeFormatter.includesActualByteCount = YES;
        
        NSLog(@"%@", [NSString stringWithFormat:@"    size: %@", [sizeFormatter stringFromByteCount:fsize]]);
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"Start dispatch:%@",dateString);
    MSODiskUsage();
    //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC));
    //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ applicationDiskUsage(); });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC);
        //dispatch_after(time, dispatch_get_main_queue(), ^{
        dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"10秒后添加到队列");
            MSODiskUsage();
        });
        
    });
    

    NSDate *endDate = [NSDate date];
    dateString = [dateFormatter stringFromDate:endDate];
    NSLog(@"End dispatch:%@",dateString);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
