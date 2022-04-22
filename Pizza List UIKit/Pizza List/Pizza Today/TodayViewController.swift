//
//  TodayViewController.swift
//  Pizza Today
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import UIKit
import NotificationCenter
/// nello storyboard del widget ho messo un CollectionViewController
/// quindi questa classe deve essere figlia sua per poterlo pilotare
/// NCWidgetProviding serve per avere i protocolli del widget

class TodayViewController: UICollectionViewController, NCWidgetProviding {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		/// facciamo partire il gestore dei dati
		DataManager.shared.caricaDati()
		
		/// impostiamo la misura del widget
		self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 140)
		
		self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
		
	}
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		if activeDisplayMode == .expanded {
			self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 140)
		} else if activeDisplayMode == .compact {
			self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		/// impostiamo la misura del widget, va fatto per forza dopo che tutto è stato caricato
		self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 140)
	}

	/// dice quanto deve essere il margine del nostro widget dai bordi
	func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
		/// visto che abbiamo una collection view usiamo le sue funzioni per distanziare le celle
		/// quindi restituiamo zero margine
		return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
	}
	
	// MARK: UICollectionViewDataSource
	
	/// come per la table questo metodo vuole sapere quante sezioni deve fare
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	/// come per la table questo metodo vuole sapere quante celle deve fare
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		/// stessa storia delle table, gli passiamo il totale delle istanze di PizzaModel che sono nell'array
		return DataManager.shared.storage.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PizzaCollectionCell
		
		/// come per la tableView ci facciamo dare un'istanza di PizzaModel
		/// che è contenuta nell'array scatola che sta dentro a DataManager
		/// il tutto in base al numero della cella, ovvero indexPath.row
		let pizza = DataManager.shared.storage[indexPath.row]
		
		/// adesso possiamo mettere i dati a video
		cell.nome.text = pizza.nome
		cell.immagine.image = pizza.immaginePronta
		
		/// arrotondiamo l'immagine della pizza
		cell.immagine.layer.cornerRadius = 48
		
		/// creiam un bordo e lo coloriamo
		cell.immagine.layer.borderWidth = 2
		cell.immagine.layer.borderColor = UIColor.white.cgColor
		
		return cell
	}
	
	// MARK: UICollectionViewDelegate
	
	/// questo metodo scatta quando viene toccata una cella della CollectionView
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		/// per fare in modo che il widget possa aprire la sua App bisogna andare alla radice del progetto, tab Info
		/// ed impostare un "URL Types", guarda questo esempio per capire, in un campo ho scritto pizzalist, tutto li
		/// quindi adesso quest'App può essere invocata con openUrl e lo schema pizzalist://
		
		/// l'url deve essere per forza fatto così pizzalist://?q= , la parte ?q= è importante se no la creazione dell'url fallise
		guard let url = URL(string: "pizzalist://?q=\(indexPath.row)") else { return }
		
		/// diciamo all'esxtension di aprire un url, e gli passiamo quello della nostra App
		extensionContext?.open(url, completionHandler: nil)
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		/// Perform any setup necessary in order to update the view.
		
		/// If an error is encountered, use NCUpdateResult.Failed
		/// If there's no update required, use NCUpdateResult.NoData
		/// If there's an update, use NCUpdateResult.NewData
		
		completionHandler(NCUpdateResult.newData)
	}
	
}
