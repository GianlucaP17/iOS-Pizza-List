//
//  EditorController.swift
//  PizzaList
//
//  Created by Gianluca Posca
//  Copyright (c) Gianluca Posca. All rights reserved.
//

import UIKit

/// implementiamo il delegato dei textField (per chiudere le tastiere)
class AddController: UITableViewController, UITextFieldDelegate {

    // MARK: - Outlet
    @IBOutlet var fieldNome: UITextField!
    @IBOutlet var fieldIngredienti: UITextField!
    @IBOutlet var fieldCalorie: UITextField!
    @IBOutlet var immaginePizza: UIImageView!
    
    // MARK: - Variabili globali
    /// questa serve per capire se bisogna creare una nuova pizza oppure modificarne una esistente
    /// il passaggio avviene se l'utente ha toccato button modifica nel dettaglio
    var pizzaDaModificare : PizzaModel?
    
    // MARK: - Metodi standard del controller
    override func viewDidLoad() {
        super.viewDidLoad()

		/// grafica del controller
		navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.backgroundColor = UIColor.red
        
		navigationController?.navigationBar.tintColor = UIColor.white
				
		/// font e colore font nella barra
		navigationController?.navigationBar.titleTextAttributes =
			[NSAttributedString.Key.foregroundColor : UIColor.white,
			 NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 20)!]
		
		navigationItem.rightBarButtonItem?.setTitleTextAttributes(
			[NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular",size: 16)!],
			for: UIControl.State.normal)
		
		navigationItem.leftBarButtonItem?.setTitleTextAttributes(
			[NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular",size: 16)!],
			for: UIControl.State.normal)
		
		/// mettiamo a video il titolo localizzato
		title = loc("ADD_CONT_TITLE")
        
        /// delegati e testi segnaposto
        fieldNome.delegate = self
        fieldNome.placeholder = loc("ADD_CONT_PLACEHOLDER_PIZZA_NAME")
        
        fieldIngredienti.delegate = self
        fieldIngredienti.placeholder = loc("ADD_CONT_PLACEHOLDER_PIZZA_INGR")
        
        fieldCalorie.delegate = self
        fieldCalorie.placeholder = loc("ADD_CONT_PLACEHOLDER_PIZZA_CAL")

        /// barra per chiusura tastiera numerica
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
													  width: self.view.bounds.size.width,
													  height: 44))
        keyboardToolbar.barStyle = UIBarStyle.black
        keyboardToolbar.isTranslucent = true
        keyboardToolbar.backgroundColor = UIColor.red
        keyboardToolbar.tintColor = UIColor.white
		
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let save = UIBarButtonItem(title: loc("ADD_CONT_DONEBUTTON"),
								   style: .done,
								   target: fieldCalorie,
								   action: #selector(resignFirstResponder))
        keyboardToolbar.setItems([flex, save], animated: false)
        fieldCalorie.inputAccessoryView = keyboardToolbar
        
        /// se abbiamo passato una pizza vuol dire che vogliamo modificare una pizza
        /// quindi riempiamo tutti i field con i dati presi dalla pizza qui passata
        /// facciamo il solito test dell'optional
        if let pizza = pizzaDaModificare {
            /// mettiamo i dati della pizza a video
            fieldNome.text = pizza.nome
            fieldIngredienti.text = pizza.ingredienti
            fieldCalorie.text = pizza.calorie
            immaginePizza.image = pizza.immaginePronta
            
             guard let immaOK = pizza.immaginePronta else { return }
            
            /// giriamo l'immagine se per caso è Landscape (a noi serve portrait)
            if immaOK.size.width > immaOK.size.height {
				immaginePizza.image = UIImage(cgImage: immaOK.cgImage!, scale: 1.0, orientation: UIImage.Orientation.right)
            } else {
                immaginePizza.image = pizza.immaginePronta
            }
        }
    }

