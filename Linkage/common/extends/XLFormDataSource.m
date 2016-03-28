//
//  XLFormDataSource.m
//  Linkage
//
//  Created by Mac mini on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "XLFormDataSource.h"
#import <XLForm/XLForm.h>
#import "FormDescriptorCell.h"

@implementation XLFormDataSource

- (instancetype)initWithViewController:(UIViewController *)viewController tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.tableView = tableView;
    }
    return self;
}

#pragma mark - XLFormViewControllerDelegate
-(NSDictionary *)formValues
{
    return [self.form formValues];
}

-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    XLFormBaseCell<FormDescriptorCell> *cell = (XLFormBaseCell<FormDescriptorCell> *)[formRow cellForFormController:nil];
    if ([cell respondsToSelector:@selector(formDescriptorCellDidSelectedWithViewController:)]){
        [cell formDescriptorCellDidSelectedWithViewController:self.viewController];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.form.formSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.form.formSections.count){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
    }
    return [[[self.form.formSections objectAtIndex:section] formRows] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:indexPath];
    return [rowDescriptor cellForFormController:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:indexPath];
    [self updateFormRow:rowDescriptor];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    if (rowDescriptor.isDisabled || !rowDescriptor.sectionDescriptor.isMultivaluedSection){
        return NO;
    }
    XLFormBaseCell * baseCell = [rowDescriptor cellForFormController:nil];
    if ([baseCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor){
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.form.formSections objectAtIndex:section] title];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [[self.form.formSections objectAtIndex:section] footerTitle];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    Class cellClass = [[rowDescriptor cellForFormController:nil] class];
    if ([cellClass respondsToSelector:@selector(formDescriptorCellHeightForRowDescriptor:)]){
        return [cellClass formDescriptorCellHeightForRowDescriptor:rowDescriptor];
    }
    return tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    Class cellClass = [[rowDescriptor cellForFormController:nil] class];
    if ([cellClass respondsToSelector:@selector(formDescriptorCellHeightForRowDescriptor:)]){
        return [cellClass formDescriptorCellHeightForRowDescriptor:rowDescriptor];
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    if (row.isDisabled) {
        return;
    }
    UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[row cellForFormController:nil];
    if (!([cell formDescriptorCellCanBecomeFirstResponder] && [cell formDescriptorCellBecomeFirstResponder])){
        [tableView endEditing:YES];
    }
    [self didSelectFormRow:row];
}

#pragma mark - Helpers

-(void)deselectFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath && self.tableView){
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


-(void)reloadFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath && self.tableView){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(XLFormBaseCell *)updateFormRow:(XLFormRowDescriptor *)formRow
{
    XLFormBaseCell * cell = [formRow cellForFormController:nil];
    [self configureCell:cell];
    [cell setNeedsUpdateConstraints];
    [cell setNeedsLayout];
    return cell;
}

-(void)configureCell:(XLFormBaseCell*) cell
{
    [cell update];
    [cell.rowDescriptor.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * stop) {
        [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
    if (cell.rowDescriptor.isDisabled){
        [cell.rowDescriptor.cellConfigIfDisabled enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * stop) {
            [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
        }];
    }
}
@end
