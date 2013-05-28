#import "FTpHashKiwiMatcher.h"
#import <pHash.h>

@implementation FTpHashKiwiMatcherPathWrapper

- (instancetype)initWithPath:(NSString *)path;
{
  if ((self = [super init])) {
    _path = path;
  }
  return self;
}

- (const char *)cString;
{
  return self.path.UTF8String;
}

- (NSString *)description;
{
  return self.path;
}

@end


@interface FTpHashKiwiMatcher ()
@property (strong) FTpHashKiwiMatcherPathWrapper *expectedImage;
@property (assign) double ccpMinimum;
@property (assign) double ccp;
@end

@implementation FTpHashKiwiMatcher

+ (NSArray *)matcherStrings;
{
  return @[@"equalImage:", @"equalImage:withThreshold:"];
}

- (NSString *)failureMessageForShould;
{
  return [NSString stringWithFormat:@"expected subject to equal image with a cross correlation peak of %f, got %f", self.ccpMinimum, self.ccp];
}

- (NSString *)failureMessageForShouldNot;
{
  return [NSString stringWithFormat:@"expected subject to not equal image with a cross correlation peak of %f, got %f", self.ccpMinimum, self.ccp];
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"equal image at path %@", self.expectedImage];
}

- (BOOL)evaluate;
{
  FTpHashKiwiMatcherPathWrapper *actual = (FTpHashKiwiMatcherPathWrapper *)self.subject;
  if (![actual isKindOfClass:[FTpHashKiwiMatcherPathWrapper class]]) {
    [NSException raise:@"KWMatcherException" format:@"subject should be of type FTpHashKiwiMatcherPathWrapper"];
  }

  FTpHashKiwiMatcherPathWrapper *expected = self.expectedImage;
  if (![expected isKindOfClass:[FTpHashKiwiMatcherPathWrapper class]]) {
    [NSException raise:@"KWMatcherException" format:@"expected image should be of type FTpHashKiwiMatcherPathWrapper"];
  }

  // These are the values that pHash advices atm.
  double sigma = 1.0, gamma = 1.0;
  int N = 180;

  Digest actualDigest, expectedDigest;

  if (ph_image_digest(actual.cString, sigma, gamma, actualDigest, N) == -1) {
    [NSException raise:@"KWMatcherException" format:@"unable to hash the subject image"];
  }
  if (ph_image_digest(expected.cString, sigma, gamma, expectedDigest, N) == -1) {
    [NSException raise:@"KWMatcherException" format:@"unable to hash the expected image"];
  }

  double ccp = 0;
  int result = ph_crosscorr(actualDigest, expectedDigest, ccp, self.ccpMinimum);
  switch (result) {
    case 0:
      self.ccp = ccp;
      return NO;
    case 1:
      return YES;
    case -1:
      // Although the docs state this is an error, it doesn't ever return error codes atm.
      [NSException raise:@"KWMatcherException" format:@"an error occurred while comparing images"];
    default:
      NSAssert1(NO, @"Unexpected pHash result: %d", result);
  }

  return NO;
}

- (void)equalImage:(FTpHashKiwiMatcherPathWrapper *)imagePathWrapper;
{
  [self equalImage:imagePathWrapper withThreshold:0.999999];
}

- (void)equalImage:(FTpHashKiwiMatcherPathWrapper *)imagePathWrapper
     withThreshold:(double)crossCorrelationPeakMinimum;
{
  self.expectedImage = imagePathWrapper;
  self.ccpMinimum = crossCorrelationPeakMinimum;
}

@end
