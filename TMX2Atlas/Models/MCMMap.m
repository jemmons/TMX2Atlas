#import "MCMMap.h"

#import "MCMTileset.h"
#import "MCMLayer.h"

#import "NSArray+HOF.h"

NSString * const TMXMapVersionKey = @"TMXMapVersion";
NSString * const TMXMapOrientationKey = @"TMXMapOrientation";
NSString * const TMXMapWidthKey = @"TMXMapWidth";
NSString * const TMXMapHeightKey = @"TMXMapHeight";
NSString * const TMXMapTileWidthKey = @"TMXMapTileWidth";
NSString * const TMXMapTileHeightKey = @"TMXMapTileHeight";
NSString * const TMXMapTilesetsKey = @"TMXMapTiles";
NSString * const TMXMapLayersKey = @"TMXMapLayers";


@implementation MCMMap
#pragma mark - INIT/SETUP
+(instancetype)mapWithAttributes:(NSDictionary *)att{
  NSParameterAssert(att[@"orientation"] && att[@"height"] && att[@"width"] && att[@"tileheight"] && att[@"tilewidth"]);
  NSParameterAssert([att[@"orientation"] isEqualToString:@"orthogonal"]);

  MCMMap *map = [MCMMap new];
  [map setVersion:att[@"version"]];
  [map setHeight:[att[@"height"] integerValue]];
  [map setWidth:[att[@"width"] integerValue]];
  [map setTileHeight:[att[@"tileheight"] floatValue]];
  [map setTileWidth:[att[@"tilewidth"] floatValue]];
  [map setOrientation:att[@"orientation"]];
  [map setTilesets:@[]];
  [map setLayers:@[]];
  return map;
}


#pragma mark - ACCESSORS
-(void)addTileset:(MCMTileset *)aTileset{
  [self setTilesets:[[self tilesets] arrayByAddingObject:aTileset]];
}


-(void)addLayer:(MCMLayer *)aLayer{
  [self setLayers:[[self layers] arrayByAddingObject:aLayer]];
}


-(NSDictionary *)tileImages{
  NSMutableDictionary *tileImages = [NSMutableDictionary dictionaryWithCapacity:5000];
  [[self tilesets] enumerateObjectsUsingBlock:^(MCMTileset *tileset, NSUInteger idx, BOOL *stop) {
    [tileImages addEntriesFromDictionary:[tileset images]];
  }];
  return tileImages;
}


-(NSString *)description{
  return [NSString stringWithFormat:@"%@\nversion: %@\norientation: %@\nmap size: [%lu, %lu]\ntile size: [%f, %f]\ntilesets: %@\nlayers: %@", [super description], [self version], [self orientation], (unsigned long)[self width], (unsigned long)[self height], [self tileWidth], [self tileHeight], [self tilesets], [self layers]];
}


#pragma mark - ACTIONS
-(NSDictionary *)serialize{
  return @{TMXMapVersionKey: [self version],
           TMXMapOrientationKey: [self orientation],
           TMXMapWidthKey: @([self width]),
           TMXMapHeightKey: @([self height]),
           TMXMapTileWidthKey: @([self tileWidth]),
           TMXMapTileHeightKey: @([self tileHeight]),
           TMXMapTilesetsKey: [self serializeTilesets],
           TMXMapLayersKey: [self serializeLayers]};
}


#pragma mark - UTILITY
-(NSArray *)serializeTilesets{
  return [[self tilesets] map:^id(id it) {
    return [it serialize];
  }];
}


-(NSArray *)serializeLayers{
  return [[self layers] map:^id(id it) {
    return [it serialize];
  }];
}
@end
