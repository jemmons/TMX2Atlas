#import "MCMMap.h"

#import "MCMTileset.h"
#import "MCMLayer.h"


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


-(NSString *)description{
  return [NSString stringWithFormat:@"%@\nversion: %@\norientation: %@\nmap size: [%lu, %lu]\ntile size: [%f, %f]\ntilesets: %@\nlayers: %@", [super description], [self version], [self orientation], (unsigned long)[self width], (unsigned long)[self height], [self tileWidth], [self tileHeight], [self tilesets], [self layers]];
}
@end
