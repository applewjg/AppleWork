//
//  ViewController.m
//  HelloWorld
//
//  Created by Jingui Wang on 12/3/16.
//  Copyright © 2016 jinguiwang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UITextView *displayTextview;

@end

@implementation ViewController

@synthesize displayLabel = _displayLabel;
@synthesize displayTextview = _displayTextview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError *error = nil;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsDirectory= [NSHomeDirectory()
                                   stringByAppendingPathComponent:@"Documents"];
    
    NSURL* docsurl =
    [fileManager URLForDirectory:NSDocumentDirectory
               inDomain:NSUserDomainMask appropriateForURL:nil
                 create:YES error:&error];
    // error checking omitted
    NSURL* myfolder = [docsurl URLByAppendingPathComponent:@"MyDir"];
    NSLog(@"%@", myfolder);
    [fileManager createDirectoryAtURL:myfolder withIntermediateDirectories:YES attributes:nil error:&error];
    
    
    NSString *filePath= [documentsDirectory
                         stringByAppendingPathComponent:@"file1.txt"];
    //需要写入的字符串
    NSString *str= @"iPhoneDeveloper Tips\nhttp://iPhoneDevelopTips,com";
    //写入文件
    [str writeToFile:filePath atomically:YES
            encoding:NSUTF8StringEncoding error:&error];
    //显示文件目录的内容
    NSLog(@"Documentsdirectory: %@",
          [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error]);

    
    
    NSURL *homeUrl = [fileManager URLForDirectory:NSUserDirectory
                                         inDomain:NSUserDomainMask
                                         appropriateForURL:nil
                                         create:YES error:&error];
    NSLog(@"home URL: %@", homeUrl);

    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLIsDirectoryKey,
                           NSURLIsPackageKey,
                           NSURLLocalizedNameKey,
                           NSURLFileSizeKey,
                           NSURLTotalFileSizeKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:docsurl
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    if (array == nil) {
        // Handle the error
        NSLog(@"ERROR: there is something wrong with the app directory.");
    } else {
        for (NSURL* url in array) {
            NSString *localizedName = nil;
            [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
            NSNumber *fileSize = nil;
            [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            NSNumber *totalFileSize = nil;
            [url getResourceValue:&totalFileSize forKey:NSURLTotalFileSizeKey error:NULL];
            NSLog(@"%@: %@, %@", localizedName, fileSize, totalFileSize);
        }
    }

    

    NSString *homePath = NSHomeDirectory();
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:homePath error:nil];
    NSLog(@"fileSystem Attr:\n %@", fileSysAttributes);
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];

    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    fileList = [fileManager contentsOfDirectoryAtPath:homePath error:&error];
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [homePath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
            float filesize = [self folderSizeAtPath:path];
            NSLog(@"file:%@, size:%f", file, filesize);
        }
        isDir = NO;
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    NSLog(@"All folders:%@",dirArray);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]){
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/1024.0;
}

- (IBAction)gogogo:(id)sender {
    self.displayLabel.text = @"Hello World.";
    
    
    //App Path
    NSString *homePath = NSHomeDirectory();
    NSLog(@"Home：%@",homePath);

    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSLog(@"Documents：%@", documentDir);

    //Cache
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSLog(@"Cache：%@",cachePath);

    //Library
    NSArray *libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [libsPath objectAtIndex:0];
    NSLog(@"Library：%@",libPath);

    //temp
    NSString *tempPath = NSTemporaryDirectory();
    NSLog(@"temp：%@",tempPath);
    

    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    fileList = [fileManager contentsOfDirectoryAtPath:homePath error:&error];
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSString *free = [NSString stringWithFormat:@"可用空间：%.2fG",([freeSpace doubleValue])/1024.0/1024.0/1024.0];
    NSLog(@"free === \n%@",free);
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    self.displayTextview.text = @"";
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [homePath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
}

@end
