#import "MCMDocument.h"

#import "MCMWindowController.h"
#import "MCMTMXParser.h"
#import "MCMMap.h"


@interface MCMDocument ()
@property MCMMap *map;
@end


@implementation MCMDocument
#pragma mark - INIT/SETUP
-(id)init{
  if((self = [super init])){
    //
  }
  return self;
}


#pragma mark - DOCUMENT METHODS
+(BOOL)autosavesInPlace{
  return NO;
}


-(BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
  BOOL success = YES;
  
  MCMTMXParser *parser = [[MCMTMXParser alloc] initWithURL:url];
  [self setMap:[parser parse]];
  
  if( ! [self map]){
    success = NO;
    *outError = [NSError errorWithDomain:@"TMX2AtlasDomain" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"Could not parse TMX file."}];
  }
  return success;
}


-(void)makeWindowControllers{
  NSWindowController *controller = [[MCMWindowController alloc] initWithMap:[self map]];
  [self addWindowController:controller];
  NSLog(@"TYPE: %@", [self fileType]);
}


-(BOOL)prepareSavePanel:(NSSavePanel *)savePanel{
  [savePanel setShowsTagField:NO];
  [savePanel setExtensionHidden:NO];
  [savePanel setCanSelectHiddenExtension:NO];
  [savePanel setPrompt:@"Export"];
  [savePanel setMessage:@"NOTE: an .atlas folder will be created\nautomatically along side this .plist"];
  [savePanel setAllowedFileTypes:@[@"plist"]];
  return YES;
}


-(BOOL)writeSafelyToURL:(NSURL *)url ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError *__autoreleasing *)outError{

  NSDictionary *plist = [[self map] serialize];
  BOOL plistSuccess = [plist writeToURL:url atomically:NO];
  
  NSDictionary *images = [[self map] tileImages];
  BOOL imageSuccess = [self saveAtlasImages:images withURL:url];
  return plistSuccess && imageSuccess;
}


#pragma mark - UTILITY
-(NSURL *)atlasURLFromURL:(NSURL *)plistURL{
  return [[plistURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"atlas"];
}


-(BOOL)saveAtlasImages:(NSDictionary *)images withURL:(NSURL *)plistURL{
  __block BOOL success = YES;
  NSURL *dirURL = [self atlasURLFromURL:plistURL];
  //We don't care if this succeeds. If the directory doesn't exist we'll error our below.
  [[NSFileManager defaultManager] createDirectoryAtURL:dirURL withIntermediateDirectories:NO attributes:nil error:NULL];
  
  [images enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSImage *image, BOOL *stop) {
    NSURL *imageURL = [dirURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    CGImageRef imageRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    NSData *data = [bitmap representationUsingType:NSPNGFileType properties:nil];
    if( ! [data writeToURL:imageURL atomically:NO]){
      success = NO;
      //We could cancel the loop here, but we've flagged the error and it's more consistent to finish writing everything we can.
    }
  }];

  return success;
}
@end
