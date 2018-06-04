//
//  ViewController.m
//  pods01
//
//  Created by temp on 2018/5/28.
//  Copyright © 2018年 temp. All rights reserved.
//

#import "ViewController.h"
#import "UIComposition.h"

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
    
    dispatch_queue_t ser_queue = dispatch_queue_create("Ser", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(ser_queue, ^{
        NSLog(@"1");
    });
    
    NSLog(@"2");
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


@end
