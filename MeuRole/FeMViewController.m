//
//  FeMViewController.m
//  MeuRole
//
//  Created by Filipe de Souza on 29/08/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import "FeMViewController.h"
#import "DejalActivityView.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "UIImageView+LBBlurredImage.h"

#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_LOGIN [DOCUMENTS stringByAppendingPathComponent:@"pickerLogin.plist"]
#define PATH_PICKERVIEW [DOCUMENTS stringByAppendingPathComponent:@"pickerView.plist"]
#define PATH_PICKERVIEWESPECIALIDADES [DOCUMENTS stringByAppendingPathComponent:@"pickerViewEspecialidades.plist"]
#define PATH_LOCALIGUAL [DOCUMENTS stringByAppendingPathComponent:@"pickerLocalIgual.plist"]
#define PATH_LUGARESENCONTRADOS [DOCUMENTS stringByAppendingPathComponent:@"lugaresEncontrados.plist"]
#define PATH_NAOTEMLOGIN [DOCUMENTS stringByAppendingPathComponent:@"naoTemLogin.plist"]




@interface FeMViewController (){
    
    CLLocationManager *locationManager;
}

@end

@implementation FeMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//	 Do any additional setup after loading the view, typically from a nib.
//    
//     Deixar a navigation bar transparente
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.360];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;

    self.tituloApp1.text = [NSString stringWithFormat:@"Meu"];
    [self.tituloApp1 setFont:[UIFont fontWithName:@"Prototype" size:75.0]];
    
    self.tituloApp2.text = [NSString stringWithFormat:@"Role"];
    [self.tituloApp2 setFont:[UIFont fontWithName:@"Prototype" size:95.0]];
    
    do{
        self.numeroRandom2 = arc4random() % 27;
    }while (self.numeroRandom2 ==0);
    
    NSString *nomeImagem2 = [NSString stringWithFormat:@"%i", self.numeroRandom2];
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem] ];
    
    [self.imagemFundoViewLogin setImageToBlur:[UIImage imageNamed:nomeImagem2]
                                   blurRadius:kLBBlurredImageDefaultBlurRadius
                              completionBlock:^{
                                  NSLog(@"Funcionou");
                              }];
    
    Reachability *conectividade = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    conectividade.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.conectado = [NSString stringWithFormat:@"Com internet!"];
            NSLog(@"Tem internet!");
        });
    };
    
    NSDictionary *dicionarioLogin = [NSDictionary dictionaryWithContentsOfFile:PATH_LOGIN];
    NSString *loginPicker = [dicionarioLogin objectForKey:@"pickerLogin"];
    
    if (loginPicker.length == 0) {
        
        self.btGravarRole.hidden =
        self.labelGravarLocal.hidden =
        self.btBuscarRole.hidden =
        self.labelBuscarLocal.hidden = YES;
        
    }    
    
    self.labelCadastrar.hidden =
    self.campoTextoLogin.hidden =
    self.btCadastrar.hidden = YES;
    
    
    conectividade.unreachableBlock = ^(Reachability*reach){
        
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.conectado = [NSString stringWithFormat:@"Sem internet!"];
            NSLog(@"Não tem internet!");
        });
        
    };
    
    [conectividade startNotifier];
    
