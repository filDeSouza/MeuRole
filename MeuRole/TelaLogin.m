//
//  TelaLogin.m
//  MeuRole
//
//  Created by Filipe de Souza on 13/01/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import "TelaLogin.h"
#import "DejalActivityView.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+LBBlurredImage.h"
#import "FeMViewController.h"

#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_AUX [DOCUMENTS stringByAppendingPathComponent:@"pickerAux.plist"]
#define PATH_LOGIN [DOCUMENTS stringByAppendingPathComponent:@"pickerLogin.plist"]
#define PATH_PICKERVIEW [DOCUMENTS stringByAppendingPathComponent:@"pickerView.plist"]
#define PATH_PICKERVIEWESPECIALIDADES [DOCUMENTS stringByAppendingPathComponent:@"pickerViewEspecialidades.plist"]
#define PATH_NAOTEMLOGIN [DOCUMENTS stringByAppendingPathComponent:@"naoTemLogin.plist"]


@implementation TelaLogin

- (void)viewDidLoad
{
    [super viewForBaselineLayout];
    // Do any additional setup after loading the view, typically from a nib.
    
    FeMViewController *novaTela = [FeMViewController new];
    novaTela.navigationController.navigationBarHidden = YES;
    
    do{
        self.numeroRandom = arc4random() % 27;
    }while (self.numeroRandom ==0);
    
    NSString *nomeImagem = [NSString stringWithFormat:@"%i", self.numeroRandom];
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem] ];
    
    [self.imagemFundoViewLogin setImageToBlur:[UIImage imageNamed:nomeImagem]
                               blurRadius:kLBBlurredImageDefaultBlurRadius
                          completionBlock:^{
                              NSLog(@"Funcionou");
                          }];
    
    self.login.keyboardAppearance = UIKeyboardAppearanceDark;

    self.btGravarRole.hidden =
    self.labelGravarLocal.hidden =
    self.btBuscarRole.hidden =
    self.labelBuscarLocal.hidden = YES;
    
    self.btCadastrarDepois.hidden =
    self.labelCadastrarDepois.hidden =
    self.cadastreLoginBt.hidden =
    self.labelCadastreUmLogin.hidden = NO;
    
    self.btCadastrar.hidden =
    self.login.hidden =
    self.btCadastrar.hidden = YES;
    
    NSDictionary *dicionarioLogin = [NSDictionary dictionaryWithContentsOfFile:PATH_LOGIN];
    NSString *loginPicker = [dicionarioLogin objectForKey:@"pickerLogin"];
    
    NSLog(@"login:   %@", loginPicker);
    
    if (loginPicker.length > 0) {
        
        self.viewForBaselineLayout.hidden = YES;
        
    }else{
        
        self.login.hidden =
        self.btCadastrar.hidden = YES;
        
    }
    
    
    
    NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
    NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
    Tipoescolhido = @"";
    NSDictionary *dicEscolhido =@{@"pickerView": Tipoescolhido};
    [dicEscolhido writeToFile:PATH_PICKERVIEW atomically:YES];
    
    
    NSDictionary *dicionarioEspecialidade = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWESPECIALIDADES];
    NSString *TipoescolhidoEspecialidade = [dicionarioEspecialidade objectForKey:@"pickerViewEspecialidades"];
    TipoescolhidoEspecialidade = @"";
    NSDictionary *dicEscolhidoEspecialidade =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
    [dicEscolhidoEspecialidade writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
    
    [self.viewForBaselineLayout resignFirstResponder];
    
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.viewForBaselineLayout endEditing:YES];
    
}

- (IBAction)cadastreUmLogin:(UIButton *)sender {
    
    self.labelCadastreUmLogin.hidden =
    self.cadastreLoginBt.hidden = YES;
    self.btCadastrarDepois.hidden =
    self.labelCadastrarDepois.hidden =
    self.labelCadastrar.hidden =
    self.login.hidden =
    self.btCadastrar.hidden = NO;
    
    NSDictionary *dicionarioAux = [NSDictionary dictionaryWithContentsOfFile:PATH_AUX];
    NSString *aux = [dicionarioAux objectForKey:@"pickerAux"];
    NSLog(@"%@", aux);
    
}

