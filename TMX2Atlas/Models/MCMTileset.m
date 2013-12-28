#import "MCMTileset.h"

NSString * const TMXTilesetNameKey = @"TMXTilesetName";
NSString * const TMXTilesetFirstGIDKey = @"TMXTilesetFirstGID";
NSString * const TMXTilesetCountKey = @"TMXTilesetCount";
NSString * const TMXTilesetTileWidthKey = @"TMXTilesetTileWidth";
NSString * const TMXTilesetTileHeightKey = @"TMXTilesetTileHeight";


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


-(NSUInteger)tileCount{
  //TODO: count based on tile size and image dimensions.
  return 0;
}


#pragma mark - ACTIONS
-(NSDictionary *)serialize{
  return @{TMXTilesetNameKey: [self name],
           TMXTilesetFirstGIDKey: @([self firstGID]),
           TMXTilesetCountKey: @([self tileCount]),
           TMXTilesetTileWidthKey: @([self tileWidth]),
           TMXTilesetTileHeightKey: @([self tileHeight])};
}
@end
