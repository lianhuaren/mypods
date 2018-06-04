//
//  ViewController.m
//  pods01
//
//  Created by temp on 2018/5/28.
//  Copyright © 2018年 temp. All rights reserved.
//

#import "ViewController.h"
#import "UIComposition.h"
#include <sys/stat.h>
#include <dirent.h>

@interface ViewController ()
@property (copy, nonatomic) NSMutableArray *array;
@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    self.array = [NSMutableArray array];
//    [self performSelector:@selector(test)];
//
//
//    NSLog(@"%@",self.array);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    dispatch_queue_t ser_queue = dispatch_queue_create("Ser", DISPATCH_QUEUE_SERIAL);
//    dispatch_sync(ser_queue, ^{
//        NSLog(@"1");
//    });
//
//    NSLog(@"2");
    NSArray *arr = [self getVideoList];
    NSLog(@"%@", arr);
}

static long long fileSizeAtPath(NSString *filePath) {
    struct stat st;
    
    //获取文件的一些信息，返回0的话代表执行成功
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        
        //返回这个路径下文件的总大小
        return st.st_size;
    }
    return 0;
}


static long long folderSizeAtDirectory(NSString *folderPath) {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += fileSizeAtPath(fileAbsolutePath);
    }
    return folderSize;
}


- (NSMutableArray *)getVideoList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *modelList = [NSMutableArray array];
//    NSArray *nameList = [fileManager subpathsAtPath:[self getVideoPath]];
//    for (NSString *name in nameList) {
//        if (name.length > 0) {
//            NSString *thumAbsolutePath = [[self getVideoPath] stringByAppendingPathComponent:name];
//
//
//            [modelList addObject:thumAbsolutePath];
//        }
//    }
    NSEnumerator *enumrator = [[fileManager subpathsAtPath:[self getVideoPath]] objectEnumerator];
    NSString *filename;
    while ((filename = [enumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [[self getVideoPath] stringByAppendingPathComponent:filename];
//        struct stat st;
//
//        //获取文件的一些信息，返回0的话代表执行成功
//        if(lstat([fileAbsolutePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
//            // S_ISREG
//            if(S_ISDIR(st.st_mode) && fileAbsolutePath.length > 0) {
//                [modelList addObject:fileAbsolutePath];
//            }
//        }
        BOOL dir = NO;
        [fileManager fileExistsAtPath:fileAbsolutePath isDirectory:&dir];
        if (!dir) { // 子路径是个文件
            [modelList addObject:fileAbsolutePath];
        }
    }
    return modelList;
}

- (NSString *)getVideoPath {
//    return [self getCacheSubPath:kVideoDicName];
    NSString *documentPath = NSHomeDirectory();//[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return documentPath;
}

+ (NSString *)getCacheSubPath:(NSString *)dirName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:dirName];
}



//- (void)viewDidLoad {
//    [super viewDidLoad];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"before perform");
//
//        [self performSelector:@selector(printLog) withObject:nil afterDelay:0];
//        NSLog(@"after perform");
//        [[NSRunLoop currentRunLoop] run];
//
//    });
//}
- (void)printLog {
    NSLog(@"printLog");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 按路径清除文件
+ (void)clearCachesWithFilePath:(NSString *)path
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr removeItemAtPath:path error:nil];
    
}


+ (double)sizeWithFilePath:(NSString *)path
{
    // 1.获得文件夹管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [mgr fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [mgr subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [mgr attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1000 * 1000.0);
    } else { // 文件
        NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1000 * 1000.0);
    }
}
@end
