//
//  CoinData.swift
//  CurrencyApp
//
//  Created by Dungeon_master on 05/06/25.
//

import Foundation

struct CoinData: Decodable {
    let conversion_rates: [String: Double]
}
