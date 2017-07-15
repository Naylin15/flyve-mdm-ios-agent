/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * ViewController.swift is part of flyve-mdm-ios
 *
 * flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * flyve-mdm-ios is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * flyve-mdm-ios is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      03/05/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import UIKit

enum EnrollmentState {
    case initial
    case loading
    case success
    case fail
}

class ViewController: UIViewController {

    var httpRequest: HttpRequest?
    
    var mdmAgent = [String: Any]()
    var userToken: String?
    var invitationToken: String?
    var topic:String?
    
    init(userToken: String, invitationToken: String?) {
        self.userToken = userToken
        self.invitationToken = invitationToken
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(mdmAgent: [String: Any]) {
        
        self.mdmAgent = mdmAgent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func loadView() {
        super.loadView()
        
        let notificationData = NotificationCenter.default
        notificationData.addObserver(self, selector: #selector(self.sendDataEnroll), name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil)
        
        if let _ = self.userToken, !self.userToken!.isEmpty {
            
            self.setupViews()
            
        } else {
            
            self.setupViewsEmpty()
        }
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.background
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.enrollBotton)
        self.enrollBotton.addSubview(self.playImageView)
        self.enrollBotton.addSubview(self.loadingIndicatorView)
        self.view.addSubview(self.statusLabel)
        
        self.addConstraints()
    }
    
    func addConstraints() {

        self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 72).isActive = true
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.messageLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 24).isActive = true
        self.messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true

        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 24).isActive = true
        
        self.enrollBotton.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        self.enrollBotton.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        self.enrollBotton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.enrollBotton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 24).isActive = true
        
        self.playImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        self.playImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        self.playImageView.centerXAnchor.constraint(equalTo: self.enrollBotton.centerXAnchor).isActive = true
        self.playImageView.centerYAnchor.constraint(equalTo: self.enrollBotton.centerYAnchor).isActive = true
        
        self.loadingIndicatorView.centerXAnchor.constraint(equalTo: self.enrollBotton.centerXAnchor).isActive = true
        self.loadingIndicatorView.centerYAnchor.constraint(equalTo: self.enrollBotton.centerYAnchor).isActive = true
        
        self.statusLabel.topAnchor.constraint(equalTo: self.enrollBotton.bottomAnchor, constant: 48).isActive = true
        self.statusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.statusLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.statusLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        self.statusLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
    }
    
    func setupViewsEmpty() {
        
        self.view.backgroundColor = UIColor.background
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.urlBotton)
        
        self.addConstraintsEmpty()
    }
    
    func addConstraintsEmpty() {
        
        self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 72).isActive = true
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.messageLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 24).isActive = true
        self.messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        
        self.urlBotton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 48).isActive = true
        self.urlBotton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    let logoImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let messageLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FLYVE MDM is a Mobile management software that enables you to secure and manage all  the mobile devices  of your business or family via a web-based console"
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .gray
        
        return label
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enroll device"
        label.font = UIFont.systemFont(ofSize: 36.0, weight: UIFontWeightLight)
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .black
        
        return label
    }()
    
    let statusLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .gray
        
        return label
    }()
    
    lazy var urlBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("http://flyve-mdm.com", for: .normal)
        button.addTarget(self, action: #selector(self.openURL), for: .touchUpInside)

        return button
    }()
    
    lazy var enrollBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 45
        button.backgroundColor = UIColor.main
        button.addTarget(self, action: #selector(self.enroll), for: .touchUpInside)
        
        return button
    }()
    
    let playImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "play"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        
        return loading
    }()
    
    func openURL() {
        guard let url = URL(string: "http://flyve-mdm.com") else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func enroll() {
        
        self.httpRequest = HttpRequest()
        self.httpRequest?.requestInitSession(userToken: self.userToken!)
        self.httpRequest?.delegate = self
        
        self.enrollState(.loading)
    }
    
    func enrollState(_ state: EnrollmentState) {
        
        switch state
        {
        case .initial:
            self.titleLabel.text = "Enroll device"
            self.enrollBotton.backgroundColor = UIColor.main
            self.enrollBotton.isUserInteractionEnabled = true
            self.playImageView.image = UIImage(named: "play")
            self.playImageView.isHidden = false
            self.loadingIndicatorView.stopAnimating()
            self.statusLabel.text = ""
            
        case .loading:
            self.titleLabel.text = "Enroll device"
            self.enrollBotton.backgroundColor = UIColor.loading
            self.enrollBotton.isUserInteractionEnabled = false
            self.playImageView.isHidden = true
            self.loadingIndicatorView.startAnimating()
            self.statusLabel.text = "PLEASE WAIT.."
            
        case .success:
            self.enrollBotton.backgroundColor = UIColor.main
            self.enrollBotton.isUserInteractionEnabled = false
            self.playImageView.image = UIImage(named: "")
            self.playImageView.image = UIImage(named: "success")
            self.playImageView.isHidden = false
            self.loadingIndicatorView.stopAnimating()
            self.statusLabel.text = "Success!"
        
        case .fail:
            self.titleLabel.text = "Enrollment fail"
            self.enrollBotton.backgroundColor = UIColor.fail
            self.enrollBotton.isUserInteractionEnabled = false
            self.playImageView.isHidden = true
            self.loadingIndicatorView.stopAnimating()
            self.statusLabel.text = ""
            
            delay {
                self.enrollState(.initial)
            }
        }
    }
}

