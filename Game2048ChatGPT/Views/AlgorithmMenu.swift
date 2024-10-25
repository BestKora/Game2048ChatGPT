//
//  AlgorithmMenu.swift
//  My2048New
//
//  Created by Tatiana Kornilova on 18.05.2023.
//

import SwiftUI

struct AlgorithmMenu: View {
    @Binding var algorithm: Algorithm
    
    var body: some View {
        Menu {
            Picker("Algorithm", selection: $algorithm) {
                ForEach(Algorithm.allCases, id:\.self){
                    Text ($0.rawValue)
                        .tag($0.rawValue)
                }
            }
        } label: {
            HStack {
                Text(algorithm.rawValue)
                Image(systemName: "chevron.down")
            }
        }
    }
}

#Preview {
    AlgorithmMenu(algorithm:.constant(Algorithm.Expectimax))
}
