//
//  SleepManager.m
//  sleeper
//

#import "SleepManager.h"

@import AppKit;
@import Foundation;

#define SCRIPT_DELAY_SECS 5


@interface SleepManager()
@property (nonatomic, strong) NSMutableArray *wakeArgs;
@property (nonatomic, strong) NSMutableArray *sleepArgs;
@end


@implementation SleepManager

- (id) initWithArguments: (NSArray*) arguments {
   if (self = [super init]) {
      self.wakeArgs = [[NSMutableArray alloc] init];
      self.sleepArgs = [[NSMutableArray alloc] init];
      [self parseArguments: arguments];
      [self registerForSleepWakeEvents];
   }
   return self;
}

- (void) parseArguments:(NSArray *)arguments {
   BOOL addToWakeArgs = NO;
   BOOL addToSleepArgs = NO;
   for (NSString *arg in arguments) {
      if ([arg caseInsensitiveCompare: @"-wakeargs"] == NSOrderedSame) {
         addToWakeArgs = YES;
         addToSleepArgs = NO;
      } else if ([arg caseInsensitiveCompare: @"-sleepargs"] == NSOrderedSame) {
         addToWakeArgs = NO;
         addToSleepArgs = YES;
      } else {
         if (addToWakeArgs) {
            [self.wakeArgs addObject: arg];
         } else if (addToSleepArgs) {
            [self.sleepArgs addObject: arg];
         }
      }
   }
}

#pragma mark - sleep / wake handling

- (void) executeTaskWithArgs: (NSArray*) args {
   if (args.count > 0) {
      NSTask *task = [[NSTask alloc] init];
      // first argument is the executable, and the rest are command line parameters
      task.launchPath = [args objectAtIndex:0];
      if (args.count > 1) {
         task.arguments = [args subarrayWithRange: NSMakeRange(1, args.count - 1)];
      }
      [task launch];
      [task waitUntilExit];
      int status = [task terminationStatus];
      
      /*
       EXIT STATUS
       The killall command will respond with a short usage message and exit with a status of 2 in case of a command error.
       A status of 1 will be returned if either no matching process has been found or not all processes have been
       signalled successfully.  Otherwise, a status of 0 will be returned.
       */
      if (status == 0) {
         NSLog(@"Task succeeded.");
      } else if (status == 1) {
         NSLog(@"Task failed, no matching process found.");
      } else if (status == 2) {
         NSLog(@"Task failed, command error.");
      } else {
         NSLog(@"Task failed, unknown error.");
      }
   }
}

- (void) receiveSleepNote: (NSNotification*) note {
   NSLog(@"receiveSleepNote: %@", [note name]);
   [self executeTaskWithArgs: self.sleepArgs];
}

- (void) receiveWakeNote: (NSNotification*) note {
   NSLog(@"receiveWakeNote: %@", [note name]);
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCRIPT_DELAY_SECS * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self executeTaskWithArgs: self.wakeArgs];
   });
}

- (void) registerForSleepWakeEvents {
   //These notifications are filed on NSWorkspace's notification center, not the default
   // notification center. You will not receive sleep/wake notifications if you file
   //with the default notification center.
   [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                          selector: @selector(receiveSleepNote:)
                                                              name: NSWorkspaceWillSleepNotification object: NULL];
   
   [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                          selector: @selector(receiveWakeNote:)
                                                              name: NSWorkspaceDidWakeNotification object: NULL];
}

- (void) cleanup {
   [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver: self];
}

@end
