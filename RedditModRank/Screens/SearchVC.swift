

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView       = UIImageView()
    let subredditTextField   = MRTextField()
    let callToActionButton  = MRButton(backgroundColor: .systemGreen, title: "View Mods")

    var isSubredditEntered: Bool { return !subredditTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushModListVC() {
        guard isSubredditEntered else {
            presentMRAlertOnMainThread(title: "Empty Subreddit", message: "Please  enter a subreddit to view moderators", buttonTitle: "Ok")
            return
        }
        let modListVC       = ModListVC()
        modListVC.subreddit = subredditTextField.text
        modListVC.title     = subredditTextField.text
        navigationController?.pushViewController(modListVC, animated: true)
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureTextField() {
        view.addSubview(subredditTextField)
        subredditTextField.delegate = self
        
        NSLayoutConstraint.activate([
            subredditTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            subredditTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            subredditTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            subredditTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        callToActionButton.addTarget(self, action: #selector(pushModListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushModListVC()
        return true
    }
}
