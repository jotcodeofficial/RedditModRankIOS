

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView       = UIImageView()
    let subredditTextField   = MRTextField()
    let callToActionButton  = MRButton(backgroundColor: .systemGreen, title: "Let's Go")
    var logoImageViewTopConstraint: NSLayoutConstraint!

    
    let tempUsers: [User] = []
    
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
        subredditTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushModListVC() {
        // TODO - Instead of getting the subreddit within the modlistVC we should get it here to ensure
        // there is no errors first. Only then should be push the modlistVC and pass in the subreddit directly.
        // This will prevent issues where the subreddit does not exist etc and have to go back to this controller, and also issues with making popups thread safe
         guard isSubredditEntered else {
            presentMRAlertOnMainThread(title: "Empty Subreddit", message: "Please  enter a subreddit to view moderators", buttonTitle: "Ok")
            return
         }
        
        subredditTextField.resignFirstResponder()
         let modListVC       = ModListVC(subreddit: subredditTextField.text!)
         navigationController?.pushViewController(modListVC, animated: true)

    }

    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.logo
        
        let topContraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topContraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([

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





