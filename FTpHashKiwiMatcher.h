#import "KWMatcher.h"

#define imageAtPath(path) [[FTpHashKiwiMatcherPathWrapper alloc] initWithPath:path]
#define imageAtURL(URL) [[FTpHashKiwiMatcherPathWrapper alloc] initWithPath:URL.path]

@interface FTpHashKiwiMatcherPathWrapper : NSObject
@property (readonly) NSString *path;
- (instancetype)initWithPath:(NSString *)path;
@end

@interface FTpHashKiwiMatcher : KWMatcher
// The ‘cross-correlation peak’ ranges from 0.0 to 1.0, where the latter means
// that the images are identical.
- (void)equalImage:(FTpHashKiwiMatcherPathWrapper *)imagePathWrapper
     withThreshold:(double)crossCorrelationPeakMinimum;
@end
