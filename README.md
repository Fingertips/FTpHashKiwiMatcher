# FTpHashKiwiMatcher

A [Kiwi](https://github.com/allending/Kiwi) matcher that compares two images on
disk for perceptual differences. For this it uses the excellent
[pHash](http://phash.org) library. It’s still very young and requires some
libraries to be installed through [homebrew](https://github.com/mxcl/homebrew).

At this moment it only supports JPEG images, but adding PNG support is just a
matter of adding that library to the dependencies.

##### Install dependencies

To install the required libraries, run the following command:

    $ ./install-dependencies

##### Usage

```objc
#import "Kiwi.h"
#import "FTpHashKiwiMatcher.h"

SPEC_BEGIN(MyImageSpec)

registerMatchers(@"FTpHash");

describe(@"MyImageSpec", ^{
  it(@"ensures two images are equal", ^{
    NSURL *expectedImageURL = FixtureByName(@"Bitmaps/filtered.jpg");
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), [[NSUUID UUID] UUIDString]];
    [MyClass generateImageAtPath:path];
    [[imageAtPath(path) should] equalImage:imageAtURL(expectedImageURL)];
  });

  it(@"ensures two images are equal enough", ^{
    NSURL *expectedImageURL = FixtureByName(@"Bitmaps/filtered.jpg");
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), [[NSUUID UUID] UUIDString]];
    [MyClass generateImageAtPath:path withBlur:0.1];
    [[imageAtPath(path) should] equalImage:imageAtURL(expectedImageURL) withThreshold:0.9];
  });
});

SPEC_END
```

##### License

This matcher is available under the MIT license, but be aware that the reuired
libraries have GPL like licenses.
