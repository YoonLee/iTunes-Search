//
//  Global_Config.h
//  TigerText
//
//  Created by Yoon Lee on 11/8/12.
//
//
// PRE-COMPILE HELPER HEADER METHODS
#define KILL_OBJ(x)            x = nil;    [x release];

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define RGB(R,G,B)                          [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define CWHITE()                            RGB(255, 255, 255)
#define CBLACK()                            RGB(  0,   0,   0)
#define CDRED( )                            RGB(191, 52, 43)
#define CDGRAY()                            RGB(141, 141, 141)
#define CCLEAR()                            [UIColor clearColor]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

static inline CGRect deviceScreen()
{
    return [UIScreen mainScreen].bounds;
}

static inline CGRect applicationScreen()
{
    return [[UIScreen mainScreen] applicationFrame];
}

static inline NSString* booleanToStr(BOOL isTrue)
{
    return isTrue?@"'YES'":@"'NO'";
}

static inline BOOL isPad()
{
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

#define K 1024
static inline NSString* getFileSize(NSString* path)
{
    BOOL isDirectory = NO;
    float thesize = 0.0f;
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:path isDirectory:&isDirectory]){
        NSDictionary *attributes = [filemanager attributesOfItemAtPath:path error:nil];
        
        // file size
        NSNumber *fileSizeNumber = [attributes objectForKey:NSFileSize];
        thesize = [fileSizeNumber floatValue];
    }
    
	if (thesize < K) {
		return [NSString stringWithFormat:@"%.2f Bytes", thesize];
	}
	thesize = thesize / K;
	if (thesize < K) {
		return [NSString stringWithFormat:@"%.2f KB", thesize];
	}
	thesize = thesize / K;
    
	return [NSString stringWithFormat:@"%.2f MB", thesize];
}

static inline NSString* isPluralSec(int time)
{
    return time < 1?@"second":@"seconds";
}