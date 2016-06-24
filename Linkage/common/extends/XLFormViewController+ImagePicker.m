//
//  XLFormViewController+ImagePicker.m
//  Linkage
//
//  Created by lihaijian on 16/3/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "XLFormViewController+ImagePicker.h"
#import "SOImage.h"
#import "UIViewController+TRImagePicker.h"
#import "SOImageFormCell.h"
#import "LinkUtil.h"

@implementation XLFormViewController (ImagePicker)

-(void)addPhotoButtonTapped:(XLFormRowDescriptor *)formRow
{
    [self deselectFormRow:formRow];
    [self addSignalPhoto:^(UIImage *image, NSString *fileName) {
        //添加到当前列的value里面
        SOImage *model = [[SOImage alloc]init];
        model.imageName = fileName;
        model.createDate = [NSDate date];
        model.image = image;
        
        //上传到服务端
        [LinkUtil uploadWithUrl:CompanyLogoUrl image:UIImageJPEGRepresentation(image, 0.75) name:fileName success:^(id responseObject) {
            NSString *imageUrl = responseObject[@"result"][@"icon"];
            model.imageUrl = imageUrl;
        }];
        
        //添加新的一列
        XLFormRowDescriptor *newRow = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:SOImageRowDescriporType];
        newRow.value = model;
        XLFormSectionDescriptor *currentFormSection = formRow.sectionDescriptor;
        [currentFormSection addFormRow:newRow afterRow:formRow];
    }];
}

-(void)addSoImage:(XLFormRowDescriptor *)formRow
{
    [self deselectFormRow:formRow];
    [self addSignalPhoto:^(UIImage *image, NSString *fileName) {
        //添加到当前列的value里面
        SOImage *model = [[SOImage alloc]init];
        model.imageName = fileName;
        model.createDate = [NSDate date];
        model.image = image;
        
        //上传到服务端
        [LinkUtil uploadWithUrl:SoUrl image:UIImageJPEGRepresentation(image, 0.75) name:fileName success:^(id responseObject) {
            NSString *imageUrl = responseObject[@"result"][@"icon"];
            model.imageUrl = imageUrl;
        }];
        
        //添加新的一列
        XLFormRowDescriptor *newRow = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:SOImageRowDescriporType];
        newRow.value = model;
        XLFormSectionDescriptor *currentFormSection = formRow.sectionDescriptor;
        [currentFormSection addFormRow:newRow afterRow:formRow];
    }];
}

#pragma mark - 重写tableviewDataSource方法
-(BOOL)imageWithTableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *row = [self.form formRowAtIndex:indexPath];
    if ([row.sectionDescriptor isKindOfClass:[SpecialFormSectionDescriptor class]]) {
        return YES;
    }else{
        XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
        if (rowDescriptor.isDisabled || !rowDescriptor.sectionDescriptor.isMultivaluedSection){
            return NO;
        }
        UITableViewCell<XLFormDescriptorCell> * baseCell = [rowDescriptor cellForFormController:self];
        if ([baseCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor){
            return NO;
        }
        return YES;
    }
}

-(UITableViewCellEditingStyle)imageWithTableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *row = [self.form formRowAtIndex:indexPath];
    if ([row.sectionDescriptor isKindOfClass:[SpecialFormSectionDescriptor class]]) {
        if (indexPath.row == 0){
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }else{
        XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
        XLFormSectionDescriptor * section = row.sectionDescriptor;
        if (section.sectionOptions & XLFormSectionOptionCanInsert){
            if (section.formRows.count == indexPath.row + 2){
                if ([[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:row.rowType]){
                    UITableViewCell<XLFormDescriptorCell> * cell = [row cellForFormController:self];
                    UIView * firstResponder = [cell findFirstResponder];
                    if (firstResponder){
                        return UITableViewCellEditingStyleInsert;
                    }
                }
            }
            else if (section.formRows.count == (indexPath.row + 1)){
                return UITableViewCellEditingStyleInsert;
            }
        }
        if (section.sectionOptions & XLFormSectionOptionCanDelete){
            return UITableViewCellEditingStyleDelete;
        }
        return UITableViewCellEditingStyleNone;
    }
}

-(void)imageWithTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *row = [self.form formRowAtIndex:indexPath];
    //加入业务逻辑
    if([row.sectionDescriptor isKindOfClass:[SpecialFormSectionDescriptor class]] && editingStyle == UITableViewCellEditingStyleDelete){
        if ([row.value isKindOfClass:[SOImage class]]) {
            [TRImagePickerDelegate removeImageIndentifyByKey:((SOImage *)row.value).imageName];
        }
    }
    //原来的处理方式
    if ([row.sectionDescriptor isKindOfClass:[SpecialFormSectionDescriptor class]] && editingStyle == UITableViewCellEditingStyleInsert) {
            [self addSoImage:row];
    }else{
        if (editingStyle == UITableViewCellEditingStyleDelete){
            XLFormRowDescriptor * multivaluedFormRow = [self.form formRowAtIndex:indexPath];
            // end editing
            UIView * firstResponder = [[multivaluedFormRow cellForFormController:self] findFirstResponder];
            if (firstResponder){
                [self.tableView endEditing:YES];
            }
            [multivaluedFormRow.sectionDescriptor removeFormRowAtIndex:indexPath.row];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.editing = !self.tableView.editing;
                self.tableView.editing = !self.tableView.editing;
            });
            if (firstResponder){
                UITableViewCell<XLFormDescriptorCell> * firstResponderCell = [firstResponder formDescriptorCell];
                XLFormRowDescriptor * rowDescriptor = firstResponderCell.rowDescriptor;
                [self inputAccessoryViewForRowDescriptor:rowDescriptor];
            }
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert){
            XLFormSectionDescriptor * multivaluedFormSection = [self.form formSectionAtIndex:indexPath.section];
            if (multivaluedFormSection.sectionInsertMode == XLFormSectionInsertModeButton && multivaluedFormSection.sectionOptions & XLFormSectionOptionCanInsert){
                [self multivaluedInsertButtonTapped:multivaluedFormSection.multivaluedAddButton];
            }
            else{
                XLFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
                [multivaluedFormSection addFormRow:formRowDescriptor];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.tableView.editing = !self.tableView.editing;
                    self.tableView.editing = !self.tableView.editing;
                });
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[formRowDescriptor cellForFormController:self];
                if ([cell formDescriptorCellCanBecomeFirstResponder]){
                    [cell formDescriptorCellBecomeFirstResponder];
                }
            }
        }
    }
}
    
@end