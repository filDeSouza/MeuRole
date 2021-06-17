//
//  BuscarInformacoesViewController.m
//  MeuRole
//
//  Created by Filipe de Souza on 20/11/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import "BuscarInformacoesViewController.h"
#import "telaMapa.h"
#import <AFNetworking/AFNetworking.h>
#import "DejalActivityView.h"
#import "UIImageView+LBBlurredImage.h"

#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_PICKERVIEW [DOCUMENTS stringByAppendingPathComponent:@"pickerView.plist"]
#define PATH_PICKERVIEWESPECIALIDADES [DOCUMENTS stringByAppendingPathComponent:@"pickerViewEspecialidades.plist"]
#define PATH_PICKERVIEWVALORINI [DOCUMENTS stringByAppendingPathComponent:@"pickerViewValorIni.plist"]
#define PATH_PICKERVIEWVALORFINI [DOCUMENTS stringByAppendingPathComponent:@"pickerViewValorFini.plist"]
#define PATH_PICKERVIEWNOTA [DOCUMENTS stringByAppendingPathComponent:@"pickerViewNota.plist"]


@interface BuscarInformacoesViewController ()

@end

@implementation BuscarInformacoesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    do{
        self.numeroRandom = arc4random() % 27;
    }while (self.numeroRandom ==0);
    
    NSString *nomeImagem = [NSString stringWithFormat:@"%i", self.numeroRandom];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem] ];
    
    [self.imageViewTelaBuscar setImageToBlur:[UIImage imageNamed:nomeImagem]
                               blurRadius:kLBBlurredImageDefaultBlurRadius
                          completionBlock:^{
                              NSLog(@"Funcionou");
                          }];
    
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
    
    //formatacao de campo de valor
    [self.currencyTextFieldValorInicial addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.currencyTextFieldValorFinal addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.campoValorInicial.keyboardAppearance = UIKeyboardAppearanceDark;
    self.campoValorFinal.keyboardAppearance = UIKeyboardAppearanceDark;
    
    
    self.labelFundoGasto.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4f];
    self.labelFundoNotas.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4f];
    
    [[self.btTipoRole layer] setBorderWidth:1.0f];
    [[self.btTipoRole layer] setCornerRadius:2.0f];
    [[self.btTipoRole layer] setBorderColor:[UIColor whiteColor].CGColor];
//    [[self.btTipoRole layer] setBackgroundColor:[UIColor grayColor].CGColor];
    [[self.btTipoRole layer] setOpacity:0.4f];

    [[self.btEspecialidadeRole layer] setBorderWidth:1.0f];
    [[self.btEspecialidadeRole layer] setCornerRadius:2.0f];
    [[self.btEspecialidadeRole layer] setBorderColor:[UIColor whiteColor].CGColor];
