//
//  XLFormDataSource.m
//  Linkage
//
//  Created by Mac mini on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//
#import "XLFormDataSource.h"
#import "FormDescriptorCell.h"
#import "ExpandFormSectionDescriptor.h"

@interface XLFormRowDescriptor(_XLFormDataSource)

@property (readonly) NSArray * observers;
-(BOOL)evaluateIsDisabled;
-(BOOL)evaluateIsHidden;

@end

@interface XLFormSectionDescriptor(_XLFormDataSource)

-(BOOL)evaluateIsHidden;

@end

@interface XLFormDescriptor (_XLFormDataSource)

@property NSMutableDictionary* rowObservers;

@end

@implementation XLFormDataSource

- (instancetype)initWithViewController:(UIViewController<FormViewController> *)viewController tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.tableView = tableView;
    }
    return self;
}

-(void)setForm:(XLFormDescriptor *)form
{
    _form.delegate = nil;
    _form = form;
    _form.delegate = self;
    if ([self.viewController isViewLoaded]){
        [self.tableView reloadData];
    }
}

#pragma mark - XLFormViewControllerDelegate
-(NSDictionary *)formValues
{
    return [self.form formValues];
}

-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    UITableViewCell<FormDescriptorCell> *cell = (UITableViewCell<FormDescriptorCell> *)[formRow cellForFormController:nil];
    if ([cell respondsToSelector:@selector(formDescriptorCellDidSelectedWithViewController:)]){
        [cell formDescriptorCellDidSelectedWithViewController:self.viewController];
    }
}

-(void)deselectFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - XLFormDescriptorDelegate
-(void)formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)formRowHasBeenRemoved:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)formSectionHasBeenRemoved:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)formSectionHasBeenAdded:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    [self updateAfterDependentRowChanged:formRow];
}

-(void)formRowDescriptorPredicateHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue predicateType:(XLPredicateType)predicateType
{
    if (oldValue != newValue) {
        [self updateAfterDependentRowChanged:formRow];
    }
}

-(void)updateAfterDependentRowChanged:(XLFormRowDescriptor *)formRow
{
    [self updateFormRow:formRow];
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
    UITableViewCell<FormDescriptorCell> * baseCell = (UITableViewCell<FormDescriptorCell> *)[rowDescriptor cellForFormController:nil];
    if ([baseCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor){
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XLFormSectionDescriptor *sectionDescriptor = [self.form.formSections objectAtIndex:section];
    if([sectionDescriptor conformsToProtocol:@protocol(ExpandFormSectionDescriptorDelegate)]){
        return [((XLFormSectionDescriptor<ExpandFormSectionDescriptorDelegate> *)sectionDescriptor) heightForSectionHeader];
    }
    return 0;
}

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
    if ([cell respondsToSelector:@selector(formDescriptorCellCanBecomeFirstResponder)] && [cell respondsToSelector:@selector(formDescriptorCellBecomeFirstResponder)]) {
        if (!([cell formDescriptorCellCanBecomeFirstResponder] && [cell formDescriptorCellBecomeFirstResponder])){
            [tableView endEditing:YES];
        }
    }
    [self didSelectFormRow:row];
}

#pragma mark - Helpers

-(void)reloadFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath && self.tableView){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(UITableViewCell<XLFormDescriptorCell> *)updateFormRow:(XLFormRowDescriptor *)formRow
{
    UITableViewCell<XLFormDescriptorCell> * cell = [formRow cellForFormController:nil];
    [self configureCell:cell];
    [cell setNeedsUpdateConstraints];
    [cell setNeedsLayout];
    return cell;
}

-(void)configureCell:(UITableViewCell<XLFormDescriptorCell>*) cell
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
