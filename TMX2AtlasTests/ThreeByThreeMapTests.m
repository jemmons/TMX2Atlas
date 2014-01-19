@import XCTest;
#import "MCMTMXParser.h"
#import "MCMMap.h"

@interface ThreeByThreeMapTests : XCTestCase
@property MCMMap *map;
@end


@implementation ThreeByThreeMapTests
-(void)setUp{
  [super setUp];
  NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"3x3test" withExtension:@"tmx"];
  MCMTMXParser *parser = [[MCMTMXParser alloc] initWithURL:url];
  [self setMap:[parser parse]];
}


-(void)tearDown{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}


-(void)testMapExists{
  XCTAssertNotNil([self map], @"Error parsing map.");
}


-(void)testMapLayers{
  XCTAssertNotNil([[self map] layers], @"Layers not found.");
  XCTAssertTrue(3 == [[[self map] layers] count], @"Wrong number of layers");
  XCTAssertEqualObjects(@"Ground", [[[self map] layers][0] name], @"Bottom layer isn't \"Ground\".");
  XCTAssertEqualObjects(@"Collision", [[[self map] layers][1] name], @"Middle layer isn't \"Collision\".");
  XCTAssertEqualObjects(@"Cover", [[[self map] layers][2] name], @"Top layer isn't \"Cover\".");
  
}

@end
