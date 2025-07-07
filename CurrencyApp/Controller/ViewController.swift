//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Dungeon_master on 05/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var todayCurrencyRate: UILabel!
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}
    
    extension ViewController : CoinManagerDelegate {
        
        func didUpdatePrice(price: String, currency currencyCode: String) {
            DispatchQueue.main.async {
                self.currencyLabel.text = price
                self.currencyCodeLabel.text = currencyCode
                self.todayCurrencyRate.text = "\(String(describing: self.currencyLabel.text?.lowercased() ?? "0")) \(String(describing: self.currencyCodeLabel.value(forKey: "text") ?? "0" )) as of the present day"
            }
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }
    }
    
    extension ViewController : UIPickerViewDataSource,UIPickerViewDelegate {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return coinManager.currencyArray.count
        }
        
        func pickerView(_ pickerView: UIPickerView,
        titleForRow row: Int, forComponent component: Int) -> String? {
            return coinManager.currencyArray[row]
        }
        
        func pickerView(_ pickerView: UIPickerView,
        didSelectRow row: Int, inComponent component: Int) {
            let selectedCurrency = coinManager.currencyArray[row]
            coinManager.getCoinPrice(for: selectedCurrency)
        }
        
    }
                                    