//    self.telaLogin.backgroundColor = [UIColor colorWithWhite:0.837 alpha:0.640];
//    self.telaLogin.opaque = YES;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    
    [[self.btGravarRole layer] setBorderWidth:1.0f];
    [[self.btGravarRole layer] setCornerRadius:2.0f];
    [[self.btGravarRole layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.labelGravarLocal.text = [NSString stringWithFormat:@"gravar rolê"];
    [self.labelGravarLocal setFont:[UIFont fontWithName:@"Prototype" size:30.0]];

    [[self.btBuscarRole layer] setBorderWidth:1.0f];
    [[self.btBuscarRole layer] setCornerRadius:2.0f];
    [[self.btBuscarRole layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.labelBuscarLocal.text = [NSString stringWithFormat:@"buscar rolê"];
    [self.labelBuscarLocal setFont:[UIFont fontWithName:@"Prototype" size:30.0]];
    
    [[self.campoTextoLogin layer] setBorderWidth:1.0f];
    [[self.campoTextoLogin layer] setCornerRadius:2.0f];
    [[self.campoTextoLogin layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoTextoLogin.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    [self.campoTextoLogin setFont:[UIFont fontWithName:@"Coolvetica" size:25.0]];
    
    [[self.btCadastrarUmLogin layer] setBorderWidth:1.0f];
    [[self.btCadastrarUmLogin layer] setCornerRadius:2.0f];
    [[self.btCadastrarUmLogin layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.labelCadastreUmLogin setFont:[UIFont fontWithName:@"Coolvetica" size:25.0]];
    
    [[self.btCadastrarDepois layer] setBorderWidth:1.0f];
    [[self.btCadastrarDepois layer] setCornerRadius:2.0f];
    [[self.btCadastrarDepois layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.labelCadastrarDepois setFont:[UIFont fontWithName:@"Coolvetica" size:25.0]];
    
    [[self.btCadastrar layer] setBorderWidth:1.0f];
    [[self.btCadastrar layer] setCornerRadius:2.0f];
    [[self.btCadastrar layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.labelCadastrar setFont:[UIFont fontWithName:@"Coolvetica" size:25.0]];
    
    self.login.keyboardAppearance = UIKeyboardAppearanceDark;

    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:0.610 alpha:0.700]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    [backButton setTintColor:[UIColor whiteColor]];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 10.0;
    [label setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"Meu Rolê"];
    [self.navigationItem setTitleView:label];
    
    NSLog(@"login:   %@", loginPicker);
    
    if (loginPicker.length > 0) {
        
        self.telaLogin.hidden = YES;
        
    }
    
    do{
    self.numeroRandom = arc4random() % 27;
    }while (self.numeroRandom ==0);
    
    NSString *nomeImagem = [NSString stringWithFormat:@"%i", self.numeroRandom];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem] ];
    
    [self.imagemBackGround setImageToBlur:[UIImage imageNamed:nomeImagem]
                               blurRadius:kLBBlurredImageDefaultBlurRadius
                          completionBlock:^{
                              NSLog(@"Funcionou");
                          }];
    
    
//    self.cadastreLoginBt.hidden = NO;
//    self.login.hidden =
//    self.btCadastrar.hidden = YES;
//    
//    self.imagemBackGround.image = [UIImage imageNamed:nomeImagem];
//    
//    NSDictionary *dicionarioLogin = [NSDictionary dictionaryWithContentsOfFile:PATH_LOGIN];
//    NSString *loginPicker = [dicionarioLogin objectForKey:@"pickerLogin"];
//    
//    if (loginPicker.length > 0) {
//        
//        [self abrir];
//        
//    }else{
//       
//        self.login.hidden =
//        self.btCadastrar.hidden = YES;
//        
//    }
    

    
    NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
    NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
    Tipoescolhido = @"";
    NSDictionary *dicEscolhido =@{@"pickerView": Tipoescolhido};
    [dicEscolhido writeToFile:PATH_PICKERVIEW atomically:YES];
    
    
    NSDictionary *dicionarioEspecialidade = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWESPECIALIDADES];
    NSString *TipoescolhidoEspecialidade = [dicionarioEspecialidade objectForKey:@"pickerViewEspecialidades"];
    TipoescolhidoEspecialidade = @"";
    NSDictionary *dicEscolhidoEspecialidade =@{@"pickerViewEspecialidades": Tipoescolhido};
    [dicEscolhidoEspecialidade writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];

    [self.view resignFirstResponder];

    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)cadastreUmLogin:(UIButton *)sender {
    
//    self.cadastreLoginBt.hidden = YES;
//    self.login.hidden =
//    self.btCadastrar.hidden = NO;
    
}
- (IBAction)cadastrar:(UIButton *)sender {
    
    
    [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/logins"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    for ( NSDictionary *dicionario in responseObject ) {

                                        self.loginWS = [dicionario objectForKey:@"login"];
                                        
                                        if ([self.loginWS isEqualToString:self.login.text]) {
                                            
                                            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                             message:@"Este login já existe, favor cadastrar outro"
                                                                                            delegate:self
                                                                                   cancelButtonTitle:nil
                                                                                   otherButtonTitles:@"Ok", nil];
                                            
                                            [alerta show];
                                            
                                        }else{
                                            
                                            NSDictionary *dicEscolhidoValorIni =@{@"pickerLogin": self.login.text};
                                            [dicEscolhidoValorIni writeToFile:PATH_LOGIN atomically:YES];
                                            
                                            [DejalBezelActivityView activityViewForView:self.view];
                                            
                                            self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                                                 target:self
                                                                                               selector:@selector(abrir)
                                                                                               userInfo:nil
                                                                                                repeats:NO];
                                            
                                        }
                                        

                                    }
                                }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    
                                }];
    
    
    
    
    

}