extension ViewController: HttpRequestDelegate {
    
    func responseInitSession(data: [String: AnyObject]) {
        
        if let session_token = data["session_token"] as? String {
            
            sessionToken = session_token
            
            self.httpRequest?.requestGetFullSession()
        }
    }
    
    func errorInitSession(error: [String: String]) {
        
        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }
    
    func responseGetFullSession(data: [String: AnyObject]) {
        
        if let profiles_id = (data["session"]?["glpiactiveprofile"] as? [String: AnyObject])?["id"] as? Int, let guest_profiles_id = data["session"]?["plugin_flyvemdm_guest_profiles_id"] as? Int {
            
            if profiles_id == guest_profiles_id {
                
                self.httpRequest?.requestChangeActiveProfile(profilesID: "\(profiles_id)")

            } else {
                self.statusLabel.text = "Error: The device needs to change its profile"
            }
        } else {
            
            self.statusLabel.text = "Error: The device needs to change its profile"
        }
    }
    
    func errorGetFullSession(error: [String: String]) {
        
        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }
    
    func responseChangeActiveProfile() {

        self.present(UINavigationController(rootViewController: EnrollFormController()), animated: true, completion: nil)
    }
    
    func sendDataEnroll(notification:NSNotification) {
        
        var jsonDictionary = [String: AnyObject]()
        var inputDictionary = [String: String]()
        
        inputDictionary["_email"] = notification.userInfo?["_email"] as? String ?? ""
        inputDictionary["_invitation_token"] = self.invitationToken
        inputDictionary["_serial"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        inputDictionary["csr"] = ""
        inputDictionary["firstname"] = notification.userInfo?["firstname"] as? String ?? ""
        inputDictionary["lastname"] = notification.userInfo?["lastname"] as? String ?? ""
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            inputDictionary["version"] = version
        }
        
        jsonDictionary["input"] = inputDictionary as AnyObject
        
        setStorage(value: inputDictionary as AnyObject, key: "dataUser")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String : AnyObject] {
                // use dictFromJSON
                
                self.httpRequest?.requestPluginFlyvemdmAgent(parameters: dictFromJSON)
            }
        } catch {
            debugPrint(error.localizedDescription)
            self.loadingIndicatorView.stopAnimating()
        }
    }
    
    func errorChangeActiveProfile(error: [String: String]) {
        
        UserDefaults.standard.set(nil, forKey: "dataUser")
        
        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }
    
    func responsePluginFlyvemdmAgent(data: [String: AnyObject]) {
        
        if let id = data["id"] as? Int {
            
            self.httpRequest?.requestGetPluginFlyvemdmAgent(agentID: "\(id)")
        }
    }
    
    func errorPluginFlyvemdmAgent(error: [String: String]) {
        
        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }
    
    func responseGetPluginFlyvemdmAgent(data: [String: AnyObject]) {
        
        setStorage(value: data as AnyObject, key: "mdmAgent")
        
        self.enrollState(.success)
        
        delay {
            self.goMainController()
        }
    }
    
    func errorGetPluginFlyvemdmAgent(error: [String: String]) {
        
        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }
    
    
    func goMainController() {

        if let mdmAgentObject = getStorage(key: "mdmAgent") as? [String: AnyObject] {
            
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: MainController(mdmAgent: mdmAgentObject))
        }
    }
}