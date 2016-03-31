//
// Created by Tom Atterton on 30/03/16.
// Copyright (c) 2016 mm0030240. All rights reserved.
//

#import "MMKeyboardSelection.h"

@interface MMKeyboardSelection () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation MMKeyboardSelection
- (instancetype)initWithData:(NSArray *)data {

	self = [super init];
	if (self) {

		self.data = data;

		[self setup];
	}

	return self;
}

- (void)setup {


	self.tableView = [UITableView new];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
	self.tableView.clipsToBounds = YES;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self addSubview:self.tableView];


	NSDictionary *views = @{@"tableView" : self.tableView};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	cell.textLabel.text = self.data[(NSUInteger) indexPath.row];

	return cell;
}


@end