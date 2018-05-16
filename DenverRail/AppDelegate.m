//
//  AppDelegate.m
//  DenverRail
//
// 2008 - 2013 Tack Mobile.
//

#import "AppDelegate.h"
#import "TimetableSearchUtility.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

static NSString *const kPlaySoundsKey = @"playSoundsKey";
static NSString *const kPreferencesSetKey = @"prefsSet";
static NSString *const kPreferencesSetValue = @"prefsSet";

@interface AppDelegate()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [self initializeAudioPreferences];
    [self initializeAudio];
    [self initStations];
	
    return YES;
}

// Checks sound when application comes from foreground 
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self initializeAudioPreferences];
}

/**
 Initializes the stations with their image name, database name, coordinates, and
 booleans if they are one direction only and if they are east and west instead of north and south
 */
- (void)initStations {
	self.stations = [NSMutableArray new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Stations" ofType: @"plist"];
    NSMutableArray *stations = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for(NSDictionary *station in stations){
        [self.stations addObject:[[Station alloc]
                                  initWithColumnName: [station objectForKey: @"name"]
                                  latitude: [[station objectForKey: @"latitude"] doubleValue]
                                  longitude: [[station objectForKey: @"longitude"] doubleValue]
                                  southOnly: [station objectForKey: @"southOnly"]
                                  northOnly: [station objectForKey: @"northOnly"]
                                  eastWest: [station objectForKey: @"eastWest"]]];
    }
}

#pragma mark - Audio -

// Initializes the audio for the first time
- (void)initializeAudio {
    [AVAudioSession sharedInstance];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)initializeAudioPreferences {
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
    
        NSNumber *playSoundDefault;
        
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray) {
           
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			if ([keyValueStr isEqualToString:kPlaySoundsKey]) {
                playSoundDefault = defaultValue;
			}
		}
        
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:playSoundDefault, kPlaySoundsKey, nil];
      
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];

        [[NSUserDefaults standardUserDefaults] setValue:kPreferencesSetKey forKey:kPreferencesSetKey];

        self.playSounds = [[NSUserDefaults standardUserDefaults] boolForKey:kPlaySoundsKey];
}

@end
