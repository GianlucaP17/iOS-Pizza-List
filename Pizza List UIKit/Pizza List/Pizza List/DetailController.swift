//
//  DetailController.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright (c) Gianluca Posca. All rights reserved.
//

import UIKit

/// questo file / classe pilota il controller che mostra la scheda della pizza
class DetailController: UIViewController {

    // MARK: - Outlet
    @IBOutlet var labelIngredienti: UILabel!
    @IBOutlet var labelCalorie: UILabel!
    @IBOutlet var imagePizza: UIImageView!
    
    // MARK: - Variabili
    
    /// grazie a questa var potremo passare qui la pizza da mostrare a video
    /// il paggaggio avviene nel metodo prepareForSegue che trovi nel file ListController.swift
    var pizza : PizzaModel?
	
    // MARK: - Metodi standard del controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		/// sistemiamo i font e i colori nella barra
		navigationController?.navigationBar.titleTextAttributes =
			[NSAttributedString.Key.foregroundColor : UIColor.white,
			 NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 20)!]
		
		navigationItem.rightBarButtonItem?.setTitleTextAttributes(
			[NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular",size: 16)!],
			for: UIControl.State.normal)
		
		navigationItem.leftBarButtonItem?.setTitleTextAttributes(
			[NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular",size: 16)!],
			for: UIControl.State.normal)
		
		/// riempiamo la var detailController contenuta in DataManager
		/// grazie a questo trucco potremo raggiugere questo controller da qualsiasi punto dell'App
		DataManager.shared.detailController = self

        /// arrotondiamo la label delle calorie
        labelCalorie.layer.cornerRadius = 40
        labelCalorie.layer.borderWidth = 2
        labelCalorie.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor

		/// controlliamo che la pizza sia veramente arrivata
		guard let pizzaOk = pizza else { return }
		
		/// passiamo la pizza al metodo che mette i dati a video
		mostraDatiDellaPizza(pizzaOk)
    }
    
	func mostraDatiDellaPizza(_ pizz:PizzaModel) {
		/// mostriamo i dati
		
		/// leggiamo le var contenute nell'istanza di pizza che abbiamo ricevuto dal ListController
		/// mettiamo a video il titolo
		title = pizz.nome
		
		/// mettiamo a video gli ingredienti
		labelIngredienti.text = pizz.ingredienti
		
		/// mettiamo a video le calorie e sistemiamo il colore nel caso il fondo sia nero
		labelCalorie.text = pizz.calorie
		labelCalorie.backgroundColor = pizz.coloreCalorie
		if pizz.coloreCalorie == UIColor.black {
            labelCalorie.textColor = UIColor.white
        } else if pizz.coloreCalorie == UIColor.yellow {
            labelCalorie.textColor = UIColor.black
        }
		
		/// mettiamo a video l'immagine
		imagePizza.image = pizz.immaginePronta
        
        guard let immaOK = pizz.immaginePronta else { return }
        
		/// giriamo l'immagine se per caso è Landscape (a noi serve portrait)
		if immaOK.size.width > immaOK.size.height {
			imagePizza.image = UIImage(cgImage: immaOK.cgImage!,
			                           scale: 1.0,
			                           orientation: .right)
		}
	}
    
    // MARK: - Azioni
    
    /// azione collegata al pulsante in basso a destra
    @IBAction func condividi(_ sender: UIButton) {
		
		/// controlliamo che la pizza sia veramente arrivata
		guard let pizzaOk = pizza else { return }
		
        /// tutto questo blocco si richiama con sw_avc
        /// creiamo un array di cose da condividere
		let oggetti = [pizzaOk.immaginePronta!, title!, pizzaOk.ingredienti] as [Any]
        
        /// creiamo un'istanza di UIActivityViewController
        let act = UIActivityViewController(activityItems: oggetti,
                                           applicationActivities: nil)
        
        self.present(act, animated: true, completion: nil)

    }

    /// azione collegata al pulsante in basso a sinistra
    @IBAction func mangiata(_ sender: UIButton) {
		/// controlliamo che la pizza sia veramente arrivata
		guard let pizzaOk = pizza else { return }
		
        /// trasformiamo le calorie in un Double (perchè così vanno passate ad HeathKit)
        guard let calorie = Double(pizzaOk.calorie) else { return }
        print("\(calorie)")
        /// invochiamo la libreria e gli diciamo di aggungere la pizza e le sue calorie
        HealthManager.shared.aggiungiCalorie(nome: pizzaOk.nome, calorie: calorie * 1000) {
			
            DispatchQueue.main.async {
                let myAlert = UIAlertController(title: loc("HBTITILE"),
                                                message: loc("HBMSG"),
                                                preferredStyle: .alert)
                
                myAlert.addAction(UIAlertAction(title: "OK",
                                                style: .cancel))
                
                self.present(myAlert, animated: true)
            }
        }
    }
    
    // MARK: - Navigazione
    /// questo scatta quando l'utente tocca il button modifica
    /// per fare il segue nello storyboard è stato tirato il filo dal button modifica al corpo del NavigationController che sta davanti all'AddController, quindi lui va aperto e si porta appresso AddController che è quello che ci interessa
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// controlliamo che il nome del segue corrisponda alla parola modifica
        if segue.identifier == "modifica" {
            
            /// estraiamo dal segue l'AddController passando per il navigation (a cui è collegato il segue) che gli sta davanti
            let controller = (segue.destination as! UINavigationController).topViewController as! AddController
            controller.pizzaDaModificare = pizza
        }
    }
	
	///*** MODIFICA TODAY ***\\
	/// metodo chiamato dall'AppDelegate quando invocato dal Widget
	func aggiornaInterfacciaConIndex(_ index:Int?) {
		
		/// usiamo una guardia per verificare che l'index sia valido
		/// ed anche che l'Array abbia almeno una pizza
		guard let indexOk = index, DataManager.shared.storage.count > 0 else { return }
		
		let pizzaWidget = DataManager.shared.storage[indexOk]
		mostraDatiDellaPizza(pizzaWidget)
	}

}