//    [[self.btEspecialidadeRole layer] setBackgroundColor:[UIColor grayColor].CGColor];
    [[self.btEspecialidadeRole layer] setOpacity:0.4f];
    
    [[self.campoValorInicial layer] setBorderWidth:1.0f];
    [[self.campoValorInicial layer] setCornerRadius:2.0f];
    [[self.campoValorInicial layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoValorInicial.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.400];
    [self.campoValorInicial setFont:[UIFont fontWithName:@"Prototype" size:20.0]];
    
    
    
    [[self.campoValorFinal layer] setBorderWidth:1.0f];
    [[self.campoValorFinal layer] setCornerRadius:2.0f];
    [[self.campoValorFinal layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.campoValorFinal.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.400];
    [self.campoValorFinal setFont:[UIFont fontWithName:@"Prototype" size:20.0]];
    
    [[self.buscarRole layer] setBorderWidth:1.0f];
    [[self.buscarRole layer] setCornerRadius:2.0f];
    [[self.buscarRole layer] setBorderColor:[UIColor whiteColor].CGColor];
//    [[self.buscarRole layer] setBackgroundColor:[UIColor grayColor].CGColor];
    [[self.buscarRole layer] setOpacity:0.4f];
    self.labelBuscar.text = [NSString stringWithFormat:@"Buscar Rolê"];
    [self.labelBuscar setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    
    [[self.btLimpaTUTO layer] setBorderWidth:1.0f];
    [[self.btLimpaTUTO layer] setCornerRadius:2.0f];
    [[self.btLimpaTUTO layer] setBorderColor:[UIColor whiteColor].CGColor];
//    [[self.btLimpaTUTO layer] setBackgroundColor:[UIColor grayColor].CGColor];
    [[self.btLimpaTUTO layer] setOpacity:0.4f];
    self.labelLimpaTuto.text = [NSString stringWithFormat:@"Limpar"];
    [self.labelLimpaTuto setFont:[UIFont fontWithName:@"Prototype" size:18.0]];
    
    [self.labelPretencaodeGastos setFont:[UIFont fontWithName:@"Prototype" size:20.0]];

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
    [label setText:@"Buscar Rolê"];
    [self.navigationItem setTitleView:label];
    
    self.nota = 0;
    
    self.labelTipoRole.text = [NSString stringWithFormat:@"Tipo do Rolê"];
    [self.labelTipoRole setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

    self.labelEspecialidadeRole.text = [NSString stringWithFormat:@"Especialidade"];
    [self.labelEspecialidadeRole setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

    
    self.gerenciador = [CLLocationManager new];
    self.gerenciador.desiredAccuracy = kCLLocationAccuracyBest;
    self.gerenciador.delegate = self;
    
    [self.gerenciador requestWhenInUseAuthorization];
    
    self.campoValorInicial.clearsOnBeginEditing =
    self.campoValorFinal.clearsOnBeginEditing = YES;
    
    
    // Habilitar o clearsOnBeginEditing
    self.campoValorInicial.clearsOnBeginEditing =
    self.campoValorFinal.clearsOnBeginEditing = YES;
    
    [self.view resignFirstResponder];

}

- (void)textFieldEditingChanged:(id)sender
{
    
    
    if (sender == self.currencyTextFieldValorInicial) {
        
        self.valorInicial = [self.currencyTextFieldValorInicial.numberValue.description floatValue];
 
    }
    
    if (sender == self.currencyTextFieldValorFinal) {
        
        self.valorFinal = [self.currencyTextFieldValorFinal.numberValue.description floatValue];

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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)estrelasQualidade:(UIButton *)sender{
    
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
        
        self.labelEspecialidadeRole.text = @"Especialidade";
        [self.labelEspecialidadeRole setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

        
        if ([Tipoescolhido isEqualToString:@"Todos"]) {
            self.btEspecialidadeRole.enabled =
            self.campoValorInicial.enabled =
            self.campoValorFinal.enabled =
            self.estrela1.enabled =
            self.estrela2.enabled =
            self.estrela3.enabled =
            self.estrela4.enabled =
            self.estrela5.enabled = NO;
            
            self.labelEspecialidadeRole.text = @"Especialidade";
            self.campoValorInicial.text =
            self.campoValorFinal.text = nil;
            self.imgEstrela1.image =
            self.imgEstrela2.image =
            self.imgEstrela3.image =
            self.imgEstrela4.image =
            self.imgEstrela5.image = nil;
            
            self.nota = 0;


        }else{
            
            self.btEspecialidadeRole.enabled =
            self.campoValorInicial.enabled =
            self.campoValorFinal.enabled =
            self.estrela1.enabled =
            self.estrela2.enabled =
            self.estrela3.enabled =
            self.estrela4.enabled =
            self.estrela5.enabled = YES;
            
        }
        
        NSLog(@"Escolhido: %@", selectedRows);
        
        self.labelTipoRole.text = [NSString stringWithFormat:@"%@", [self.tipo objectAtIndex:self.selectedEscolhido]];
        
    }else if (self.pickerEscolhido == 2){
        
        NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
        NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
        
        NSDictionary *dicionarioEspecialidade = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWESPECIALIDADES];
        NSString *TipoescolhidoEspecialidade = [dicionarioEspecialidade objectForKey:@"pickerViewEspecialidades"];
        
        if ([Tipoescolhido isEqualToString:@"Balada"]) {
            
            self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
            self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
            
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
            
        }
        else if ([Tipoescolhido isEqualToString:@"Barzinho"]){
            
            self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
            self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
            
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Casa de Shows"]){
            
            self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
            self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
            
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Cinema"]){
            
            self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
            self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
            
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Museu"]){
            
            self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
            self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
            
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Restaurante"]){
            
            self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
            self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
            
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
            [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        }
        else if ([Tipoescolhido isEqualToString:@"Teatro"]){
            
            self.selectedRowTextoEscolhido = [NSString stringWithFormat:@"%@", selectedRows.firstObject];
            self.selectedEscolhido = [self.selectedRowTextoEscolhido intValue];
            NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
            Tipoescolhido = [self.tipo objectAtIndex:self.selectedEscolhido];
            
            NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
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
        
        if ([tipoRoleEscolhido isEqualToString:@"Todos"]) {
            
            self.tipo = nil;
            
        }
        else if ([tipoRoleEscolhido isEqualToString:@"Balada"]) {
            
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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *localizacao = [locations lastObject];
    
    CLLocationCoordinate2D coordenadas = localizacao.coordinate;
    
    self.latitude = coordenadas.latitude;
    
    self.longitude = coordenadas.longitude;
    
    NSLog(@"Coordenadas: %.4f  , %.4f  ", self.latitude, self.longitude);
    
}


- (IBAction)buscarInformacoes:(UIButton *)sender {
    
    
    if ([self.labelTipoRole.text isEqualToString:@"Tipo do Rolê"]){
        
        NSString *Tipoescolhido = [NSString stringWithFormat:@"Tipo do Rolê"];
        NSDictionary *dicEscolhido =@{@"pickerView": Tipoescolhido};
        [dicEscolhido writeToFile:PATH_PICKERVIEW atomically:YES];
        
        
    }
    if ([self.labelEspecialidadeRole.text isEqualToString:@"Especialidade"]){
        
        NSString *Tipoescolhido = [NSString stringWithFormat:@"Especialidade"];
        
        NSDictionary *dicEscolhido =@{@"pickerViewEspecialidades": Tipoescolhido};
        [dicEscolhido writeToFile:PATH_PICKERVIEWESPECIALIDADES atomically:YES];
        
    }

    
    
    if ([self.labelTipoRole.text isEqualToString:@"Tipo do Rolê"] && [self.labelEspecialidadeRole.text isEqualToString:@"Especialidade"] && self.campoValorInicial.text.length == 0 && self.campoValorFinal.text.length == 0 && self.nota == 0) {
        UIAlertView *preenche = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                           message:@"Para a busca, ao menos um dos campos deve ser preenchido"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"Ok", nil];
        
        [preenche show];
    }else if (self.campoValorInicial.text.length > 0 && self.campoValorFinal.text.length == 0){
        
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                         message:@"Favor digitar o valor final"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok", nil];
        
        [alerta show];
        
    }else if (self.valorFinal <  self.valorInicial){
        
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                         message:@"O campo valor final deve ser maior ou igual ao valor inicial!"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok", nil];
        
        [alerta show];
        
    }
    else{
        
        [DejalBezelActivityView activityViewForView:self.view];
        
        [self.gerenciador startUpdatingLocation];
        
        self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                             target:self
                                                           selector:@selector(abrir)
                                                           userInfo:nil
                                                            repeats:NO];
    }
    
    
    
    
}


-(void)abrir{

    NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
    
    NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];
    
    NSLog(@"Era para aparecer aqui %@", Tipoescolhido);
    
    telaMapa *valores = [telaMapa new];
    
    NSString *nota = [NSString stringWithFormat:@"%i", self.nota];
    NSDictionary *dicEscolhido =@{@"pickerViewNota": nota};
    [dicEscolhido writeToFile:PATH_PICKERVIEWNOTA atomically:YES];
    
    
    NSDictionary *dicEscolhidoValorIni =@{@"pickerViewValorIni": [NSString stringWithFormat:@"%.2f", self.valorInicial ]};
    [dicEscolhidoValorIni writeToFile:PATH_PICKERVIEWVALORINI atomically:YES];
    
    NSDictionary *dicEscolhidoValorFini =@{@"pickerViewValorFini": [NSString stringWithFormat:@"%.2f", self.valorFinal ]};
    [dicEscolhidoValorFini writeToFile:PATH_PICKERVIEWVALORFINI atomically:YES];
    
    valores.latitude = self.latitude;
    valores.latitude = self.longitude;
    
    [self performSegueWithIdentifier:@"vaiTela" sender:self];
    
    NSLog(@"Essas eram TELA ATUAL   %.4f   ,    %.4f", self.latitude, self.longitude);
    
    
    NSLog(@"Essas eram TELA MAPA   %.4f   ,    %.4f", valores.latitude, valores.longitude);
    
    [DejalBezelActivityView removeView];

    NSLog(@"So os numeros porra %.2f ", [self.campoValorInicial.text floatValue]);
}


- (IBAction)btLimpaTuto:(UIButton *)sender {
    
    self.labelTipoRole.text = [NSString stringWithFormat:@"Tipo do Rolê"];
    [self.labelTipoRole setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    
    self.labelEspecialidadeRole.text = [NSString stringWithFormat:@"Especialidade"];
    [self.labelEspecialidadeRole setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    
    self.campoValorInicial.text =
    self.campoValorFinal.text = nil;
    self.imgEstrela1.image =
    self.imgEstrela2.image =
    self.imgEstrela3.image =
    self.imgEstrela4.image =
    self.imgEstrela5.image = nil;
    
    self.nota = 0;
    
}

@end













