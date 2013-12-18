#import "MCMMap.h"


@implementation MCMMap
-(NSString *)description{
  return [NSString stringWithFormat:@"%@\nversion: %@\norientation: %@\nmap size: [%lu, %lu]\ntile size: [%f, %f]\n", [super description], [self version], [self orientation], (unsigned long)[self width], (unsigned long)[self height], [self tileWidth], [self tileHeight]];
}
@end
