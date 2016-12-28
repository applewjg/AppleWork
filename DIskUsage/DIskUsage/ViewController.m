#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self testInBackground];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static unsigned long long pageSize() {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:homePath error:nil];
    NSLog(@"%@", fileSysAttributes);
    NSNumber *inodes = [fileSysAttributes objectForKey:NSFileSystemNodes];
    NSNumber *totalsize = [fileSysAttributes objectForKey:NSFileSystemSize];
    unsigned long long ps = totalsize.unsignedLongLongValue / inodes.unsignedLongLongValue;
    return ps;
}

- (void)testInBackground
{
    //App Path
    NSString *homePath = NSHomeDirectory();
    [self log:[NSString stringWithFormat:@"Home：%@",homePath]];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    [self log:[NSString stringWithFormat:@"Documents：%@", documentDir]];
    
    //Cache
    NSArray *cPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cPath objectAtIndex:0];
    [self log:[NSString stringWithFormat:@"Cache：%@",cachePath]];
    
    //Library
    NSArray *lPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [lPath objectAtIndex:0];
    [self log:[NSString stringWithFormat:@"Library：%@",libPath]];
    
    //temp
    NSString *tempPath = NSTemporaryDirectory();
    [self log:[NSString stringWithFormat:@"temp：%@",tempPath]];
    
    [self log:[NSString stringWithFormat:@"block size：%llu", pageSize()]];
    
    NSInteger fileCount = 1000;
    
    [self testMethod:@"folderSizeAtPath1" fileCount:fileCount withBlock:^long long(NSString *folderPath){
        return [self folderSizeAtPath1:folderPath];
    }];
    
    [self testMethod:@"folderSizeAtPath2" fileCount:fileCount withBlock:^long long(NSString *folderPath){
        return [self folderSizeAtPath2:folderPath];
    }];
    
    [self testMethod:@"allocatedSize" fileCount:fileCount withBlock:^long long(NSString *folderPath){
        return [self allocatedSize:folderPath];
    }];
    
}

- (unsigned long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]){
        NSDictionary *fileDictionary = [fileManager attributesOfItemAtPath:filePath error:nil];
        return [fileDictionary fileSize];
    }
    return 0;
}

- (unsigned long long) folderSizeAtPath1:(NSString*) folderPath{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:folderPath] == NO) {
       return 0;
    }
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    NSEnumerator *childFilesEnumerator = [filesArray objectEnumerator];
    NSString* fileName;
    unsigned long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

- (unsigned long long) folderSizeAtPath2:(NSString*) folderPath{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:folderPath] == NO) {
        return 0;
    }
    unsigned long long folderSize = 0;
    NSError *error = nil;
    NSArray *properties = @[
                           NSURLLocalizedNameKey,
                           NSURLIsDirectoryKey,
                           NSURLIsRegularFileKey,
                           NSURLFileSizeKey,
                           NSURLFileAllocatedSizeKey,
                           NSURLTotalFileSizeKey,
                           NSURLTotalFileAllocatedSizeKey
                           ];
    
    __block BOOL errorDidOccur = NO;
    BOOL (^errorHandler)(NSURL *, NSError *) = ^(NSURL *url, NSError *localError) {
        errorDidOccur = YES;
        return NO;
    };
    
    // prefetching some properties during traversal will speed up things a bit.
    NSArray *prefetchedProperties = @[
                                      NSURLIsRegularFileKey,
                                      NSURLFileSizeKey,
                                      NSURLFileAllocatedSizeKey,
                                      NSURLTotalFileAllocatedSizeKey,
                                      ];
    
    NSURL *url = [NSURL fileURLWithPath:folderPath];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:url
                                          includingPropertiesForKeys:prefetchedProperties
                                                             options:(NSDirectoryEnumerationOptions)0
                                                        errorHandler:errorHandler];

    for (NSURL *contentItemURL in enumerator) {
        if (errorDidOccur)
            return 0;
        
        // Get the type of this item, making sure we only sum up sizes of regular files.
        NSNumber *isRegularFile;
        if (! [contentItemURL getResourceValue:&isRegularFile forKey:NSURLIsRegularFileKey error:&error]) {
            return 0;
        }
        if (! [isRegularFile boolValue])
            continue; // Ignore anything except regular files.
        
        // To get the file's size we first try the most comprehensive value in terms of what the file may use on disk.
        // This includes metadata, compression (on file system level) and block size.
        NSNumber *fileSize;
        if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLTotalFileAllocatedSizeKey error:&error]) {
            return 0;
        }
        
        // In case the value is unavailable we use the fallback value (excluding meta data and compression)
        // This value should always be available.
        if (fileSize == nil) {
            if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLFileAllocatedSizeKey error:&error]) {
                return 0;
            }
            NSAssert(fileSize != nil, @"huh? NSURLFileAllocatedSizeKey should always return a value");
        }
        
        NSNumber *fileAllocatedSize;
        [contentItemURL getResourceValue:&fileAllocatedSize forKey:NSURLFileAllocatedSizeKey error:&error];
        // We're good, add up the value.
        folderSize += [fileSize unsignedLongLongValue];
        //NSLog(@"url: %@, size1: %@, size2: %@", contentItemURL, fileSize, fileAllocatedSize);
    }


    return folderSize;
}

