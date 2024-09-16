//
//  CryptoCurrency.swift
//  CryptoCrazySUI
//
//  Created by Nurgül Ergünöz on 5.05.2024.
//

import Foundation
struct CryptoCurrency: Hashable, Decodable, Identifiable {
    let id = UUID()
    let currency: String
    let price: String
    
    private enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case price = "price"
    }
}
