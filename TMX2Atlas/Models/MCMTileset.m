#import "MCMTileset.h"


@implementation MCMTileset
#pragma mark - INIT/SETUP
+(instancetype)tilesetWithAttributes:(NSDictionary *)att{
  NSParameterAssert(att[@"firstgid"] && att[@"tilewidth"] && att[@"tileheight"]);
  NSParameterAssert(nil == att[@"source"]);
  
  MCMTileset *tileset = [MCMTileset new];
  [tileset setName:att[@"name"]];
  [tileset setFirstGID:[att[@"firstgid"] integerValue]];
  [tileset setTileWidth:[att[@"tilewidth"] floatValue]];
  [tileset setTileHeight:[att[@"tileheight"] floatValue]];
  [tileset setSpacing:[att[@"spacing"] integerValue]];
  [tileset setMargin:[att[@"margin"] integerValue]];
  return tileset;
}


#pragma mark - ACCESSORS
-(NSString *)description{
  return [NSString stringWithFormat:@"%@: %lu", [self name], (unsigned long)[self firstGID]];
}
@end
