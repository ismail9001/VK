//
//  LoginFormController.swift
//  VK_app
//
//  Created by macbook on 11.10.2020.
//

import UIKit

class LoginFormController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingScreen: Loader!
    //@IBOutlet weak var cloud: UIView!
    @IBAction func testAction(_ sender: Any) {
    }
    
    @IBAction func scrollTapped(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    private var shapeLayer = CAShapeLayer()
    
    // MARK: - Segues
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if loginCheck() == false {
            showError("Ошибка", "Неверные данные пользователя")
            return false
        } else {
            return true
        }
    }
    func loginCheck() -> Bool{
        //let login = usernameInput.text!
        //let password = passwordInput.text!
        
        let login = "admin"
        let password = "123456"
        
        return login == "admin" && password == "123456"
    }
    
    func showError(_ errorTitle: String, _ errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //closeLoadingScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - keyboard events
    // Когда клавиатура появляется
    @objc func keyboardWillShow(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }    
}
