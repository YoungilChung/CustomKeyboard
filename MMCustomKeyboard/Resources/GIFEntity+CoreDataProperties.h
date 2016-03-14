//
//  GIFEntity+CoreDataProperties.h
//  MMCustomKeyboard
//
//  Created by mm0030240 on 20/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GIFEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GIFEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *gifURL;
@property (nullable, nonatomic, retain) NSString *gifCategory;
//@property(nonatomic,strong)NSArray *normalArray;
//@property(nonatomic,strong)NSArray *awesomeArray;

@end

NS_ASSUME_NONNULL_END
