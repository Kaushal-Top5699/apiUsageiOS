//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Kaushal Topinkatti B on 16/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lableUSD: UILabel!
    @IBOutlet weak var lableCAD: UILabel!
    @IBOutlet weak var lableEUR: UILabel!
    @IBOutlet weak var lableINR: UILabel!
    @IBOutlet weak var lableTRY: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnGetUpdates(_ sender: Any) {
        
        //1) Firt we create a request and open a session, meaning going to the URL
        //2) Then we get response from the URL and we also get the data
        //3) After we get the data we need to process it, it's call Parsing or JSON Serilization
        
        
        //Step 1
        //In this case we have only http so we need to do some changes in info.plist file otherwise its completly fine with https
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=6905f0a0e8c896f6c12f6f4c7bf86740")
        let session = URLSession.shared
        
        //Step 2
        let task = session.dataTask(with: url!) { data, response, error in
            //Check for errors and display an alert
            if error != nil {
                
                let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //If no error check for data
                if data != nil {
                    
                    do{
                        //Casting might differ from API to API, we can also do String to String but in our data the keys are Strings but the values are of different types, meaning some are String, Int, Double and Boolean and thats the reson we have user "Any"
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        DispatchQueue.main.async {
                            //Create a dictionary, now again if the data we want to fetch is inside an array then we must create a dictionary over here
                            
                            if let rates = jsonResponse["rates"] as? [String : Any] {
                                
                                //Now lets get the data for the given keys, but before try to convert it to double as most of the values are doubles
                                if let usd = rates["USD"] as? Double {
                                    self.lableUSD.text = "USD: \(usd)"
                                }
                                if let cad = rates["CAD"] as? Double {
                                    self.lableCAD.text = "CAD: \(cad)"
                                }
                                if let eur = rates["EUR"] as? Double {
                                    self.lableEUR.text = "EUR: \(eur)"
                                }
                                if let inr = rates["INR"] as? Double {
                                    self.lableINR.text = "INR: \(inr)"
                                }
                                if let turkyish = rates["TRY"] as? Double {
                                    self.lableTRY.text = "TRY: \(turkyish)"
                                }
                                
                            }
                        }
                        
                    } catch {
                        print("ERROR")
                    }
                    
                }
                
            }
        }
        task.resume()
        
    }
}

