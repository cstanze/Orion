//
//  main.m
//  OrionRelaunchHelper
//
//  Created by Jules Amalie on 2022/01/24.
//

// I get lazy sometimes. Don't judge me...
#define Log(x) NSLog(@"OrionRelaunchHelper: %s", x)
#define LogFatal(x) NSLog(@"OrionRelaunchHelper: %s... exiting.", x)

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

/// Simple KVO Wrapper Class
@interface ORObserver : NSObject
/// Simple callback for the observer
@property void(^callback)(void);

/// Initialises a new `ORObserver` with a block
-(instancetype)initWithBlock:(void(^)(void))callback;
@end

@implementation ORObserver

-(instancetype)initWithBlock:(void(^)(void))callback {
  self = [super init];
  
  if (self) {
    self.callback = callback;
  }
  
  return self;
}

/// Observes for changes, then removes itself from the observed object
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  [((NSObject*)object) removeObserver:self forKeyPath:keyPath];
  self.callback();
}

@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc < 2) {
      LogFatal("parentPid is non-existent");
      return 1;
    }
    
    int processPid = atoi(argv[1]); // pid_t is just an int
    if (processPid == 0) {
      NSArray<NSRunningApplication *> *ra = [NSRunningApplication runningApplicationsWithBundleIdentifier:[NSString stringWithUTF8String:argv[1]]];
      if ([ra count] == 0) {
        LogFatal("invalid process pid/bundleID");
        return 1;
      }
      processPid = (int)ra[0].processIdentifier;
    }
    NSRunningApplication *runningApplication = [NSRunningApplication runningApplicationWithProcessIdentifier:processPid];
    if (runningApplication == nil) {
      LogFatal("unable to find running application");
      return 1;
    }
    
    NSURL *bundleUrl = runningApplication.bundleURL;
    NSString *localisedName = runningApplication.localizedName;
    int runningPid = runningApplication.processIdentifier;
    ORObserver *observer = [[ORObserver alloc] initWithBlock:^{
      CFRunLoopStop(CFRunLoopGetCurrent());
      NSLog(@"Relaunching %@ (%d)", localisedName, runningPid);
    }];
    [runningApplication addObserver:observer forKeyPath:@"isTerminated" options:0 context:nil];
    [runningApplication terminate];
    CFRunLoopRun();
    
    @try {
      [[NSWorkspace sharedWorkspace] launchApplicationAtURL:bundleUrl options:0 configuration:@{} error:nil];
    } @catch (NSException *exception) {
      LogFatal("failed to launch the application.");
      NSAlert *alert = [[NSAlert alloc] init];
      alert.messageText = [NSString stringWithFormat:@"Failed to relaunch %@", localisedName];
      alert.informativeText = exception.description;
      
      [alert runModal];
      return 1;
    }
  }
  return 0;
}
