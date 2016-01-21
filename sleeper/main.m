//
//  main.m
//  sleeper
//
//  Created by Nathan Scandella on 1/20/16.
//  Copyright © 2016 Enscand, Inc. All rights reserved.
//

@import Foundation;

#import "SleepManager.h"

// This routine installs a SIGTERM handler that's called on the main thread, allowing
// it to then call into Cocoa to quit the app.
static void InstallHandleSIGTERMFromRunLoop()
{
   static dispatch_once_t   sOnceToken;
   static dispatch_source_t sSignalSource;
   
   dispatch_once(&sOnceToken, ^{
      signal(SIGTERM, SIG_IGN);
      
      sSignalSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGTERM, 0, dispatch_get_main_queue());
      assert(sSignalSource != NULL);
      
      dispatch_source_set_event_handler(sSignalSource, ^{
         assert([NSThread isMainThread]);
         
         NSLog(@"Shutting down on receiving SIGTERM");
         CFRunLoopStop(CFRunLoopGetCurrent());
      });
      
      dispatch_resume(sSignalSource);
   });
}

int main(int argc, const char * argv[]) {
   CFRunLoopRunResult result = 0;
   @autoreleasepool {
      NSLog(@"sleepd daemon v1.0");
      
      InstallHandleSIGTERMFromRunLoop();
      
      NSMutableArray *arguments = [[NSMutableArray alloc] init];
      // argv[0] is this program's name ... skip to args
      for (int i = 1; i < argc; i++) {
         [arguments addObject: [NSString stringWithCString: argv[i] encoding: NSUTF8StringEncoding]];
      }
      SleepManager *mgr = [[SleepManager alloc] initWithArguments: arguments];
      
      CFTimeInterval distantFuture = [[NSDate distantFuture] timeIntervalSinceNow];
      result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, distantFuture, false);
      
      [mgr cleanup];
   }
   return result;
}
