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

- (void)initStations {
    self.stations = [NSMutableArray new];
    
    // Read station data from plist file
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Stations" ofType: @"plist"];
    NSMutableArray *stations = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for(NSDictionary *station in stations){
        // Initializes the station with its name, coordinates, and directional booleans
        [self.stations addObject:[[Station alloc]
                                  initWithColumnName: station[@"name"]
                                  latitude: [station[@"latitude"] doubleValue]
                                  longitude: [station[@"longitude"] doubleValue]
                                  southOnly: [station[@"southOnly"] boolValue]
                                  northOnly: [station[@"northOnly"] boolValue]
                                  eastWest: [station[@"eastWest"] boolValue]
        ]];
    }
}

#pragma mark - Audio -

// Initializes the audio for the first time
- (void)initializeAudio {
    [AVAudioSession sharedInstance];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)initializeAudioPreferences {
        NSString *pathStr = [NSBundle mainBundle].bundlePath;
        NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray *prefSpecifierArray = settingsDict[@"PreferenceSpecifiers"];
    
        NSNumber *playSoundDefault;
        
        NSDictionary *prefItem;
        for (prefItem in prefSpecifierArray) {
           
            NSString *keyValueStr = prefItem[@"Key"];
            id defaultValue = prefItem[@"DefaultValue"];
            if ([keyValueStr isEqualToString:kPlaySoundsKey]) {
                playSoundDefault = defaultValue;
            }
        }
        
        NSDictionary *appDefaults = @{kPlaySoundsKey: playSoundDefault};
      
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[NSUserDefaults standardUserDefaults] setValue:kPreferencesSetKey forKey:kPreferencesSetKey];

        self.playSounds = [[NSUserDefaults standardUserDefaults] boolForKey:kPlaySoundsKey];
}

@end
