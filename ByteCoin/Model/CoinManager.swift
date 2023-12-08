//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

protocol CoinManagerDelegate{
    func getCoinRate(_ type: CoinManager, coin: CoinModel)
    
    func didFailWithError(_ type: CoinManager, error: Error)
}

import Foundation

struct CoinManager {
    var delegate: ViewController?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "DD742BA8-2B56-4B61-9173-31927B5C66B1"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        performData(with: urlString)
    }
    
    func performData(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){data, response, error in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let coin  = parseJSON(safeData){
                        delegate?.getCoinRate(self, coin:coin)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let coinDate = decodedData.rate
            let exchangeCoin = decodedData.asset_id_quote
            let coinModel = CoinModel(rate: coinDate, asset_id_quote: exchangeCoin)
            return coinModel
        }catch{
            delegate?.didFailWithError(self, error: error)
            return nil
        }
        
    }
    
}