-(void)abrir{
        

    self.btGravarRole.hidden =
    self.labelGravarLocal.hidden =
    self.btBuscarRole.hidden =
    self.labelBuscarLocal.hidden = NO;
    
}

- (IBAction)btGravar:(UIButton *)sender {
    
    self.btGravarRole.enabled = NO;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        self.btGravarRole.enabled = YES;
        
    });
 
                                                      //NetworkStatus status = [conectividade currentReachabilityStatus];
                                                      
                                                      if ([self.conectado isEqualToString:@"Sem internet!"]) {
                                                          UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                                     message:@"Para salvar algum rolê é necessário estar conectado à internet!"
                                                                                                                    delegate:self
                                                                                                           cancelButtonTitle:@"Ok"
                                                                                                           otherButtonTitles:nil, nil];
                                                          
                                                          [alertaSemConexao show];
                                                          
                                                      }else if ([self.conectado isEqualToString:@"Com internet!"]){
                                                          
                                                          NSDictionary *vaiProLogin = [NSDictionary dictionaryWithContentsOfFile:PATH_NAOTEMLOGIN];
                                                          NSString *stringTemNaoTem = [vaiProLogin objectForKey:@"naoTemLogin"];
                                                          
                                                          if([stringTemNaoTem isEqualToString:@"1"]){
                                                              
                                                              UIAlertView *alertaNaoTemLogin = [[UIAlertView alloc] initWithTitle:@"!!Aviso!!"
                                                                                                                      message:@"Para cadastrar um rolê, favor cadastrar primeiro um login!"
                                                                                                                     delegate:self
                                                                                                            cancelButtonTitle:nil
                                                                                                            otherButtonTitles:@"Ok", nil];
                                                              [alertaNaoTemLogin show];
                                                              
                                                              self.telaLogin.hidden =
                                                              //self.campoTextoLogin.hidden =
                                                              //self.labelCadastrar.hidden =
                                                              //self.btCadastrar.hidden =
                                                              self.btCadastrarUmLogin.hidden =
                                                              self.labelCadastreUmLogin.hidden =
                                                              self.btCadastrarDepois.hidden =
                                                              self.labelCadastrarDepois.hidden =
                                                              self.tituloApp1.hidden =
                                                              self.tituloApp2.hidden = NO;
                                                              
                                                              
                                                          }
                                                          else{
                                                          self.lugaresEncontradosArray = [[NSMutableArray alloc]init];
                                                          
                                                          NSString *auxValor = [NSString stringWithFormat:@"0"];
                                                          NSDictionary *dicAux = @{@"pickerLocalIgual": auxValor};
                                                          [dicAux writeToFile:PATH_LOCALIGUAL atomically:YES];
                                                          
                                                          
                                                          locationManager = [[CLLocationManager alloc] init];
                                                          locationManager.distanceFilter = kCLDistanceFilterNone;
                                                          locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                                                          [locationManager startUpdatingLocation];
                                                          
                                                          [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                                                                   parameters:nil
                                                                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                          
                                                                                          for ( NSDictionary *dicionario in responseObject ) {
                                                                                              
                                                                                              FeMViewController *local = [FeMViewController new];
                                                                                              local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                                                                              local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                                                                              
                                                                                              NSString *stringLat = [NSString stringWithFormat:@"%.4f", locationManager.location.coordinate.latitude];
                                                                                              float latitude = [stringLat floatValue];
                                                                                              
                                                                                              NSString *stringLong = [NSString stringWithFormat:@"%.4f", locationManager.location.coordinate.longitude];
                                                                                              float longitude = [stringLong floatValue];
                                                                                              
                                                                                              NSLog(@"Latitude do server %.4f", local.latitude);
                                                                                              NSLog(@"Longitude do server %.4f", local.longitude);
                                                                                              NSLog(@"Latitude local %.4f", latitude);
                                                                                              NSLog(@"Longitude local %.4f", longitude);
                                                                                              
                                                                                              
                                                                                              if ((((local.latitude - 0.0050) < latitude) && ((local.latitude + 0.0050) > latitude) && ((local.longitude - 0.0050) < longitude) && ((local.longitude + 0.0050) > longitude)) || ((local.latitude == latitude) && (local.longitude == longitude))) {
                                                                                                  
                                                                                                  NSLog(@"Era pra gravar aqui");
                                                                                                  
                                                                                                  local.nome = [dicionario objectForKey:@"nome"];
                                                                                                  NSString *encontrou = local.nome;
                                                                                                  NSLog(@"é pra salvar esse %@", encontrou);
                                                                                                  
                                                                                                  [self.lugaresEncontradosArray addObject:encontrou];
                                                                                                  NSDictionary *dicLugares= @{@"lugaresEncontrados": self.lugaresEncontradosArray};
                                                                                                  [dicLugares writeToFile:PATH_LUGARESENCONTRADOS atomically:YES];
                                                                                                  
                                                                                                  
                                                                                                  
                                                                                                  NSString *auxValor = [NSString stringWithFormat:@"1"];
                                                                                                  NSDictionary *dicAux = @{@"pickerLocalIgual": auxValor};
                                                                                                  [dicAux writeToFile:PATH_LOCALIGUAL atomically:YES];
                                                                                                  
                                                                                                  
                                                                                              }
                                                                                              
                                                                                              
                                                                                          }
                                                                                          
                                                                                          NSDictionary *dicionarioEncontrados = [NSDictionary dictionaryWithContentsOfFile:PATH_LUGARESENCONTRADOS];
                                                                                          NSLog(@"Lugares salvos no plist %@", dicionarioEncontrados);
                                                                                          
                                                                                          
                                                                                          NSDictionary *dicionarioLocal = [NSDictionary dictionaryWithContentsOfFile:PATH_LOCALIGUAL];
                                                                                          NSString *auxLocal = [dicionarioLocal objectForKey:@"pickerLocalIgual"];
                                                                                          NSLog(@"Variavel auxiliar depois %@", auxLocal);
                                                                                          
                                                                                          
                                                                                          if ([auxLocal intValue] != 1) {
                                                                                              
                                                                                              [self performSegueWithIdentifier:@"telaSalvar" sender:self];
                                                                                              
                                                                                              
                                                                                          }else{
                                                                                              
                                                                                              
                                                                                              
                                                                                              [self performSegueWithIdentifier:@"telaTableView" sender:self];
                                                                                              
                                                                                          }
                                                                                          
                                                                                      }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                          
                                                                                          UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                                                                     message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                                                                    delegate:self
                                                                                                                                           cancelButtonTitle:@"Ok"
                                                                                                                                           otherButtonTitles:nil, nil];
                                                                                          
                                                                                          [alertaSemConexao show];
                                                                                          
                                                                                      }];
                                                          
                                                      }
                                                      
    
                                                      }
     
    
    

    
    
    

}

