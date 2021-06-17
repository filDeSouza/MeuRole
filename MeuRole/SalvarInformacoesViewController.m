//
//  SalvarInformacoesViewController.m
//  MeuRole
//
//  Created by Filipe de Souza on 13/11/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import "SalvarInformacoesViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import <AFNetworking/AFNetworking.h>
#import <UITextField+AKNumericFormatter.h>
#import <AKNumericFormatter.h>
#import <NSString+AKNumericFormatter.h>
#import "DejalActivityView.h"
#import <Social/Social.h>
#import <sqlite3.h>
#import "Post.h"
#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_PICKERVIEW [DOCUMENTS stringByAppendingPathComponent:@"pickerView.plist"]
#define PATH_PICKERVIEWESPECIALIDADES [DOCUMENTS stringByAppendingPathComponent:@"pickerViewEspecialidades.plist"]
#define PATH_BTESCOLHIDO [DOCUMENTS stringByAppendingPathComponent:@"btEscolhido.plist"]
#define PATH_LOGIN [DOCUMENTS stringByAppendingPathComponent:@"pickerLogin.plist"]


#import "DejalActivityView.h"


@interface SalvarInformacoesViewController (){
    
    // Variavel do Banco
    sqlite3 *banco;
    
    // Variavel que definira os comandos SQL
    const char *comando;
    
}

@end

