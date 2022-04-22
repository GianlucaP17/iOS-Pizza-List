//
//  PizzaRoww.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI

struct PizzaRow: View {
    
    @ObservedObject var pizza: PizzaModel
    
    let brown = Color(red: 158/255, green: 78/255, blue: 0.0)
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Rectangle().frame(width: 106).foregroundColor(.clear)
                    Spacer()
                    Text(pizza.nome)
                        .font(.body)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.5)
                        .frame(height: 30)
                        .offset(x: 0, y: 0)
                        
                    Circle().shadow(radius: 2)
                        .foregroundColor(pizza.coloreCalorie)
                        .frame(width: 26, height: 26)
                        .overlay(
                            Circle()
                                .stroke(brown, lineWidth: 2)
                                .padding(.all, 1.0)
                        )
                        .offset(x: 0, y: 0)
                }
                HStack {
                    Rectangle().frame(width: 106).foregroundColor(.clear)
                    Spacer()
                    Text(pizza.ingredienti)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .italic()
                        .offset(x: -4, y: 0)
                        .lineLimit(0)
                }
            }
            Pala().foregroundColor(brown)
            HStack {
                Image(uiImage: pizza.realImg)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 76, height: 90)
                    .clipShape(Circle())
                    .offset(x: 16, y: 0)
                Spacer()
            }
        }
        .frame(height: 94.0)
    }
}

struct PizzaRow_Previews: PreviewProvider {
    static var previews: some View {
        PizzaRow(pizza: PizzaModel(nome: "Nome", ingredienti: "Pomodoro, Mozzarella, Prosciutto Cotto, Funghi Porcini", calorie: "849", immagine: #imageLiteral(resourceName: "margherita").pngData()))
        .previewLayout(.sizeThatFits)
    }
}