- (IBAction)btBuscar:(UIButton *)sender {
    
    if ([self.conectado isEqualToString:@"Sem internet!"]) {
        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                   message:@"Para buscar algum rolê é necessário estar conectado à internet!"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil, nil];
        
        [alertaSemConexao show];
        
    }else if ([self.conectado isEqualToString:@"Com internet!"]){
        
        [self performSegueWithIdentifier:@"telaBuscar" sender:self];
        
    }
    
    
}

- (IBAction)CadastrarDepois:(UIButton *)sender {
    
    self.telaLogin.hidden =
    self.campoTextoLogin.hidden =
    self.labelCadastrar.hidden =
    self.btCadastrar.hidden =
    self.btCadastrarUmLogin.hidden =
    self.labelCadastreUmLogin.hidden =
    self.btCadastrarDepois.hidden =
    self.labelCadastrarDepois.hidden =
    self.tituloApp1.hidden =
    self.tituloApp2.hidden = YES;
    
    self.btGravarRole.hidden =
    self.labelGravarLocal.hidden =
    self.btBuscarRole.hidden =
    self.labelBuscarLocal.hidden = NO;
    
    NSString *auxValor = [NSString stringWithFormat:@"1"];
    NSDictionary *dicAux = @{@"naoTemLogin": auxValor};
    [dicAux writeToFile:PATH_NAOTEMLOGIN atomically:YES];
}
@end






























