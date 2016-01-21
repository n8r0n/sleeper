//
//  SleepManager.h
//  sleeper
//

#import <Foundation/Foundation.h>

@interface SleepManager : NSObject

/**
 @discussion Initialize a SleepManager with the command line arguments provided to this program.
 @param arguments Command line arguments, in order. Arguments following -wakeargs will
 be interpretted as the executable, and accompanying command line
 arguments to pass to it, for running after computer wake events.
 Arguments following  -sleepargs define the command line to be
 run during sleep events (before computer sleep).
 */
- (id) initWithArguments: (NSArray*) arguments;

/**
 @discussion Cleanup the object in preparation for program shutdown
 */
- (void) cleanup;

@end
