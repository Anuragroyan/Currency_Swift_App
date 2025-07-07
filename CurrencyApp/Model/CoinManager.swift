//
//  CoinManager.swift
//  CurrencyApp
//
//  Created by Dungeon_master on 05/06/25.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://v6.exchangerate-api.com/v6"
    let apiKey = "0359a3dbc34e8c49cfb827d2"

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(apiKey)/latest/\(currency)"
        print(urlString)
        
        if let url = URL(string: urlString) {

                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    // --- IMPORTANT: Add this for debugging network responses ---
                    if let httpResponse = response as? HTTPURLResponse {
                        print("HTTP Status Code: \(httpResponse.statusCode)")
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Raw API Response: \(responseString)")
                        }
                    }
                    // -----------------------------------------------------------

                    if let safeData = data {
                        if let bitcoinPrice = self.parseJSON(safeData) {
                            let priceString = String(format: "%.2f", bitcoinPrice)
                            self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                        }
                    }
                }
                task.resume()
            }
        }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)

            // Assuming you want the rate of the selected base currency against USD
            // You can pick any target currency here, e.g., "GBP", "JPY", etc.
            let targetCurrency = "INR" // Or any other currency you want to display the rate against

            if let rateToTargetCurrency = decodedData.conversion_rates[targetCurrency] {
                print("Conversion rates: \(decodedData.conversion_rates)")
                return rateToTargetCurrency
            } else {
                print("Error: Target currency '\(targetCurrency)' not found in conversion rates.")
                delegate?.didFailWithError(error: NSError(domain: "ConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Target currency not found in conversion rates."]))
                return nil
            }

        } catch {
            print("Decoding error: \(error)") // Crucial for seeing the exact decoding issue
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