- (IBAction)cadastrar:(UIButton *)sender {
    
    NSString *auxValor = [NSString stringWithFormat:@"0"];
    NSDictionary *dicAux = @{@"pickerAux": auxValor};
    [dicAux writeToFile:PATH_AUX atomically:YES];
    
    NSString *campoTexto = [NSString stringWithFormat:@"%@", self.login.text];
    
    NSLog(@"Campo de texto %@", campoTexto);
    
    if (campoTexto.length == 0) {
        
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                         message:@"Favor digitar um login"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok", nil];
        
        [alerta show];
        
    }else if(campoTexto.length > 0){
    
    [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/logins"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    for ( NSDictionary *dicionario in responseObject ) {
                                        
                                        self.loginWS = [dicionario objectForKey:@"login"];
                                        NSLog(@"Campo de webservice %@", self.loginWS);

                                        if ([self.loginWS isEqualToString:campoTexto]) {
                                            
                                            NSString *auxValor = [NSString stringWithFormat:@"1"];
                                            NSDictionary *dicAux = @{@"pickerAux": auxValor};
                                            [dicAux writeToFile:PATH_AUX atomically:YES];

                                            NSDictionary *dicionarioAux = [NSDictionary dictionaryWithContentsOfFile:PATH_AUX];
                                            NSString *aux = [dicionarioAux objectForKey:@"pickerAux"];
                                            NSLog(@"Variavel auxiliar %@", aux);
                                            
                                        }else{
                                            
                                            
                                            NSDictionary *dicEscolhidoValorIni =@{@"pickerLogin": self.login.text};
                                            [dicEscolhidoValorIni writeToFile:PATH_LOGIN atomically:YES];
                                            
                                            NSDictionary *dicionarioAux = [NSDictionary dictionaryWithContentsOfFile:PATH_AUX];
                                            NSString *aux = [dicionarioAux objectForKey:@"pickerAux"];
                                            NSLog(@"Variavel auxiliar %@", aux);
                                        }
                                        
                                        
                                    }
                                    
                                    NSDictionary *dicionarioAux = [NSDictionary dictionaryWithContentsOfFile:PATH_AUX];
                                    NSString *aux = [dicionarioAux objectForKey:@"pickerAux"];
                                    NSLog(@"Variavel auxiliar depois %@", aux);
                                    
                                    
                                    NSDictionary *dados = @{@"login": self.login.text};
                                    
                                    if ([aux intValue] == 1) {
                                        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                         message:@"Este login já existe, favor cadastrar outro"
                                                                                        delegate:self
                                                                               cancelButtonTitle:nil
                                                                               otherButtonTitles:@"Ok", nil];
                                        
                                        [alerta show];
                                    }else{
                                        
                                        NSString *auxValor = [NSString stringWithFormat:@"0"];
                                        NSDictionary *dicAux = @{@"naoTemLogin": auxValor};
                                        [dicAux writeToFile:PATH_NAOTEMLOGIN atomically:YES];
                                        
                                        [[AFHTTPSessionManager manager] POST:@"http://45.55.178.46:3000/logins" parameters:dados success:^(NSURLSessionDataTask *task, id responseObject) {
                                            
                                            
                                            // precisa mexer aqui
                                            
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            
                                            // precisa mexer aqui
                                            
                                        }];
                                        
                                        NSDictionary *dicEscolhidoValorIni =@{@"pickerLogin": self.login.text};
                                        [dicEscolhidoValorIni writeToFile:PATH_LOGIN atomically:YES];
                                        
                                        [DejalBezelActivityView activityViewForView:self.viewForBaselineLayout];
                                        
                                        self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                                             target:self
                                                                                           selector:@selector(abrir)
                                                                                           userInfo:nil
                                                                                            repeats:NO];
                                        
                                    }
                                    
                                }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    
                                }];
    
    }
    
    
    
}

-(void)abrir{
    
    self.viewForBaselineLayout.hidden = YES;
    
    
//    FeMViewController *novaTela = [FeMViewController new];
//    novaTela.navigationController.navigationBarHidden = NO;
//    //novaTela.navigationItem.title.
    
    self.btGravarRole.hidden =
    self.labelGravarLocal.hidden =
    self.btBuscarRole.hidden =
    self.labelBuscarLocal.hidden = NO;
    
}



@end
