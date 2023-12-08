//
//  CoinData.swift
//  ByteCoin
//
//  Created by Pranav S V on 27/07/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable{
    let rate: Double
    let asset_id_quote: String
}
