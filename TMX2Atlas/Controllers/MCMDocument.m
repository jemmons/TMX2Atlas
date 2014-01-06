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


-(BOOL)revertToContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
  BOOL success =[super revertToContentsOfURL:url ofType:typeName error:outError];
  if(success){
    [(MCMWindowController *)[self windowControllers][0] setMap:[self map]];
  }
  return success;
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
  MCMWindowController *controller = [[MCMWindowController alloc] init];
  [controller setMap:[self map]];
  [self addWindowController:controller];
}


-(BOOL)prepareSavePanel:(NSSavePanel *)savePanel{
  [savePanel setShowsTagField:NO];
  [savePanel setExtensionHidden:NO];
  [savePanel setCanSelectHiddenExtension:NO];
  [savePanel setPrompt:@"Export"];
  [savePanel setMessage:@"This folder will be created and populated with\nan atlas and plist."];
  [savePanel setAllowedFileTypes:@[@"public.folder"]];
  return YES;
}


-(BOOL)writeSafelyToURL:(NSURL *)dirURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError *__autoreleasing *)outError{
  NSString *name = [dirURL lastPathComponent];
  [[NSFileManager defaultManager] createDirectoryAtURL:dirURL withIntermediateDirectories:NO attributes:nil error:NULL];
  
  NSDictionary *plist = [[self map] serialize];
  NSURL *plistURL = [[[dirURL URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"tmx"] URLByAppendingPathExtension:@"plist"];
  BOOL plistSuccess = [plist writeToURL:plistURL atomically:NO];
  
  NSDictionary *images = [[self map] tileImages];
  NSURL *atlasURL = [[dirURL URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"atlas"];
  BOOL atlasSuccess = [self saveImages:images toAtlas:atlasURL];

  return plistSuccess && atlasSuccess;
}


#pragma mark - UTILITY
-(BOOL)saveImages:(NSDictionary *)images toAtlas:(NSURL *)atlasURL{
  __block BOOL success = YES;
  //We don't care if this succeeds. If the directory doesn't exist we'll error our below.
  [[NSFileManager defaultManager] createDirectoryAtURL:atlasURL withIntermediateDirectories:NO attributes:nil error:NULL];
  
  [images enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSImage *image, BOOL *stop) {
    NSURL *imageURL = [[atlasURL URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"png"];
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
