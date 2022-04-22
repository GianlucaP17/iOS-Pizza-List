//
//  MainList.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI

struct MainList : View {
    
    @ObservedObject var dataManager: DataManager = DataManager.shared
    
    @State var isAddPresented = false
    @State var isInfoPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(dataManager.storage) { pizza in
                        NavigationLink(destination: Detail(pizza: pizza)) {
                            PizzaRow(pizza: pizza)
                        }
                    }
                .onDelete(perform: cancella)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }
            
                Divider()
            
                /// Fake Toolbar
                HStack {
                    /// info
                    infoButton.offset(x: 0, y: -5)
                    /// space
                    Spacer()
                    /// Add
                    addButton.offset(x: 0, y: -5)
                }
                .frame(height: 44)
            }
        .accentColor(Color.red)
        .onAppear {
            /// #💡 Attenzione: ricordarsi di far partire HealthManager
            if HealthManager.shared.healthStore == nil { HealthManager.shared.setupHealthStore() }
        }
        .navigationBarTitle(Text("Pizza List"), displayMode: .inline)
        }
    }
    
    var addButton : some View {
        Button(action: { self.isAddPresented = true }) {
            Image(systemName: "plus.circle.fill")
                .font(Font.system(size: 28))
                .padding(.horizontal, 16)
        }.sheet(isPresented: $isAddPresented) {
            Add(dismissFlag: self.$isAddPresented)
                .modifier(DisableModalDismiss(disabled: true))
        }
    }
    
    var infoButton : some View {
        /// Info
        Button(action: { self.isInfoPresented = true }) {
            Image(systemName: "info.circle.fill")
                .font(Font.system(size: 28))
                .padding(.horizontal, 16)
        }.sheet(isPresented: $isInfoPresented) {
            Info(dismissFlag: self.$isInfoPresented)
        }
    }
    
    // MARK: - Azioni
    
    func cancella(at offset: IndexSet) {
        guard let intindex = Array(offset).first else { return }
        dataManager.cancellaPizza(index: intindex)
    }
    
}

struct MainList_Previews : PreviewProvider {
    static var previews: some View {
        
        return NavigationView {
                MainList().navigationBarTitle(Text("Pizza List"), displayMode: .inline)
                 //.colorScheme(.dark)
        }
    }
}
