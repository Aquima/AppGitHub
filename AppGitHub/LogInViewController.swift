//
//  LogInViewController.swift
//  AppGitHub
//
//  Created by User on 8/9/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var txtfUsername: UITextField!
    @IBOutlet weak var txtfPassword: UITextField!
    @IBOutlet weak var btnForget: UIButton!
    @IBOutlet weak var btnEnter: UIButton!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vista de LogIn")
        // Do any additional setup after loading the view.
        self.addStyle()
        self.addListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToDetail(notification:)), name: Notification.Name("loginCompleted"), object: nil)
    }
    @objc func goToDetail(notification: Notification){

        let objJSON = notification.object!
        DispatchQueue.main.async{
            let viewDetail = ViewController()// debio ser asi
            self.present(viewDetail, animated: true, completion: {
                
            })
        }
      
    }
    func callLogin(user:String,password:String)  {
        let url = URL(string: "https://api.github.com/user")!
        let loginString = String(format:"%@:%@",user,password)
        let loginData = loginString.data(using: String.Encoding.utf8)
        let base64Str = loginData?.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64Str!)", forHTTPHeaderField: "Authorization")
        
        let session:URLSession
        session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: { data,response,error in
            guard let data = data else { return }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                    JSONSerialization.ReadingOptions.mutableContainers)
                print(jsonResult)
                NotificationCenter.default.post(name: Notification.Name("loginCompleted"), object: jsonResult)
   
            } catch let err {
                
            }
        })
        task.resume()
    }
    // MARK: - IBActions
    @IBAction func validateData(_ sender: UIButton) {
        print("vamos los texfield")
        if (txtfUsername.text?.isEmpty)! && (txtfPassword.text?.isEmpty)! {
            print("necesitas ingresar tus datos")
            
        }else{
            self.callLogin(user: txtfUsername.text!, password: txtfPassword.text!)
        }
    }
    @IBAction func forget(_ sender: UIButton) {
        print("si funciona forget!")
    }
    // MARK: - Style
    func addStyle(){
        self.btnEnter.layer.cornerRadius = 3
        self.btnEnter.layer.borderColor = UIColor.black.cgColor
        self.btnEnter.layer.borderWidth = 1
    }


}
