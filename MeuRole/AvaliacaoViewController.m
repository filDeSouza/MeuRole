//
//  AvaliacaoViewController.m
//  MeuRole
//
//  Created by Filipe de Souza on 12/02/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//
#import "UIImageView+LBBlurredImage.h"
#import "AvaliacaoViewController.h"
#import "DejalActivityView.h"
#import "Post.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AFNetworking/AFNetworking.h>

#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_LOGIN [DOCUMENTS stringByAppendingPathComponent:@"pickerLogin.plist"]


@interface AvaliacaoViewController ()

@end

@implementation AvaliacaoViewController{
    
    CLLocationManager *locationManager;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    do{
        self.numeroRandom = arc4random() % 27;
    }while (self.numeroRandom ==0);
    
    NSString *nomeImagem = [NSString stringWithFormat:@"%i", self.numeroRandom];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem] ];
    
    [self.imageViewTelaAvaliacao setImageToBlur:[UIImage imageNamed:nomeImagem]
                                  blurRadius:kLBBlurredImageDefaultBlurRadius
                             completionBlock:^{
                                 NSLog(@"Funcionou");
                             }];
    
    self.labelLocal.text = [NSString stringWithFormat:@"%@", self.textoRecebido ];
    [self.labelLocal setFont:[UIFont fontWithName:@"Prototype" size:40.0]];
    self.labelLocal.numberOfLines = 2;
    self.labelLocal.minimumFontSize = 8.0;
    self.labelLocal.adjustsFontSizeToFitWidth = YES;
    
    
    // Mascara para moeda
    [self.currencyTextFieldValorInicial addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.currencyTextFieldValorFinal addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [[self.campoValorFinal layer] setBorderWidth:2.0f];
    [[self.campoValorFinal layer] setCornerRadius:10.0f];
    [[self.campoValorFinal layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoValorFinal.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    [self.campoValorFinal setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    self.campoValorFinal.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [[self.campoValorInicial layer] setBorderWidth:2.0f];
    [[self.campoValorInicial layer] setCornerRadius:10.0f];
    [[self.campoValorInicial layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoValorInicial.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    [self.campoValorInicial setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    self.campoValorInicial.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [[self.btGravar layer] setBorderWidth:2.0f];
    [[self.btGravar layer] setCornerRadius:10.0f];
    [[self.btGravar layer] setBorderColor:[UIColor whiteColor].CGColor];
    //self.btGravar.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.000];
    
    self.labelEstacionamento.text = [NSString stringWithFormat:@"Possui valet ou\n estacionamento próximo?"];
    [self.labelEstacionamento setFont:[UIFont fontWithName:@"Prototype" size:20.0]];
    self.labelEstacionamento.numberOfLines = 2;
    
    [self.labelGravarAvaliacao setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    
    [self.labelValorGasto setFont:[UIFont fontWithName:@"Prototype" size:20.0]];

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [backButton setTintColor:[UIColor whiteColor]];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 10.0;
    [label setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"Avaliar Rolê"];
    [self.navigationItem setTitleView:label];
    
    self.nota = 0;
    
    self.gerenciador = [CLLocationManager new];
    self.gerenciador.desiredAccuracy = kCLLocationAccuracyBest;
    self.gerenciador.delegate = self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Prototype" size:17], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.segmentedEstacionamento setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    

    
    [self.view resignFirstResponder];

    
}

- (void)textFieldEditingChanged:(id)sender
{
    
    
    if (sender == self.currencyTextFieldValorInicial) {
        
        self.valorInicialCampoTexto = [self.currencyTextFieldValorInicial.numberValue.description floatValue];
        
    }else if (sender == self.currencyTextFieldValorFinal) {
        
        self.valorFinalCampoTexto = [self.currencyTextFieldValorFinal.numberValue.description floatValue];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (IBAction)estrelasQualidade:(UIButton *)sender {
    
    
    if ([sender isEqual:self.estrela1]) {
        self.imgEstrela1.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela2.image = nil;
        self.imgEstrela3.image = nil;
        self.imgEstrela4.image = nil;
        self.imgEstrela5.image = nil;
        
        self.nota = 1;
        
    }
    
    if ([sender isEqual:self.estrela2]) {
        self.imgEstrela1.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela2.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela3.image = nil;
        self.imgEstrela4.image = nil;
        self.imgEstrela5.image = nil;
        
        self.nota = 2;
        
        
    }
    
    if ([sender isEqual:self.estrela3]) {
        self.imgEstrela1.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela2.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela3.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela4.image = nil;
        self.imgEstrela5.image = nil;
        
        self.nota = 3;
        
        
    }
    
    if ([sender isEqual:self.estrela4]) {
        self.imgEstrela1.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela2.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela3.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela4.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela5.image = nil;
        
        self.nota = 4;
        
        
    }
    
    if ([sender isEqual:self.estrela5]) {
        self.imgEstrela1.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela2.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela3.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela4.image = [UIImage imageNamed:@"Selecionada"];
        self.imgEstrela5.image = [UIImage imageNamed:@"Selecionada"];
        
        self.nota = 5;
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *localizacao = [locations lastObject];
    
    CLLocationCoordinate2D coordenadas = localizacao.coordinate;
    
    self.latitude = coordenadas.latitude;
    
    self.longitude = coordenadas.longitude;
    
    NSLog(@"Coordenadas: %.4f , %.4f", self.latitude, self.longitude);
    
    
    
}

- (IBAction)salvarAvaliacao:(UIButton *)sender {
    
    if (self.campoValorInicial.text.length == 0){
        
        UIAlertView *preenche = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                           message:@"Favor prencher o campo Valor Inicial"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        [preenche show];
        
    }
    
    else if (self.campoValorFinal.text.length == 0){
        
        UIAlertView *preenche = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                           message:@"Favor prencher o campo Valor Final"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        [preenche show];
        
    }
    
    else if (self.nota == 0){
        
        UIAlertView *preenche = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                           message:@"Favor escolher a nota para o local"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        [preenche show];
        
    }
    
    else if (self.valorFinalCampoTexto <  self.valorInicialCampoTexto){
        
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                         message:@"O campo valor final deve ser maior ou igual ao valor inicial!"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok", nil];
        
        [alerta show];
        
    }
    else{
    UIAlertView *alertaAviso = [[UIAlertView new] initWithTitle:@"!! Aviso !!"
                                                        message:@"Esta opção gravará sua avaliação para o local escolhido. Deseja continuar?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancelar"
                                              otherButtonTitles:@"Confirmar", nil];
    alertaAviso.tag = 1;
    
    [alertaAviso show];
    
    }
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 1) {
        
        if (buttonIndex == 0) {
            
//            UIAlertView *alertaNao = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Mesmo assim lhe agradecemos. Continue registrando seus rolês!!!"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil, nil];
//            
//            [alertaNao show];
//            
//            [self performSegueWithIdentifier:@"voltaProInicioTelaBonita" sender:self];
            
        }else if (buttonIndex == 1){
            
            
            locationManager = [[CLLocationManager alloc] init];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            [locationManager startUpdatingLocation];
            
            
            
            [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                     parameters:nil
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            
                                            for ( NSDictionary *dicionario in responseObject ) {
                                                
                                                AvaliacaoViewController *local = [AvaliacaoViewController new];
                                                local.identWebService = [dicionario objectForKey:@"_id"];
                                                
                                                NSString *nome = [dicionario objectForKey:@"nome"];
                                                NSString *Tipoescolhido = [dicionario objectForKey:@"tipo"];
                                                NSString *TipoescolhidoEspecialidade = [dicionario objectForKey:@"especialidade"];
                                                NSString *latitudeString = [dicionario objectForKey:@"latitude"];
                                                NSString *longitudeString = [dicionario objectForKey:@"longitude"];
                                                NSDictionary *dicionarioLogin = [NSDictionary dictionaryWithContentsOfFile:PATH_LOGIN];
                                                NSString *loginPicker = [dicionarioLogin objectForKey:@"pickerLogin"];
                                                
                                                self.nomeLocal = nome;
                                                
                                                self.valorInicial = [[dicionario objectForKey:@"valorInicial"] floatValue];
                                                self.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue];
                                                self.notaWebService = [[dicionario objectForKey:@"nota"] intValue];
                                                self.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                                
                                                self.nomeLocal = [dicionario objectForKey:@"nome"];
                                                
                                                NSLog(@"ID local %@ \n ID do WS: %@", local.identWebService, self.ident);
                                                
                                                
                                                if ([local.identWebService isEqualToString: self.ident ]) {
                                                    
                                                    NSString *vaiValorInicial = self.campoValorInicial.text;
                                                    NSString *vaiValorFinal = self.campoValorFinal.text;

                                                    
                                                    self.valorInicial = self.valorInicial + self.valorInicialCampoTexto;
                                                    self.valorFinal = self.valorFinal + self.valorFinalCampoTexto;
                                                    self.notaWebService = self.notaWebService + self.nota;
                                                    self.numeroAvaliacoes = self.numeroAvaliacoes + 1;
                                                    
                                                    NSString *valorInicialString = [NSString stringWithFormat:@"%.2f", self.valorInicial];
                                                    NSString *valorFinalString = [NSString stringWithFormat:@"%.2f", self.valorFinal];
                                                    NSString *notaString = [NSString stringWithFormat:@"%i", self.notaWebService];
                                                    NSString *avaliacoesString = [NSString stringWithFormat:@"%i", self.numeroAvaliacoes];
                                                    NSString *estacionamento = [NSString stringWithFormat:@"%li", (long)self.segmentedEstacionamento.selectedSegmentIndex];

                                                    NSLog(@"Valor Ini: %@    Valor Fini:  %@", vaiValorInicial, vaiValorFinal);
                                                    
                                                    NSDictionary *dados = @{@"nome": nome, @"tipo": Tipoescolhido, @"especialidade": TipoescolhidoEspecialidade, @"valorInicial": valorInicialString, @"valorFinal": valorFinalString, @"nota": notaString, @"latitude": latitudeString, @"longitude": longitudeString, @"avaliacoes": avaliacoesString, @"login": loginPicker, @"estacionamento": estacionamento};

                                                    
                                                    [[AFHTTPSessionManager manager] PUT:[NSString stringWithFormat:@"http://45.55.178.46:3000/produtos/%@", self.ident]
                                                                             parameters:dados
                                                                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                    
                                                                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                    
                                                                                    // precisa mexer aqui
                                                                                    
                                                                                }];
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                            }
                                            self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                                                 target:self
                                                                                               selector:@selector(abrir)
                                                                                               userInfo:nil
                                                                                                repeats:NO];
                                            
                                            [DejalBezelActivityView activityViewForView:self.view];
                                            
                                        }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            
                                            
                                            UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                       message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                      delegate:self
                                                                                             cancelButtonTitle:@"Ok"
                                                                                             otherButtonTitles:nil, nil];
                                            
                                            alertaSemConexao.tag = 3;
                                            
                                            [alertaSemConexao show];
                                            
                                            
                                        }];
            

            
        }
        
    }else if (alertView.tag == 2){
        
        if (buttonIndex == 1) {
            
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                
                UIAlertView *alertaAviso = [[UIAlertView new] initWithTitle:nil
                                                                    message:@"Descreva detalhes do seu rolê e clique em Publicar."
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Ok", nil];
                
                [alertaAviso show];
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                NSLog(@"aparece face");
                
                NSString *postar = [NSString stringWithFormat:@"Não sabe o que vai fazer no seu fds? Baixe MeuRole e ache seu rolê! Eu estive hoje no %@! \nhttps://itunes.apple.com/us/app/meurole/id989028181?l=pt&ls=1&mt=8", self.nomeLocal];
                
                //[controller setInitialText:postar];
                [controller addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/meurole/id989028181?l=pt&ls=1&mt=8"]];
                //[controller addImage:[UIImage imageNamed:@"imagem do role"]];
                
                
                [self presentViewController:controller animated:YES completion:nil];

                
            }
            
        }else if (buttonIndex == 2){
            
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                NSString *postar = [NSString stringWithFormat:@"Não sabe o que vai fazer no seu fds? Baixe MeuRolê e ache seu rolê! Eu estive hoje no %@!", self.nomeLocal];
                
                [controller setInitialText:postar];
                [controller addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/meurole/id989028181?l=pt&ls=1&mt=8"]];
                //[controller addImage:[UIImage imageNamed:@"imagem do role"]];
                
                [self presentViewController:controller animated:YES completion:nil];
                
            }
            
        }else if (buttonIndex == 0){
            
            
            
        }
        
    }
    else if (alertView.tag == 3){
        
        [self performSegueWithIdentifier:@"voltaProInicioTelaBonita" sender:self];
        
    }
    
}

-(void)abrir{
    
    [DejalBezelActivityView removeView];
    
    UIAlertView *alertaAviso = [[UIAlertView new] initWithTitle:nil
                                                        message:@"Dados salvos com sucesso. Agradecemos sua contribuição! \nDeseja compartilhar seu Rolê?"
                                                       delegate:self
                                              cancelButtonTitle:@"Agora não"
                                              otherButtonTitles:@"Facebook", @"Twitter", nil];
    
    
    
    alertaAviso.tag = 2;
    
    [alertaAviso show];
    
    [self performSegueWithIdentifier:@"voltaProInicioTelaBonita" sender:self];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