@implementation SalvarInformacoesViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIAlertView *primeiroAlert = [[UIAlertView alloc] initWithTitle:@"!!Aviso!!"
                                                       message:@"Você está no Rolê agora?"
                                                      delegate:self
                                             cancelButtonTitle:@"Não"
                                             otherButtonTitles:@"Sim", nil];
    [primeiroAlert show];
    primeiroAlert.tag = 4;
    
    self.navigationController.navigationBarHidden = NO;
    
    self.scrollView.delegate = self;
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 900)];
    
    // Salvando os dados da plist nos arrays
    self.bundle = [NSBundle mainBundle];
    self.pathArquivo = [self.bundle pathForResource:@"roles" ofType:@"plist"];
    self.dadosArquivo = [[NSDictionary alloc] initWithContentsOfFile:self.pathArquivo];
    self.tipoDoRole = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoDoRole"]];
    self.tipoRestaurante = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoRestaurante"]];
    self.tipoBarzinho = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoBarzinho"]];
    self.tipoBalada = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoBalada"]];
    self.tipoCasaShows = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoCasaShows"]];
    self.tipoCinema = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoCinema"]];
    self.tipoMuseu = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoMuseu"]];
    self.tipoTeatro = [[NSArray alloc] initWithArray:[self.dadosArquivo valueForKey:@"tipoTeatro"]];
    
    
    do{
        self.numeroRandom = arc4random() % 27;
    }while (self.numeroRandom ==0);
    
    NSString *nomeImagem = [NSString stringWithFormat:@"%i", self.numeroRandom];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem] ];
    
    
    [self.imageViewFundoSalvarRole setImageToBlur:[UIImage imageNamed:nomeImagem]
                               blurRadius:kLBBlurredImageDefaultBlurRadius
                          completionBlock:^{
                              NSLog(@"Funcionou");
                          }];
    
    // Mascara para moeda
    [self.currencyTextFieldValorInicial addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.currencyTextFieldValorFinal addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [[self.campoTextoLocal layer] setBorderWidth:1.0f];
    [[self.campoTextoLocal layer] setCornerRadius:2.0f];
    [[self.campoTextoLocal layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoTextoLocal.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    [self.campoTextoLocal setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    self.campoTextoLocal.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [[self.campoValorFinal layer] setBorderWidth:1.0f];
    [[self.campoValorFinal layer] setCornerRadius:2.0f];
    [[self.campoValorFinal layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoValorFinal.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    [self.campoValorFinal setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    self.campoValorFinal.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [[self.campoValorInicial layer] setBorderWidth:1.0f];
    [[self.campoValorInicial layer] setCornerRadius:2.0f];
    [[self.campoValorInicial layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoValorInicial.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    [self.campoValorInicial setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    self.campoValorInicial.keyboardAppearance = UIKeyboardAppearanceDark;

    self.labelEstacionamento.text = [NSString stringWithFormat:@"possui valet ou\n estacionamento próximo?"];
    [self.labelEstacionamento setFont:[UIFont fontWithName:@"Prototype" size:20.0]];
    self.labelEstacionamento.numberOfLines = 2;
    //self.labelEstacionamento.minimumFontSize = 8.0;
    //self.labelEstacionamento.adjustsFontSizeToFitWidth = YES;
    
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
    [label setText:@"salvar rolê"];
    [self.navigationItem setTitleView:label];
    
    self.nota = 0;
    
    [[self.labelTipoRole layer] setBorderWidth:1.0f];
    [[self.labelTipoRole layer] setCornerRadius:2.0f];
    [[self.labelTipoRole layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.labelTipoRole setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    NSString *tipo = [NSString stringWithFormat:@"tipo do rolê"];
    self.labelTipoRole.text = tipo;
    
    [[self.labelEspecialidadeRole layer] setBorderWidth:1.0f];
    [[self.labelEspecialidadeRole layer] setCornerRadius:2.0f];
    [[self.labelEspecialidadeRole layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.labelEspecialidadeRole setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    NSString *especialidade = [NSString stringWithFormat:@"especialidade"];
    self.labelEspecialidadeRole.text = especialidade;
    
    [self.labelValorGasto setFont:[UIFont fontWithName:@"Prototype" size:20.0]];
    NSString *valor = [NSString stringWithFormat:@"valor gasto"];
    self.labelValorGasto.text = valor;
    
    
    [[self.btGravarInformacoes layer] setBorderWidth:1.0f];
    [[self.btGravarInformacoes layer] setCornerRadius:2.0f];
    [[self.btGravarInformacoes layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.labelGravarInformcoes.text = [NSString stringWithFormat:@"gravar rolê"];
    [self.labelGravarInformcoes setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Prototype" size:17], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.segmentedEstacionamento setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSLog(@"Especialidade: %@", self.labelEspecialidadeRole.text);
    
    self.gerenciador = [CLLocationManager new];
    self.gerenciador.desiredAccuracy = kCLLocationAccuracyBest;
    self.gerenciador.delegate = self;

    
    
    // Ligar os Delegates
    self.campoTextoLocal.delegate = self;
    
    
    [self.scrollView resignFirstResponder];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.scrollView endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (BOOL)canBecomeFirstResponder{
    NSLog(@"Nao entendir");

    self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.campoValorInicial] || [textField isEqual:self.campoValorFinal]) {
        
        self.view.frame = CGRectMake(0.0, -90, self.view.frame.size.width, self.view.frame.size.height);
    }
    
}

- (void)textFieldEditingChanged:(id)sender
{
    
    
    if (sender == self.currencyTextFieldValorInicial) {
        
        self.valorInicial = [self.currencyTextFieldValorInicial.numberValue.description floatValue];
        
    }else if (sender == self.currencyTextFieldValorFinal) {
        
        self.valorFinal = [self.currencyTextFieldValorFinal.numberValue.description floatValue];
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.campoTextoLocal resignFirstResponder];
    [self.campoValorInicial resignFirstResponder];
    [self.campoValorFinal resignFirstResponder];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)campoNome:(UITextField *)sender {
    
    NSLog(@"Some porra");
    
    [self resignFirstResponder];
    
}


//-(BOOL)becomeFirstResponder{
//    
//    NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
//    NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
//    
//    
//    NSDictionary *dicionarioEspecialidade = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWESPECIALIDADES];
//    NSString *TipoescolhidoEspecialidade = [dicionarioEspecialidade objectForKey:@"pickerViewEspecialidades"];
//    
//    if ([Tipoescolhido length]==0) {
//        self.labelTipoRole.text = [NSString stringWithFormat:@"Tipo do Rolê"];
//        
//    }
//    else{
//        
//        self.labelTipoRole.text = Tipoescolhido;
//        
//    }
//    
//    if ([TipoescolhidoEspecialidade length]==0) {
//        self.labelEspecialidadeRole.text = [NSString stringWithFormat:@"Especialidade"];
//        
//    }
//    else{
//        
//        self.labelEspecialidadeRole.text = TipoescolhidoEspecialidade;
//        
//    }
//    
//    NSLog(@"Escolha %@", Tipoescolhido);
//    
//    
//    [self.view resignFirstResponder];
//    NSLog(@"Some porra");
//    
//    return YES;
//}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *localizacao = [locations lastObject];
    
    CLLocationCoordinate2D coordenadas = localizacao.coordinate;
    
    self.latitude = coordenadas.latitude;
    
    self.longitude = coordenadas.longitude;
    
    NSLog(@"Coordenadas: %.4f , %.4f", self.latitude, self.longitude);
    
    
    
}


- (IBAction)sanvarInformacoes:(UIButton *)sender {
    
    NSString *estacionamento = [NSString stringWithFormat:@"%li", (long)self.segmentedEstacionamento.selectedSegmentIndex];
    
    NSLog(@"estacionamento %@", estacionamento);
    
    if (self.campoTextoLocal.text.length == 0) {
        UIAlertView *preenche = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                           message:@"Favor preencher o campo Nome do estabelecimento"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        [preenche show];
    }
    
    else if ([self.labelTipoRole.text isEqualToString:@"Tipo do Role"]){
        
        UIAlertView *preenche = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                           message:@"Favor escolher o Tipo do Rolê"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        [preenche show];
        
    }
    
    else if ([self.labelEspecialidadeRole.text isEqualToString:@"Especialidade"]){
        
        UIAlertView *preenche = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                           message:@"Favor escolher a Especialidade do Rolê"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        [preenche show];
        
    }
    
    else if (self.campoValorInicial.text.length == 0){
        
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
    
    else if (self.valorFinal <  self.valorInicial){
        
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                         message:@"O campo valor final deve ser maior ou igual ao valor inicial!"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok", nil];
        
        [alerta show];
        
    }
    
    else{
        NSLog(@"%@", self.campoValorFinal.text);
        
        
        [self.gerenciador startUpdatingLocation];
        
        
        NSLog(@"Variavel auxiliar: %i", self.aux);
        
        
        UIAlertView *alertaAviso = [[UIAlertView new] initWithTitle:@"!! Aviso !!"
                                                            message:@"Esta opção gravará sua localização atual. Deseja continuar?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancelar"
                                                  otherButtonTitles:@"Confirmar", nil];
        alertaAviso.tag = 1;
        
        [alertaAviso show];
    }
    
}


-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
            
            
            //            "create table if not exists LOCAL (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, nome TEXT, tipo TEXT, especialidade TEXT, valorInicial FLOAT, valorFinal FLOAT, nota INTEGER, latitude FLOAT, longitude FLOAT)"
            
            
            NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            
            
            NSDictionary *dicionarioEspecialidade = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWESPECIALIDADES];
            NSString *TipoescolhidoEspecialidade = [dicionarioEspecialidade objectForKey:@"pickerViewEspecialidades"];
            
            NSString *nome = self.campoTextoLocal.text;
            self.nomeLocal = nome;
            NSString *valorInicialString = [NSString stringWithFormat:@"%.2f", self.valorInicial];
            NSString *valorFinalString = [NSString stringWithFormat:@"%.2f", self.valorFinal];
            int nota = self.nota;
            NSString *notaString = [NSString stringWithFormat:@"%i", nota];
            float latitude = self.latitude;
            NSString *latitudeString = [NSString stringWithFormat:@"%.4f", latitude];
            float longitude = self.longitude;
            NSString *longitudeString = [NSString stringWithFormat:@"%.4f", longitude];
            NSString *avaliacoes = [NSString stringWithFormat:@"1"];
            NSString *estacionamento = [NSString stringWithFormat:@"%li", (long)self.segmentedEstacionamento.selectedSegmentIndex];

            
            NSDictionary *dicionarioLogin = [NSDictionary dictionaryWithContentsOfFile:PATH_LOGIN];
            NSString *loginPicker = [dicionarioLogin objectForKey:@"pickerLogin"];
            
            NSDictionary *dados = @{@"nome": nome, @"tipo": Tipoescolhido, @"especialidade": TipoescolhidoEspecialidade, @"valorInicial": valorInicialString, @"valorFinal": valorFinalString, @"nota": notaString, @"latitude": latitudeString, @"longitude": longitudeString, @"avaliacoes": avaliacoes, @"login": loginPicker, @"estacionamento": estacionamento};
            
            
            [Post postRole:nome Tipoescolhido:Tipoescolhido TipoescolhidoEspecialidade:TipoescolhidoEspecialidade valorInicialString:valorInicialString valorFinalString:valorFinalString notaString:notaString latitudeString:latitudeString longitudeString:longitudeString avaliacoes:avaliacoes loginPicker:loginPicker estacionamento:estacionamento terminou:^(BOOL sucesso) {
                if (sucesso) {
                    
                    self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                         target:self
                                                                       selector:@selector(abrir)
                                                                       userInfo:nil
                                                                        repeats:NO];
                    
                    [DejalBezelActivityView activityViewForView:self.view];
                    
                }else{
                    UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                               message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"Ok"
                                                                     otherButtonTitles:nil, nil];
                    
                    alertaSemConexao.tag = 3;
                    
                    [alertaSemConexao show];
                }
            }];
            
            
//            [[AFHTTPSessionManager manager] POST:@"http://45.55.178.46:3000/produtos" parameters:dados success:^(NSURLSessionDataTask *task, id responseObject) {
//                
//                
//                self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
//                                                                     target:self
//                                                                   selector:@selector(abrir)
//                                                                   userInfo:nil
//                                                                    repeats:NO];
//                
//                [DejalBezelActivityView activityViewForView:self.view];
//                
//                
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                
//                UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
//                                                                           message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"Ok"
//                                                                 otherButtonTitles:nil, nil];
//                
//                alertaSemConexao.tag = 3;
//                
//                [alertaSemConexao show];
//                
//            }];
            
            
            
            
            
            NSLog(@"Latitude: %.4f", self.latitude);
            NSLog(@"Longitude: %.4f", self.longitude);

            
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
                
                NSString *postar = [NSString stringWithFormat:@"Não sabe o que vai fazer no seu fds? Baixe MeuRole e ache seu rolê! Eu estive hoje no %@!", self.nomeLocal];
                
                [controller setInitialText:postar];
                [controller addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/meurole/id989028181?l=pt&ls=1&mt=8"]];
                //[controller addImage:[UIImage imageNamed:@"imagem do role"]];
                
                [self presentViewController:controller animated:YES completion:nil];
                
            }
        }else if (buttonIndex == 0){
            
            
            
        }
        
    }else if (alertView.tag == 3){
        
        [self performSegueWithIdentifier:@"voltaTela" sender:self];
        
    }
    else if (alertView.tag == 4){
        
        if (buttonIndex == 0) {
            
            [self performSegueWithIdentifier:@"voltaTela" sender:self];
            
            UIAlertView *primeiroAlert = [[UIAlertView alloc] initWithTitle:@"!!Aviso!!"
                                                                    message:@"Obrigado, mas você deve estar no local para salvá-lo.\nNo próximo Rolê não esqueça de salvar."
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Ok", nil];
            [primeiroAlert show];
            
        }
        
        
    }


    
}

// Incluir a rede social aqui
-(void)abrir{
    
    
    [DejalBezelActivityView removeView];
    
    UIAlertView *alertaAviso = [[UIAlertView new] initWithTitle:nil
                                                        message:@"Dados salvos com sucesso. Agradecemos sua contribuição! \nDeseja compartilhar seu Rolê?"
                                                       delegate:self
                                              cancelButtonTitle:@"Agora não"
                                              otherButtonTitles:@"Facebook", @"Twitter", nil];
    

    
    alertaAviso.tag = 2;
    
    [alertaAviso show];
    
    [self performSegueWithIdentifier:@"voltaTela" sender:self];
    
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
//    [_currencyFormatter setCurrencyCode:@"R$"];
//    self.campoValorInicial.text = [_currencyFormatter valueForKeyPath:self.campoValorInicial.text];
//    return NO;
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    
    
}

- (IBAction)someTeclado:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    [self.view endEditing:YES];
    
    
}

- (IBAction)openPickerController:(UIButton *)sender {
    
    if (sender == self.btTipoRole) {
        self.pickerEscolhido = 1;
        
        RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
        pickerVC.delegate = self;
        pickerVC.titleLabel.text = @"Selecione o Tipo do Rolê";
        
        //pickerVC.blurEffectStyle = UIBlurEffectStyleExtraLight;
        pickerVC.tintColor = [UIColor blackColor];
        pickerVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.17];
        pickerVC.selectedBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        //    //You can enable or disable bouncing and motion effects
        //    pickerVC.disableBouncingWhenShowing = !self.bouncingSwitch.on;
        //    pickerVC.disableMotionEffects = !self.motionSwitch.on;
        //    pickerVC.disableBlurEffects = !self.blurSwitch.on;
        //
        //    //You can also adjust colors (enabling the following line will result in a black version of RMPickerViewController)
        //    if(self.blackSwitch.on)
        //        pickerVC.blurEffectStyle = UIBlurEffectStyleDark;
        
        //Enable the following lines if you want a black version of RMPickerViewController but also disabled blur effects (or run on iOS 7)
        //pickerVC.tintColor = [UIColor whiteColor];
        //pickerVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
        //pickerVC.selectedBackgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
        
        //The example project is universal. So we first need to check whether we run on an iPhone or an iPad.
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            //OK, running on an iPhone. The following lines demonstrate the two ways to show the picker view controller on iPhones:
            //(Note: These two methods also work an iPads.)
            
            // 1. Just show the picker view controller (make sure the delegate property is assigned)
            [pickerVC show];
            
            // 2. Instead of using a delegate you can also pass blocks when showing the picker view controller
            //[pickerVC showWithSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
            //    NSLog(@"Successfully selected rows: %@", selectedRows);
            //} andCancelHandler:^(RMPickerViewController *vc) {
            //    NSLog(@"Row selection was canceled (with block)");
            //}];
        } else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //OK, running on an iPad. The following lines demonstrate the two special ways of showing the picker view controller on iPads:
            
            // 1. Show the picker view controller from a particular view controller (make sure the delegate property is assigned).
            //    This method can be used to show the picker view controller within popovers.
            //    (Note: We do not use self as the view controller, as showing a picker view controller from a table view controller
            //           is not supported due to UIKit limitations.)
            //[pickerVC showFromViewController:self.navigationController];
            
            // 2. As with the two ways of showing the picker view controller on iPhones, we can also use a blocks based API.
            //[pickerVC showFromViewController:self.navigationController withSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
            //    NSLog(@"Successfully selected rows: %@", selectedRows);
            //} andCancelHandler:^(RMPickerViewController *vc) {
            //    NSLog(@"Row selection was canceled (with block)");
            //}];
            
            // 3. Show the date selection view controller using a UIPopoverController. The rect and the view are used to tell the
            //    UIPopoverController where to show up.
            //        [pickerVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.view];
            
            // 4. The date selectionview controller can also be shown within a popover while also using blocks based API.
            //[pickerVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.tableView withSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
            //    NSLog(@"Successfully selected rows: %@", selectedRows);
            //} andCancelHandler:^(RMPickerViewController *vc) {
            //    NSLog(@"Row selection was canceled (with block)");
            //}];
        }
        
    }else if (sender == self.btEspecialidadeRole){
        
        if ([self.labelTipoRole.text isEqual:@"Tipo do Rolê"]) {
            
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                             message:@"Favor escolher o Tipo do Rolê"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"Ok", nil];
            
            [alerta show];
            
            
        }else{
            self.pickerEscolhido = 2;
            
            RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
            pickerVC.delegate = self;
            pickerVC.titleLabel.text = @"Selecione a Especialidade do Rolê";
            
            //pickerVC.blurEffectStyle = UIBlurEffectStyleExtraLight;
            pickerVC.tintColor = [UIColor blackColor];
            pickerVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.17];
            pickerVC.selectedBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
            
            //    //You can enable or disable bouncing and motion effects
            //    pickerVC.disableBouncingWhenShowing = !self.bouncingSwitch.on;
            //    pickerVC.disableMotionEffects = !self.motionSwitch.on;
            //    pickerVC.disableBlurEffects = !self.blurSwitch.on;
            //
            //    //You can also adjust colors (enabling the following line will result in a black version of RMPickerViewController)
            //    if(self.blackSwitch.on)
            //        pickerVC.blurEffectStyle = UIBlurEffectStyleDark;
            
            //Enable the following lines if you want a black version of RMPickerViewController but also disabled blur effects (or run on iOS 7)
            //pickerVC.tintColor = [UIColor whiteColor];
            //pickerVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
            //pickerVC.selectedBackgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
            
            //The example project is universal. So we first need to check whether we run on an iPhone or an iPad.
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                //OK, running on an iPhone. The following lines demonstrate the two ways to show the picker view controller on iPhones:
                //(Note: These two methods also work an iPads.)
                
                // 1. Just show the picker view controller (make sure the delegate property is assigned)
                [pickerVC show];
                
                // 2. Instead of using a delegate you can also pass blocks when showing the picker view controller
                //[pickerVC showWithSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
                //    NSLog(@"Successfully selected rows: %@", selectedRows);
                //} andCancelHandler:^(RMPickerViewController *vc) {
                //    NSLog(@"Row selection was canceled (with block)");
                //}];
            } else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                //OK, running on an iPad. The following lines demonstrate the two special ways of showing the picker view controller on iPads:
                
                // 1. Show the picker view controller from a particular view controller (make sure the delegate property is assigned).
                //    This method can be used to show the picker view controller within popovers.
                //    (Note: We do not use self as the view controller, as showing a picker view controller from a table view controller
                //           is not supported due to UIKit limitations.)
                //[pickerVC showFromViewController:self.navigationController];
                
                // 2. As with the two ways of showing the picker view controller on iPhones, we can also use a blocks based API.
                //[pickerVC showFromViewController:self.navigationController withSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
                //    NSLog(@"Successfully selected rows: %@", selectedRows);
                //} andCancelHandler:^(RMPickerViewController *vc) {
                //    NSLog(@"Row selection was canceled (with block)");
                //}];
                
                // 3. Show the date selection view controller using a UIPopoverController. The rect and the view are used to tell the
                //    UIPopoverController where to show up.
                //        [pickerVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.view];
                
                // 4. The date selectionview controller can also be shown within a popover while also using blocks based API.
                //[pickerVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.tableView withSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
                //    NSLog(@"Successfully selected rows: %@", selectedRows);
                //} andCancelHandler:^(RMPickerViewController *vc) {
                //    NSLog(@"Row selection was canceled (with block)");
                //}];
            }
            
        }
        
    }
    
    
}

#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    NSLog(@"Successfully selected rows: %@", selectedRows);
    
    self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
    self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
    
    if (self.pickerEscolhido == 1) {

        self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
        self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
    
        NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
        
        NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
        
        Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
        
        NSDictionary *dicEscolhido =@{@"pickerView": Tipoescolhido};
        
        [dicEscolhido writeToFile:PATH_PICKERVIEW atomically:YES];
        
        NSLog(@"Escolhido: %@", selectedRows);
        
        self.labelTipoRole.text = [NSString stringWithFormat:@"%@", [self.tipo objectAtIndex:self.selectedEscolhido]];
    
    }else if (self.pickerEscolhido == 2){
        
        self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
        self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
        
        NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
        NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
        
        NSDictionary *dicionarioEspecialidade = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWESPECIALIDADES];
        NSString *TipoescolhidoEspecialidade = [dicionarioEspecialidade objectForKey:@"pickerViewEspecialidades"];
        
        if ([Tipoescolhido isEqualToString:@"Balada"]) {
            
            TipoescolhidoEspecialidade = [self.tipoBalada objectAtIndex:self.selectedEscolhido];
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
            
        }
        else if ([Tipoescolhido isEqualToString:@"Barzinho"]){
            
            TipoescolhidoEspecialidade = [self.tipoBarzinho objectAtIndex:self.selectedEscolhido];
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Casa de Shows"]){
            
            TipoescolhidoEspecialidade = [self.tipoCasaShows objectAtIndex:self.selectedEscolhido];
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Cinema"]){
            
            TipoescolhidoEspecialidade = [self.tipoCinema objectAtIndex:self.selectedEscolhido];
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Museu"]){
            
            TipoescolhidoEspecialidade = [self.tipoMuseu objectAtIndex:self.selectedEscolhido];
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Restaurante"]){
            
            TipoescolhidoEspecialidade = [self.tipoRestaurante objectAtIndex:self.selectedEscolhido];
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Teatro"]){
            
            TipoescolhidoEspecialidade = [self.tipoTeatro objectAtIndex:self.selectedEscolhido];
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": TipoescolhidoEspecialidade};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        self.labelEspecialidadeRole.text = [NSString stringWithFormat:@"%@", [self.tipo objectAtIndex:self.selectedEscolhido]];
        
    }
    
    
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    NSLog(@"Selection was canceled");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.pickerEscolhido == 1) {
        self.tipo = self.tipoDoRole;
    }else if (self.pickerEscolhido == 2){
        
        self.tipoEscolhidoRole = 0;
        
        NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
        
        NSString *tipoRoleEscolhido = [dicionario objectForKey:@"pickerView"];
        
        if ([tipoRoleEscolhido isEqualToString:@"Balada"]) {
            
            self.tipo = self.tipoBalada;
            
        }
        else if ([tipoRoleEscolhido isEqualToString:@"Barzinho"]){
            
            self.tipo = self.tipoBarzinho;
            
        }
        else if ([tipoRoleEscolhido isEqualToString:@"Casa de Shows"]){
            
            self.tipo = self.tipoCasaShows;
            
        }
        else if ([tipoRoleEscolhido isEqualToString:@"Cinema"]){
            
            self.tipo = self.tipoCinema;
            
        }
        else if ([tipoRoleEscolhido isEqualToString:@"Museu"]){
            
            self.tipo = self.tipoMuseu;
            
        }
        else if ([tipoRoleEscolhido isEqualToString:@"Restaurante"]){
            
            self.tipo = self.tipoRestaurante;
            
        }
        else if ([tipoRoleEscolhido isEqualToString:@"Teatro"]){
            
            self.tipo = self.tipoTeatro;
            
        }
        
    }
    
    return self.tipo.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //return [NSString stringWithFormat:@"Row %lu", (long)row];
    
    if (self.pickerEscolhido == 1) {
        self.tipo = self.tipoDoRole;
    }else if (self.pickerEscolhido == 2){
        
        NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
        
        NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
        
        if ([Tipoescolhido isEqualToString:@"Balada"]) {
            
            self.tipo = self.tipoBalada;
            
        }
        else if ([Tipoescolhido isEqualToString:@"Barzinho"]){
            
            self.tipo = self.tipoBarzinho;
            
        }
        else if ([Tipoescolhido isEqualToString:@"Casa de Shows"]){
            
            self.tipo = self.tipoCasaShows;
            
        }
        else if ([Tipoescolhido isEqualToString:@"Cinema"]){
            
            self.tipo = self.tipoCinema;
            
        }
        else if ([Tipoescolhido isEqualToString:@"Museu"]){
            
            self.tipo = self.tipoMuseu;
            
        }
        else if ([Tipoescolhido isEqualToString:@"Restaurante"]){
            
            self.tipo = self.tipoRestaurante;
            
        }
        else if ([Tipoescolhido isEqualToString:@"Teatro"]){
            
            self.tipo = self.tipoTeatro;
            
        }
        
    }
    
    return [self.tipo objectAtIndex:row];
    
}


- (IBAction)tapou:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    
}
@end




























