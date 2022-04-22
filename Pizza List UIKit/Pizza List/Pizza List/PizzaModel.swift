//
//  PizzaModel.swift
//  Static TableView
//
//  Created by Gianluca Posca
//  Copyright (c) Gianluca Posca. All rights reserved.
//

import UIKit

class PizzaModel: Codable {
   
    /// creiamo le var che conterranno i dati delle pizze
    var nome : String
    var ingredienti : String
	var calorie : String
    var immagine : Data?
	
    var immaginePronta : UIImage? {
        return UIImage(data: immagine ?? Data()) /// trick coalescing operator (??)
    }
    
	/// variabile a cui "tarocchiamo" il GET
	/// ogni volta che leggiamo questa var viene calcolato il colore corretto in base alle calorie
	var coloreCalorie : UIColor {
		/// trasformiamo la var calorie (che è una String) in un Int
		/// facciamo l'if let per controllare se ce la fa
		/// se l'utente inserisce un carattere diverso da uno numerico la trasformazione fallisce
		if let calorieTest = Int(calorie) {
			
			/// ora vediamo il valore di calorie con l'elegantissimo switch di Swift
			switch calorieTest {
			case 0...400: return UIColor.white
				case 401...800: return UIColor.yellow
				case 801...1200: return UIColor.orange
				case 1201...1800: return UIColor.red
				case 1801...2000: return UIColor.purple
				/// se nessun caso si verifica vuol dire che l'utente ha inserito più di 2000 calorie
				/// allora scatta il default, e restituiamo il colore nero
				default: return UIColor.black
			}
		}
		return .blue
	}
    
    /// creiamo un init che ci dia una mano a caricare le istanze ed i dati su una sola riga
    init(nome:String, ingredienti:String, calorie:String, immagine:Data?) {
        self.nome = nome
        self.ingredienti = ingredienti
		self.calorie = calorie
        self.immagine = immagine
    }
    
}
