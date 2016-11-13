//
//  TraktLoginViewController.swift
//  Series
//
//  Created by Konstantinos Loutas on 11/13/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import UIKit
import SafariServices

class TraktLoginViewController: UIViewController {

    let trakt = TraktClient()
    
    @IBOutlet weak var pinTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        presentAuthenticationView()
    }
    
    @IBAction func submitPinButtonPressed(_ sender: UIButton) {
        print("Submitted PIN: \(pinTextField.text)")
        trakt.requestAccessToken(withUserAuthorizationCode: pinTextField.text!) { (success, message: String?) in
            print("Request \(success ? "succeeded" : "failed") with message: \(message)")
        }
    }
    
    func presentAuthenticationView() {
        if let authenticationUrl = trakt.authenticationRequestUrl {
            print(authenticationUrl)
            let sVC = SFSafariViewController(url: authenticationUrl)
            self.present(sVC, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