- (unsigned long long)allocatedSize:(NSString *)folderPath
{
    NSError *error = nil;
    unsigned long long allocatedSize = 0;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:folderPath] == NO) {
        return 0;
    }
    
    __block BOOL errorDidOccur = NO;
    BOOL (^errorHandler)(NSURL *, NSError *) = ^(NSURL *url, NSError *localError) {
        errorDidOccur = YES;
        return NO;
    };
    
    // prefetching some properties during traversal will speed up things a bit.
    NSArray *prefetchedProperties = @[
                                      NSURLIsRegularFileKey,
                                      NSURLFileAllocatedSizeKey,
                                      NSURLTotalFileAllocatedSizeKey,
                                      ];
    
    NSURL *url = [NSURL fileURLWithPath:folderPath];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:url
                                           includingPropertiesForKeys:prefetchedProperties
                                                              options:(NSDirectoryEnumerationOptions)0
                                                         errorHandler:errorHandler];

    for (NSURL *contentItemURL in enumerator) {
        
        if (errorDidOccur)
            return 0;
        
        // Get the type of this item, making sure we only sum up sizes of regular files.
        NSNumber *isRegularFile;
        if (! [contentItemURL getResourceValue:&isRegularFile forKey:NSURLIsRegularFileKey error:&error]) {
            return 0;
        }
        if (! [isRegularFile boolValue])
            continue; // Ignore anything except regular files.
        
        // To get the file's size we first try the most comprehensive value in terms of what the file may use on disk.
        // This includes metadata, compression (on file system level) and block size.
        NSNumber *fileSize;
        if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLTotalFileAllocatedSizeKey error:&error]) {
            return 0;
        }
        
        // In case the value is unavailable we use the fallback value (excluding meta data and compression)
        // This value should always be available.
        if (fileSize == nil) {
            if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLFileAllocatedSizeKey error:&error]) {
                return 0;
            }
            NSAssert(fileSize != nil, @"huh? NSURLFileAllocatedSizeKey should always return a value");
        }
        
        // We're good, add up the value.
        allocatedSize += [fileSize unsignedLongLongValue];
    }
    if (errorDidOccur == YES) {
        return 0;
    }
    return allocatedSize;
}

static long long fileSystemFreeSize(NSString *path)
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:NULL];
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue];
}

static void generateFilesAtPath(NSString *dirPath, NSInteger fileCount) {
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

- (void)log:(NSString *)message
{
    NSLog(@"%@", message);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n", message];
    });
}

- (void)testMethod:(NSString *)testMethod fileCount:(NSInteger)fileCount withBlock:(long long(^)(NSString *folderPath))block {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [self log:[NSString stringWithFormat:@"\nTest \"%@\"", testMethod]];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    

    
    NSString *testDirectory = [documentDir stringByAppendingPathComponent:@"test"];
    [self log:[NSString stringWithFormat:@"    preparing %ld test files...", fileCount]];
    
    if ([fileManager fileExistsAtPath:testDirectory] == YES) {
        [fileManager removeItemAtPath:testDirectory error:&error];
        
        if (error != nil) {
            [self log:[NSString stringWithFormat:@"ERROR:%@, failed to remove directory:%@", error, testDirectory]];
            return;
        }
    }
    
    long long availableSizeBefore = fileSystemFreeSize(documentDir);
    
    generateFilesAtPath(testDirectory, fileCount / 2);
    generateFilesAtPath([testDirectory stringByAppendingPathComponent:@"SubDirectory"], fileCount / 2);
    
    [self log:[NSString stringWithFormat:@"    test start..."]];
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    unsigned long long testSize = block(testDirectory);
    CFAbsoluteTime duration = CFAbsoluteTimeGetCurrent() - startTime;
    
    [self log:[NSString stringWithFormat:@"    test done"]];
    
    NSByteCountFormatter *sizeFormatter = [[NSByteCountFormatter alloc] init];
    sizeFormatter.includesActualByteCount = YES;
    
    [self log:[NSString stringWithFormat:@"    size: %@", [sizeFormatter stringFromByteCount:testSize]]];
    [self log:[NSString stringWithFormat:@"    time: %.3f s", duration]];
    
    long long availableSizeAfter = fileSystemFreeSize(documentDir);
    
    [self log:[NSString stringWithFormat:@"    actual bytes: %@", [sizeFormatter stringFromByteCount:availableSizeBefore - availableSizeAfter]]];
    
}
@end