    // MARK: - Azioni
    /// collegato al button cancel nello storyboard
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        /// chiude la modal (ovvero questo controller che è stato aperto così)
        dismiss(animated: true, completion: nil)
    }

    /// collegato al button save nello storyboard
    @IBAction func save(_ sender: UIBarButtonItem) {
		
		/// controlliamo che le var texxt dei vari field siano valide
		if let nome = fieldNome.text,
			let ingr = fieldIngredienti.text,
			let cal = fieldCalorie.text,
			let immaPizza = immaginePizza.image,
			nome.isEmpty == false,
			ingr.isEmpty == false,
			cal.isEmpty == false {
			
			/// se entra qui è tutto ok
			
			/// se l'utente ha toccato il button modifica nel dettaglio
			/// abbiamo passato una pizza a questo controller
			/// quindi modifichiamo la pizza qui passata, invece di crearne una nuova
			
			/// per capire se è stata passata o no...
			/// facciamo il solito test dell'optional
			if let pizza = pizzaDaModificare {
				
				/// modifichiamo i dati, leggendli dai textField e dall'immagine a video
				pizza.nome = nome
				pizza.ingredienti = ingr
				pizza.calorie = cal
				pizza.immagine = immaginePizza.image?.pngData()
				
				/// salviamo le modifiche
				DataManager.shared.salva()
				
				/// ricarichiamo la table nel ListController
				///# MODIFICA TODAY
				(DataManager.shared.listCont as? ListController)?.tableView.reloadData()
				
				/// modifichiamo i dati nel DetailController
				/// se siamo qui vuol dire che questo controller è stato aperto toccando il button modifica
				/// quindi le modifiche fatte si devono riflettere nel dettaglio
				///# MODIFICA TODAY
				/// bisogna dirgli che la var detailController è DetailController
				(DataManager.shared.detailController as? DetailController)?.mostraDatiDellaPizza(pizza)
				
				/// chiudiamo
				dismiss(animated: true, completion: nil)
				
			} else {
				/// NESSUNA pizza è stata passata
				/// allora l'utente ha toccato il + nel ListController
				
				/// quindi creiamo una nuova pizza
				/// ovvero facciamo una nuova istanza di PizzaModel..
				/// e inseriamo il contenuto dei field e dell'image
				
				/// per farlo invochiamo l'apposito metodo di DataManager
				DataManager.shared.nuovaPizza(nome: nome,
											  ingredienti: ingr,
											  calorie: cal,
											  immagine: immaPizza)
				
				///# MODIFICA TODAY
				/// per via dei Target adesso DataManager NON vede la classe ListController....
				/// se non viene anche lei compilata con il target del Today (che non ha senso)
				/// quindi per superare il problena lo facciamo da qui
				(DataManager.shared.listCont as? ListController)?.tableView.reloadData()
				
				/// chiudiamo
				dismiss(animated: true, completion: nil)
			}

		} else {
			/// entra qui allora uno dei campi è stato lasciato in bianco...
			
			/// facciamo un'Alert per avvertire l'utente che tutti i campi sono obbligatori
			let simpleAlert = UIAlertController(title: loc("ADD_CONT_ALERT_TITLE"),
												message: loc("ADD_CONT_ALERT_MSG"),
												preferredStyle: .alert)
			
			simpleAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			
			present(simpleAlert, animated: true, completion: nil)
		}
    }

    /// collegato alla gesture applicata all'immagine nello storyboard
    /// quindi scatta quando viene toccata l'immagine
    @IBAction func selezionaImmagine(_ sender: UITapGestureRecognizer) {
        
        /// nel caso la tastiera sia fuori la chiudiamo
        fieldNome.resignFirstResponder()
        fieldIngredienti.resignFirstResponder()
        fieldCalorie.resignFirstResponder()
        
        /// creiamo la ActionSheet ed installiamo i button
        let myActionSheet = UIAlertController(title: loc("ACTION_IMAGE_TITLE"),
                                              message: loc("ACTION_IMAGE_TEXT"),
                                              preferredStyle: .actionSheet)
		
		let bLib = UIAlertAction(title: loc("BUTTON_LIBRARY"), style: .default) { (action) in
			
			/// codice eseguito quando viene premuto questo button
			/// invochiamo cameramanager e gli diciamo che vogliamo una foto dalla libreria
			CameraManager.shared.newImageLibrary(controller: self, sourceIfPad: nil, editing: false) { image in
				/// mettiamo l'immagine che arriva a video
				self.immaginePizza.image = image
			}
		}
		
        myActionSheet.addAction(bLib)
		
		let bNew = UIAlertAction(title: loc("BUTTON_SHOOT"), style: .destructive) { action in
			/// creiamo un overlay da mettere sopra alla fotocamera
			let circle = UIImageView(frame: UIScreen.main.bounds)
			circle.image = UIImage(named: "overlay")
			
			/// invochiamo cameramanager e gli diciamo che vogliamo scattare una foto
			CameraManager.shared.newImageShoot(controller: self, sourceIfPad: nil,
			                                   editing: false, overlay: circle) { (image) in
				/// mettiamo l'immagine che arriva a video
				self.immaginePizza.image = image
			}
		}
		
        myActionSheet.addAction(bNew)
        
        /// inseriamo il button Annulla
        myActionSheet.addAction( UIAlertAction(title: loc("BUTTON_CANCEL"), style: .cancel, handler: nil) )
        
        /// presentiamo l'ActionSheet
        present(myActionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Deleagti
    /// metodo del delgato dei textfield che scatta quando viene toccato invio sulla tastiera
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /// chiudiamo la tastiera di qualunque texfield invochi questo metodo
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Metodi della TableView
    /// chiede quanto devono essere grandi le celle
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /// il solito switch
        switch indexPath.row {
            /// facciamo la cella numero 3 alta 405 per mostrare l'immagine della pizza
            case 3: return 405
            default: return 44
        }
    }
    
}
