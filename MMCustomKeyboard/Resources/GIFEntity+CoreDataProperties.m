//
//  GIFEntity+CoreDataProperties.m
//  MMCustomKeyboard
//
//  Created by mm0030240 on 20/10/15.
//  Copyright © 2015 mm0030240. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GIFEntity+CoreDataProperties.h"

@implementation GIFEntity (CoreDataProperties)

@dynamic gifURL;
@dynamic gifCategory;



//-(NSArray *)normalArray
//{
//	if([self.gifCategory  isEqual: @"Normal"])
//	{
//		return self.gifURL;
//	}
//	return 0;
//}
//
//-(NSArray *)awesomeArray
//
//{
//	if(self.gifCategory == @"Awesome")
//	{
//		return  self.gifURL;
//	}
//	return 0;
//}
@end
