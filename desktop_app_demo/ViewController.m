//
//  ViewController.m
//  desktop_app_demo
//
//  Created by 彭双塔 on 2019/7/9.
//  Copyright © 2019 pst. All rights reserved.
//

#import "ViewController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#define Screen_Width [[UIScreen mainScreen]bounds].size.width
#define Screen_Height [[UIScreen mainScreen]bounds].size.height
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
@interface ViewController ()
@property (nonatomic,strong)HTTPServer *httpServer;
@end

@implementation ViewController
- (void)dealloc
{
    // 停止服务
    [_httpServer stop];
}
- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([_httpServer start:&error])
    {
        DDLogInfo(@"Started HTTP Server on port %hu", [_httpServer listeningPort]);
        
        // open the url.
        NSString *urlStrWithPort = [NSString stringWithFormat:@"http://localhost:%d",[_httpServer listeningPort]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrWithPort]];
    }
    else
    {
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(Screen_Width/2 - 166.0/2, Screen_Height/2 - 44.0/2, 166.0, 44.0);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"创建桌面快捷方式" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.layer.cornerRadius = 44.0/2;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(jumpBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)jumpBtn:(UIButton *)button{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    _httpServer = [[HTTPServer alloc] init];
    [_httpServer setType:@"_http._tcp."];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    
    DDLogInfo(@"Setting document root: %@", webPath);
    
    [_httpServer setDocumentRoot:webPath];
    
    [self startServer];
}


@end
