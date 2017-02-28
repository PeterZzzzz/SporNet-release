//
//  SNPublishViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 17/1/4.
//  Copyright © 2017年 Peng Wang. All rights reserved.
//

#import "SNPublishViewController.h"
#import "SNMomentManager.h"
#import "FriendsMomentModel.h"

#define ADD_IMAGE [UIImage imageNamed:@"add"]


@interface SNPublishViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, SNMomentManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UITextView *momentContentTextView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (nonatomic, assign)        NSInteger imageBtnTag;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation SNPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SNMomentManager defaultManager].delegate = self;
    self.momentContentTextView.delegate = self;
    self.momentContentTextView.text = @"Write more details...";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SNMomentDelegate

- (void)publishSuccessfully {

    [self cancelBtnClick];
    
    if ([self.delegate respondsToSelector:@selector(publishSuccessful)]) {
        
        [self.delegate publishSuccessful];
    }
}

- (void)publishFailure{
    
    [ProgressHUD showError:@"Publish Failure"];

}

- (IBAction)cancelBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)publishBtnClick {

        if ([self checkAllImages]) {
            
            [ProgressHUD show:@"Publishing..."];
            
            FriendsMomentModel *newComment = [[FriendsMomentModel alloc]init];
            NSMutableArray *arrayM = [NSMutableArray array];
            //进行存储
            for (int i = 1; i < 7; i++) {
                
                UIButton *btn = (UIButton *)[self.btnView viewWithTag:i];
                if([btn.currentImage isEqual:ADD_IMAGE]) continue;
                NSData *imageData = UIImageJPEGRepresentation(btn.currentImage, 0.9);
                
                AVFile *file = [AVFile fileWithData:imageData];
                [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [newComment setObject:arrayM forKey:@"MomentsPhotoArray"];
                        [arrayM addObject:file.url];
                        [newComment saveEventually];
                        
                    }else {
                        
//                        NSLog(@"Saving Pics Error %@", error.description);
                    }
                    
                }];
            }
            
            [[SNMomentManager defaultManager]publishUserMomentsWithUser:newComment Text:self.momentContentTextView.text];
            
        } else {
            [ProgressHUD showError:@"Please add image"];
        }
        
}

- (IBAction)imageBtnClick:(UIButton *)sender {
    
    UIButton *btn = [self.btnView viewWithTag:sender.tag];
    self.imageBtnTag = sender.tag;
    
    if ([btn.currentImage isEqual:ADD_IMAGE]) {
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        [self presentViewController:self.alert animated:YES completion:nil];
//        NSLog(@"alert");
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIButton *imageBtn = [self.btnView viewWithTag:self.imageBtnTag];
    UIImage *pickImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [imageBtn setImage:pickImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)checkAllImages{
    
    for (int i = 1; i<7; i++) {
        UIButton *btn = [self.btnView viewWithTag:i];
        if (![btn.currentImage isEqual:ADD_IMAGE]) {
            return YES;
        }
    }
    return NO;
}

#pragma lazy load

-(UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = self;
        
    }
    
    return _imagePicker;
}

-(UIAlertController *)alert{
    if (_alert == nil) {
        _alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Change Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            UIButton *btn = [self.btnView viewWithTag:self.imageBtnTag];
            [btn setImage:ADD_IMAGE forState:UIControlStateNormal];
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
    }
    return _alert;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Write more details..."]) {
        textView.text = @"";
//        NSLog(@"aaaaaa");
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<1) {
        textView.text = @"Write more details...";
//        NSLog(@"bbbbbbb");

    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end











