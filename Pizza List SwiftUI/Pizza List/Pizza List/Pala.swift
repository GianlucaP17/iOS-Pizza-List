//
//  Pala.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI

struct Pala: View {
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 83.5,
                           height: 83.5)
                    .offset(x: -4, y: 0)
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 60,
                           height: 83.5)
                    .offset(x: -20, y: 0)
            }
            .padding(.trailing, 0)
            .padding(.leading, 20)
            
            RoundedRectangle(cornerRadius: 6)
                .padding(.leading, -18)
                .frame(height: 12.0)
        }.shadow(radius: 3)
    }
}

struct Pala_Previews: PreviewProvider {
    static var previews: some View {
        Pala().foregroundColor(.red)
            .previewLayout(.sizeThatFits)
    }
}
