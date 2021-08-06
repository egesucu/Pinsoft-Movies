//
//  SplashViewController.swift
//  Pinsoft
//
//  Created by Ege Sucu on 4.08.2021.
//

import UIKit
import Network

// API KEY IS fb538778

class SplashViewController: UIViewController {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnection")
    let movies = [Movie]()
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    private var doesInternetAvailable : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkConnection()

    }
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                self.doesInternetAvailable = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.connectionStatusLabel.text = "Connection established."
                    self.navigateToHome()
                }
               
            } else {
                self.doesInternetAvailable = false
                self.connectionStatusLabel.text = "No Internet Connection found."
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func navigateToHome(){
        
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        
            if let navView = storyboard.instantiateViewController(withIdentifier: "HomeNavigation") as? UINavigationController{
                navView.modalPresentationStyle = .fullScreen
                present(navView, animated: true, completion: nil)
                
                
            }
        
        
    }

}
