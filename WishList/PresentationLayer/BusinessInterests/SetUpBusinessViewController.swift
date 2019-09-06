//
//  SetUpBusinessViewController.swift
//  WishList
//
//  Created by Dharmesh on 30/05/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel
import Haneke

class SetUpBusinessViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TSMessageViewProtocol {

    @IBOutlet weak var btnMyBusiness: UIButton!
    @IBOutlet weak var btnMyCompaniesOfInterest: UIButton!
    @IBOutlet weak var btnSelectedCompany: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var yellowBar: UIView!
    @IBOutlet weak var yellowBarTopConstraint: NSLayoutConstraint!
    
    //My Business
    @IBOutlet weak var myBusinessView: UIView!
    @IBOutlet weak var businessScrollView: UIScrollView!
    @IBOutlet weak var tvDescription: KMPlaceholderTextView!
    @IBOutlet weak var secondTextView: KMPlaceholderTextView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var of200lbl: UILabel!
    @IBOutlet weak var txtViewHolder: UIView!
    @IBOutlet weak var secondtextViewHolder: UIView!
    @IBOutlet weak var btnGoNext: UIButton!
    @IBOutlet weak var btnGoNxtBtmCnstrnt: NSLayoutConstraint!
    
    
    //Companies Of Intrust
    @IBOutlet weak var companyOfIntrustView: UIView!
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var lblSearchCompanies: UILabel!
    @IBOutlet weak var transperentView: UIView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnRightOfMyBusiness: UIButton!
    
    var companyObjects = [CompanyObject]()
    var nextPageURL = ""
    var footerView = UIView()
    var selectedCompaniesArray = [CompanyObject]()
    
    //Search Company View
    @IBOutlet weak var tfSearchCompanies: UITextField!
    @IBOutlet weak var searchCompaniesViewHolder: UIView!
    @IBOutlet weak var tblSearchCompanies: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnCancleSearch: UIButton!
    @IBOutlet weak var imgSearchIcon: UIImageView!
    @IBOutlet weak var selectCompaniesIntroView: UIView!
    @IBOutlet weak var slctCmpnyIntroViewTopCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var btnQuestion: UIButton!
    @IBOutlet weak var selectedCompaniesView: UIView!
    @IBOutlet weak var tblSelectedCompanies: UITableView!
    
    @IBOutlet weak var btnDoneFinal: UIButton!
    @IBOutlet weak var transparentViewTopCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var srchcmpniesViewHolderTopCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var myBusinessIntroView: UIView!
    @IBOutlet weak var myBusinessIntroTopCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var introImageForMyBusiness: UIImageView!
    @IBOutlet weak var introImageForCompanies: UIImageView!
    
    var nextPageURLForSearch = ""
    var companyObjectsForSearch = [CompanyObject]()
    var tempObjectForSearch = [CompanyObject]()
    var tableviewNeedsUpdate = false
    var commingFromMoreForMyBusiness = false
    var selectedCompCount = 0
    let loader = MFLoader()
    
    var myBusinssIntroForFirstTime = UserDefaults.standard.bool(forKey: "MyBusinessIntroForFirstTime")
   // var selectCompaniesIntroForFirstTime = UserDefaults.standard.bool(forKey: "selectCompaniesIntroForFirstTime")
    var commingFromCompaniseScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        btnLeft.isHidden = true
        btnRight.isHidden = true
        btnDoneFinal.isHidden = true
        self.btnSelectedCompany.layer.cornerRadius = (btnSelectedCompany.frame.size.width)/2
        self.btnSelectedCompany.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(SetUpBusinessViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SetUpBusinessViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tfSearchCompanies.attributedPlaceholder = NSAttributedString(string:"Search Companies",
                                                                     attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        tfSearchCompanies.delegate = self
        tfSearchCompanies.addTarget(self, action: #selector(SetUpBusinessViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        tfSearchCompanies.autocorrectionType = .no
        activityIndicator.isHidden = true
        
        tvDescription.returnKeyType = UIReturnKeyType.next
        secondTextView.returnKeyType = UIReturnKeyType.done
        businessScrollView.contentSize = CGSize(width: 320, height: 450)
        tvDescription.delegate = self
        secondTextView.delegate = self
    
        btnMyBusiness.isSelected = true
        myBusinessView.isHidden = false
        companyOfIntrustView.isHidden = true
        searchCompaniesViewHolder.isHidden = true
        btnCancleSearch.isHidden = true
        selectedCompaniesView.isHidden = true
        
        initFooterView()
        lblSearchCompanies.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetUpBusinessViewController.StartSearchingCompanies))
        lblSearchCompanies.addGestureRecognizer(tap)
        
        self.tblCompanies.sectionIndexColor = UIColor(red: 142/255, green: 176/255, blue: 214/255, alpha: 1)
        self.tblCompanies.sectionIndexBackgroundColor = UIColor.clear
        
        if commingFromMoreForMyBusiness || commingFromCompaniseScreen {
            
            btnGoNxtBtmCnstrnt.constant = -400
            btnLeft.isHidden = true
            btnRight.isHidden = true
            btnDoneFinal.isHidden = true
            
            yellowBar.isHidden = true
            yellowBarTopConstraint.constant = -5
            tblCompanies.setHeight(350)
            tblSelectedCompanies.setHeight(411)
            btnBack.isHidden = false
            getBusinessDetail()
            
        } else {
            
            getCompanies(false)
            let userDefaults = UserDefaults.standard
            guard let decoded = userDefaults.object(forKey: "SelectedComp") as? Data else {return}
            print("decoded = \(decoded)")
            if decoded.count > 0 {
                guard let selcomparr =  NSKeyedUnarchiver.unarchiveObject(with: decoded) else {return}
                print("selcomparr = \(selcomparr)")
                guard let selcarr2 = selcomparr as? CompanyObject else {return}
                print("selcarr2 = \(selcarr2)")
                selectedCompaniesArray = [selcarr2]
                self.tblSelectedCompanies.reloadData()
                self.btnSelectedCompany.setTitle("\(self.selectedCompaniesArray.count)", for: UIControl.State())
             
                self.tableviewNeedsUpdate = true
                
            }
        }
        
        let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(pushSettings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.transperentView.isHidden = true
        self.slctCmpnyIntroViewTopCnstrnt.constant = 1000
        self.myBusinessIntroTopCnstrnt.constant = 1000
        myBusinssIntroForFirstTime = UserDefaults.standard.bool(forKey: "MyBusinessIntroForFirstTime")
        if !myBusinssIntroForFirstTime {
            
            let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(SetUpBusinessViewController.hideMainIntroForMyBusiness))
            introImageForMyBusiness.isUserInteractionEnabled = true
            introImageForMyBusiness.addGestureRecognizer(tapForMainViewImage)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SetUpBusinessViewController.respondToSwipeGestureForMyBusiness(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.introImageForMyBusiness.addGestureRecognizer(swipeLeft)
            //myBusinessIntroView.setY(0)
            self.myBusinessIntroTopCnstrnt.constant = 0
            //self.tabBarController?.tabBar.layer.zPosition = -1
            self.tabBarController?.tabBar.isHidden = true
            UserDefaults.standard.set(true, forKey: "MyBusinessIntroForFirstTime")
        }
        
        let isMyBusinessSelected = UserDefaults.standard.bool(forKey: "businessSelected")
        if !isMyBusinessSelected {
            tvDescription.text = UserDefaults.standard.object(forKey: "tvDescription") as? String
            secondTextView.text = UserDefaults.standard.object(forKey: "secondTextView") as? String
        }
    }
    
    func setupUI(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1792, 2436, 2688:
                introImageForMyBusiness.image = UIImage(named: "MyBusinessIntroScreenX")
                introImageForCompanies.image = UIImage(named: "SetUpCompaniesFuteScreenX")
            default:
                introImageForMyBusiness.image = UIImage(named: "MyBusinessIntroScreen")
                introImageForCompanies.image = UIImage(named: "SetUpCompaniesFuteScreen")
            }
        }
    }
    
    @IBAction func btnQuestionTapped(_ sender: AnyObject) {
        
        //selectCompaniesIntroView.setY(0)
        
         self.tabBarController?.tabBar.isHidden = true
         //self.tabBarController?.tabBar.layer.zPosition = -1
         slctCmpnyIntroViewTopCnstrnt.constant = 0
    }
    
    @IBAction func btnCancleSelectCompaniesIntroView(_ sender: AnyObject) {
        
        //selectCompaniesIntroView.setY(568)
       slctCmpnyIntroViewTopCnstrnt.constant = 1000
         //self.tabBarController?.tabBar.layer.zPosition = 0
         self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    @objc func hideMainIntroForMyBusiness() {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
         self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                self.myBusinessIntroTopCnstrnt.constant = 1000
            }, completion: nil)
    }
    
    @objc func respondToSwipeGestureForMyBusiness(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                
                //self.tabBarController?.tabBar.layer.zPosition = 0
                 self.tabBarController?.tabBar.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        self.myBusinessIntroTopCnstrnt.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    @IBAction func btnCancleMyIntroScreen(_ sender: AnyObject) {
        
       self.myBusinessIntroTopCnstrnt.constant = 1000
        //self.tabBarController?.tabBar.layer.zPosition = 0
       self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnSaveClicked(_ sender: AnyObject) {
        
        btnDoneTapped()
    }
    
    func btnDoneTapped()
    {
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        if tvDescription.text.characters.count > 0 {
            
            if selectedCompaniesArray.count > 0 {
                
                loader.showActivityIndicator(self.view)
                let myBusinessModel = WLMyBusiness()
                
                myBusinessModel.business_discussion = tvDescription.text!
                myBusinessModel.business_additional = secondTextView.text!
                
                for company in selectedCompaniesArray {
                    
                    selectedIntArray.append(company.id!)
                }
                if commingFromMoreForMyBusiness || commingFromCompaniseScreen {
                    
                    myBusinessModel.forPUT = true
                } else {
                    myBusinessModel.forPUT = false
                }
                myBusinessModel.companiesofInterest = selectedIntArray
                myBusinessModel.myBusiness({ (Void, Any) -> Void in
                    
                    self.loader.hideActivityIndicator(self.view)
                    
                    UserDefaults.standard.set(nil, forKey: "SelectedComp")
                    UserDefaults.standard.set(nil, forKey: "tvDescription")
                    UserDefaults.standard.set(nil, forKey: "secondTextView")
                    
                    if self.commingFromMoreForMyBusiness || self.commingFromCompaniseScreen {
                        
                        Mixpanel.sharedInstance()?.track("My Business Updated", properties:nil)
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        
                        Mixpanel.sharedInstance()?.track("Set Up Business", properties:nil)
                        UserDefaults.standard.set(true, forKey: "businessSelected")
                        let ChooseNetworkView = self.storyboard?.instantiateViewController(withIdentifier: "ChooseNetworkViewController") as! ChooseNetworkViewController
                        self.navigationController?.pushViewController(ChooseNetworkView, animated: true)
                    }
                    
                }, errorCallback: { (Void, NSError) -> Void in
                    
                    print(NSError)
                    self.loader.hideActivityIndicator(self.view)
                    
                })
                
            } else {
                
                let alert = UIAlertController(title: "Alert", message: "Select at least 1 company you'd like an intro to.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            
            myBusinessView.isHidden = false
            companyOfIntrustView.isHidden = true
            selectedCompaniesView.isHidden = true
            btnLeft.isHidden = true
            btnRight.isHidden = true
            btnDoneFinal.isHidden = true
            
            btnMyBusiness.isSelected = true
            btnSelectedCompany.isSelected = false
            btnMyCompaniesOfInterest.isSelected = false
            
            self.txtViewHolder.shake()
            self.txtViewHolder.layer.borderWidth = 1
            self.txtViewHolder.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    func getBusinessDetail() {
        
        myBusinssIntroForFirstTime = UserDefaults.standard.bool(forKey: "MyBusinessIntroForFirstTime")
        
        if rechability.isConnectedToNetwork() {
            
            if myBusinssIntroForFirstTime {
                loader.showActivityIndicator(self.view)
            }
            
            let myBusinessModel = WLMyBusiness()
            if commingFromMoreForMyBusiness || commingFromCompaniseScreen {
                
                myBusinessModel.forPUT = true
            } else {
                myBusinessModel.forPUT = false
            }
            myBusinessModel.myBusiness({ (Void, AnyObject) -> Void in
                
                self.loader.hideActivityIndicator(self.view)
                
                if let response = AnyObject as? [String: AnyObject] {
                    
                    let myBusinessOtherInfo = response["myBusinessOtherInfo"] as? String ?? ""
                    let myBusinessDiscussion = response["myBusinessDiscussion"] as? String ?? ""
                    
                    self.tvDescription.text = myBusinessDiscussion
                    self.secondTextView.text = myBusinessOtherInfo
                    
                    self.lblCount.text = "\(200 - myBusinessDiscussion.length)"
                    self.of200lbl.text = "\(200 - myBusinessOtherInfo.length)"
                    
                    if let companiesofInterest = response["companiesofInterest"] as? [[String: AnyObject]] {
                        
                        for company in companiesofInterest {
                            
                            let id = company["id"] as? Int ?? 0
                            let slug = company["slug"] as? String ?? ""
                            let date_created = company["date_created"] as? String ?? ""
                            let date_changed = company["date_changed"] as? String ?? ""
                            let title = company["title"] as? String ?? ""
                            let profile_image_url = company["profile_image_url"] as? String ?? ""
                            let type = company["type"] as? String ?? ""
                            let primary_role = company["primary_role"] as? String ?? ""
                            let unique_thirdparty_ref = company["unique_thirdparty_ref"] as? String ?? ""
                            let short_description = company["short_description"] as? String ?? ""
                            let funding_round_name = company["funding_round_name"] as? String ?? ""
                            let crunchbase_url = company["crunchbase_url"] as? String ?? ""
                            let homepage_url = company["homepage_url"] as? String ?? ""
                            let facebook_url = company["facebook_url"] as? String ?? ""
                            let twitter_url = company["twitter_url"] as? String ?? ""
                            let linkedin_url = company["linkedin_url"] as? String ?? ""
                            let stock_symbol = company["stock_symbol"] as? String ?? ""
                            let location_city = company["location_city"] as? String ?? ""
                            let location_region = company["location_region"] as? String ?? ""
                            let location_country_code = company["location_country_code"] as? String ?? ""
                            
                            let companyDetail = CompanyObject(id: id, slug: slug, date_created: date_created, date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: true)
                            
                            self.selectedCompaniesArray.append(companyDetail)
                        }
                        self.selectedCompCount = self.selectedCompaniesArray.count
                        self.selectedCompaniesArray.sort(by: { $0.title < $1.title })
                        self.tblSelectedCompanies.reloadData()
                        self.btnSelectedCompany.setTitle("\(self.selectedCompaniesArray.count)", for: UIControl.State())
                        self.tableviewNeedsUpdate = true
                    }
                }
                
                }, errorCallback: { (Void, NSError) -> Void in
                    
                    self.loader.hideActivityIndicator(self.view)
                    
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
    
    func okHandler(alert: UIAlertAction)
    {
        btnDoneTapped()
    }
    
    func cancelHandler(alert: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {

        if  selectedCompCount != 0 && (selectedCompCount < self.selectedCompaniesArray.count){
            let  alert = UIAlertController(title: "Niceleads", message: "You made change, Do you want to save it ?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: okHandler))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: cancelHandler))
            self.present(alert, animated: true, completion: nil)
        }

        if self.commingFromMoreForMyBusiness || self.commingFromCompaniseScreen {
            
            if textViewChanged {
                
                let alert = UIAlertController(title: "Alert", message: "Would you like to save your data?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    
                    if !rechability.isConnectedToNetwork() {
                        TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                        return
                    }
                    
                    if self.tvDescription.text.characters.count > 0 {
                        
                        self.loader.showActivityIndicator(self.view)
                        let myBusinessModel = WLMyBusiness()
                        
                        myBusinessModel.business_discussion = self.tvDescription.text!
                        myBusinessModel.business_additional = self.secondTextView.text!
                        myBusinessModel.onlyForBusiness = true
                        myBusinessModel.forPUT = true
                        myBusinessModel.myBusiness({ (Void, Any) -> Void in
                            
                            self.loader.hideActivityIndicator(self.view)
                            
                            if self.commingFromMoreForMyBusiness || self.commingFromCompaniseScreen {
                                
                                Mixpanel.sharedInstance()?.track("My Business Updated", properties:nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            }, errorCallback: { (Void, NSError) -> Void in
                                
                                print(NSError)
                                self.loader.hideActivityIndicator(self.view)
                                
                        })
                        
                    } else {
                        
                        self.myBusinessView.isHidden = false
                        self.companyOfIntrustView.isHidden = true
                        self.selectedCompaniesView.isHidden = true
                        self.btnLeft.isHidden = true
                        self.btnRight.isHidden = true
                        self.btnDoneFinal.isHidden = true
                        
                        self.btnMyBusiness.isSelected = true
                        self.btnSelectedCompany.isSelected = false
                        self.btnMyCompaniesOfInterest.isSelected = false
                        
                        self.txtViewHolder.shake()
                        self.txtViewHolder.layer.borderWidth = 1
                        self.txtViewHolder.layer.borderColor = UIColor.red.cgColor
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnCancleSearchTapped(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        searchCompaniesViewHolder.isHidden = true
        btnCancleSearch.isHidden = true
        imgSearchIcon.isHidden = false
        tfSearchCompanies.text = ""
    }
  
    @objc func keyboardWillShow(_ sender: Foundation.Notification) {
        srchcmpniesViewHolderTopCnstrnt.constant = 150
    }
    
    @objc func keyboardWillHide(_ sender: Foundation.Notification) {
        
        if commingFromMoreForMyBusiness || commingFromCompaniseScreen {
            self.srchcmpniesViewHolderTopCnstrnt.constant = 0
           // searchCompaniesViewHolder.frame.size.height = 350
            //tblSearchCompanies.frame.size.height = 350
            
        } else {
          self.srchcmpniesViewHolderTopCnstrnt.constant = 0
         //searchCompaniesViewHolder.frame.size.height = 405
         //tblSearchCompanies.frame.size.height = 405
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func StartSearchingCompanies() {
        
        imgSearchIcon.isHidden = true
        btnCancleSearch.isHidden = false
        searchCompaniesViewHolder.isHidden = false
        tfSearchCompanies.becomeFirstResponder()
    }
    

    
    func getCompanies(_ showLoader: Bool) {
        
        if showLoader {
            
            loader.showActivityIndicator(self.view)
        }
        
        
        if rechability.isConnectedToNetwork() {
            
            let companyModel = WLCompanyList()
            companyModel.companyList({ (Void, AnyObject) -> Void in
                
                self.companyObjects.removeAll()
                if showLoader {
                    
                    self.loader.hideActivityIndicator(self.view)
                }
                
                let response = AnyObject as! [String: AnyObject]
                
                self.nextPageURL = ""
                self.nextPageURL = response["next"] as? String ?? ""
                
                if let companies = response["results"] as? [[String: AnyObject]] {
                    
                    for company in companies {
                        
                        let id = company["id"] as? Int ?? 0
                        let slug = company["slug"] as? String ?? ""
                        let date_created = company["date_created"] as? String ?? ""
                        let date_changed = company["date_changed"] as? String ?? ""
                        let title = company["title"] as? String ?? ""
                        let profile_image_url = company["profile_image_url"] as? String ?? ""
                        let type = company["type"] as? String ?? ""
                        let primary_role = company["primary_role"] as? String ?? ""
                        let unique_thirdparty_ref = company["unique_thirdparty_ref"] as? String ?? ""
                        let short_description = company["short_description"] as? String ?? ""
                        let funding_round_name = company["funding_round_name"] as? String ?? ""
                        let crunchbase_url = company["crunchbase_url"] as? String ?? ""
                        let homepage_url = company["homepage_url"] as? String ?? ""
                        let facebook_url = company["facebook_url"] as? String ?? ""
                        let twitter_url = company["twitter_url"] as? String ?? ""
                        let linkedin_url = company["linkedin_url"] as? String ?? ""
                        let stock_symbol = company["stock_symbol"] as? String ?? ""
                        let location_city = company["location_city"] as? String ?? ""
                        let location_region = company["location_region"] as? String ?? ""
                        let location_country_code = company["location_country_code"] as? String ?? ""
                        
                        
                        let companyDetail = CompanyObject(id: id, slug: slug, date_created: date_created, date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: false)
                        
                        if self.selectedCompaniesArray.count > 0 {
                            
                            var totalIds = [Int]()
                            for comp in self.selectedCompaniesArray {
                                totalIds.append(comp.id!)
                            }
                            if !totalIds.contains(id) {
                                self.companyObjects.append(companyDetail)
                            }
                        } else {
                            
                            self.companyObjects.append(companyDetail)
                        }
                    }
                    self.tblCompanies.reloadData()
                }
                
                }, errorCallback: { (Void, NSError) -> Void in
                    print(NSError)
                    if showLoader {
                        self.loader.hideActivityIndicator(self.view)
                    }
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
        
    }
    
    func initFooterView() {
        
        footerView = UIView(frame: CGRect(x: 0,y: 0,width: 320,height: 40))
        let actInd = UIActivityIndicatorView(style: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: 150, y: 5, width: 20, height: 20)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        
    }
    
    func ChangetxtDescriptionBorder() {
        
        self.txtViewHolder.shake()
        self.txtViewHolder.layer.borderWidth = 1
        self.txtViewHolder.layer.borderColor = UIColor.red.cgColor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == secondTextView {
            
            self.businessScrollView .setContentOffset(CGPoint(x: 0, y: 90), animated: true)
        } else {
            
            self.txtViewHolder.layer.borderWidth = 0
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == secondTextView {
            self.businessScrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == tvDescription {
            
            
            if text == "\n" {
                secondTextView.becomeFirstResponder()
                return false
            }
            return textView.text.characters.count + (text.characters.count - range.length) <= 200
        } else {
            
            if text == "\n" {
                secondTextView.resignFirstResponder()
                return false
            }
            
            return textView.text.characters.count + (text.characters.count - range.length) <= 200
        }
    }
    
    var textViewChanged = false
    
    func textViewDidChange(_ textView: UITextView) {
        
        textViewChanged = true
        if textView == tvDescription {
            lblCount.text = "\(tvDescription.text.characters.count) of 200"
            UserDefaults.standard.set(tvDescription.text!, forKey: "tvDescription")
        } else {
            of200lbl.text = "\(secondTextView.text.characters.count) of 200"
            UserDefaults.standard.set(secondTextView.text!, forKey: "secondTextView")
        }
    }
    
    var myBusinessSelected = true
    var CompaniesOfIntrustSelected = false
    var selectedCompaniesSelected = false
    
    @IBAction func btnMyBusinessTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.btnQuestion.isHidden = true
        self.btnRightOfMyBusiness.isHidden = false
        
        myBusinessSelected = true
        CompaniesOfIntrustSelected = false
        selectedCompaniesSelected = false
        
        btnMyBusiness.isSelected = true
        btnMyCompaniesOfInterest.isSelected = false
        btnSelectedCompany.isSelected = false
        
        myBusinessView.isHidden = false
        companyOfIntrustView.isHidden = true
        selectedCompaniesView.isHidden = true
        
        btnLeft.isHidden = true
        btnRight.isHidden = true
        
        btnDoneFinal.isHidden = true
    }
    
    @objc func hideMainIntro() {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
          self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
               // self.selectCompaniesIntroView.setY(568)
                self.slctCmpnyIntroViewTopCnstrnt.constant = 1000
            }, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                
                //self.tabBarController?.tabBar.layer.zPosition = 0
                 self.tabBarController?.tabBar.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        //self.selectCompaniesIntroView.setY(568)
                        self.slctCmpnyIntroViewTopCnstrnt.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    @IBAction func btnCompanyOfIntrustTapped(_ sender: AnyObject) {
        
        var selectCompaniesIntroForFirstTime = UserDefaults.standard.bool(forKey: "selectCompaniesIntroForFirstTime")
        if !selectCompaniesIntroForFirstTime {
            
            let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(SetUpBusinessViewController.hideMainIntro))
            introImageForCompanies.isUserInteractionEnabled = true
            introImageForCompanies.addGestureRecognizer(tapForMainViewImage)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SetUpBusinessViewController.respondToSwipeGesture(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.introImageForCompanies.addGestureRecognizer(swipeLeft)
            
            //selectCompaniesIntroView.setY(0)
            self.slctCmpnyIntroViewTopCnstrnt.constant = 0
          //  selectCompaniesIntroForFirstTime = true
            //self.tabBarController?.tabBar.layer.zPosition = -1
             self.tabBarController?.tabBar.isHidden = true
            UserDefaults.standard.set(true, forKey: "selectCompaniesIntroForFirstTime")
        }
        
        self.view.endEditing(true)
        self.btnQuestion.isHidden = false
        self.btnRightOfMyBusiness.isHidden = true
        myBusinessSelected = false
        CompaniesOfIntrustSelected = true
        selectedCompaniesSelected = false
        
        btnMyBusiness.isSelected = false
        btnMyCompaniesOfInterest.isSelected = true
        btnSelectedCompany.isSelected = false
        
        myBusinessView.isHidden = true
        companyOfIntrustView.isHidden = false
        selectedCompaniesView.isHidden = true
        
        
        if tableviewNeedsUpdate {
            
            tableviewNeedsUpdate = false
            getCompanies(true)
        } else if companyObjects.count == 0 {
            
            getCompanies(true)
        }
        
        btnLeft.isHidden = false
        btnRight.isHidden = false
        
        btnDoneFinal.isHidden = true
    }
    
    @IBAction func btnSelectedCompanyTapped(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        self.btnQuestion.isHidden = false
        self.btnRightOfMyBusiness.isHidden = true
        myBusinessSelected = false
        CompaniesOfIntrustSelected = false
        selectedCompaniesSelected = true
        
        btnMyBusiness.isSelected = false
        btnMyCompaniesOfInterest.isSelected = false
        btnSelectedCompany.isSelected = true
        
        myBusinessView.isHidden = true
        companyOfIntrustView.isHidden = true
        selectedCompaniesView.isHidden = false
        tblSelectedCompanies.reloadData()
        
        btnLeft.isHidden = false
        btnDoneFinal.isHidden = false
    }
    
    @IBAction func btnGotoCompanyOfIntrustTapped(_ sender: AnyObject) {
        
        if self.commingFromMoreForMyBusiness || self.commingFromCompaniseScreen {
            
            if textViewChanged {
                
                if !rechability.isConnectedToNetwork() {
                    TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                    return
                }
                
                if tvDescription.text.characters.count > 0 {
                    
                    loader.showActivityIndicator(self.view)
                    let myBusinessModel = WLMyBusiness()
                    
                    myBusinessModel.business_discussion = tvDescription.text!
                    myBusinessModel.business_additional = secondTextView.text!
                    myBusinessModel.onlyForBusiness = true
                    myBusinessModel.forPUT = true
                    myBusinessModel.myBusiness({ (Void, Any) -> Void in
                        
                        self.loader.hideActivityIndicator(self.view)
                        
                        if self.commingFromMoreForMyBusiness || self.commingFromCompaniseScreen {
                            
                            Mixpanel.sharedInstance()?.track("My Business Updated", properties:nil)
                            self.btnQuestion.isHidden = false
                            self.btnCompanyOfIntrustTapped(self.btnMyCompaniesOfInterest)
                            self.btnDoneFinal.isHidden = true
                        }
                        
                        }, errorCallback: { (Void, NSError) -> Void in
                            
                            print(NSError)
                            self.loader.hideActivityIndicator(self.view)
                            
                    })
                    
                } else {
                    
                    myBusinessView.isHidden = false
                    companyOfIntrustView.isHidden = true
                    selectedCompaniesView.isHidden = true
                    btnLeft.isHidden = true
                    btnRight.isHidden = true
                    btnDoneFinal.isHidden = true
                    
                    btnMyBusiness.isSelected = true
                    btnSelectedCompany.isSelected = false
                    btnMyCompaniesOfInterest.isSelected = false
                    
                    self.txtViewHolder.shake()
                    self.txtViewHolder.layer.borderWidth = 1
                    self.txtViewHolder.layer.borderColor = UIColor.red.cgColor
                }
            } else {
                
                self.btnQuestion.isHidden = false
                self.btnCompanyOfIntrustTapped(self.btnMyCompaniesOfInterest)
                self.btnDoneFinal.isHidden = true
            }
            
            
        } else {
            
            self.btnQuestion.isHidden = false
            self.btnCompanyOfIntrustTapped(self.btnMyCompaniesOfInterest)
            self.btnDoneFinal.isHidden = true
        }
    }
    
    @IBAction func btnGoToMybusinessTapped(_ sender: AnyObject) {
        
        btnDoneFinal.isHidden = true
        if selectedCompaniesSelected {
            
            self.view.endEditing(true)
            
            myBusinessSelected = false
            CompaniesOfIntrustSelected = true
            selectedCompaniesSelected = false
            
            btnMyBusiness.isSelected = false
            btnMyCompaniesOfInterest.isSelected = true
            btnSelectedCompany.isSelected = false
            
            myBusinessView.isHidden = true
            companyOfIntrustView.isHidden = false
            selectedCompaniesView.isHidden = true
            
            
            if tableviewNeedsUpdate {
                
                tableviewNeedsUpdate = false
                getCompanies(true)
            }
            
            btnLeft.isHidden = false
            btnRight.isHidden = false
            
        } else {
            
            self.view.endEditing(true)
            self.btnQuestion.isHidden = true
            myBusinessSelected = true
            CompaniesOfIntrustSelected = false
            selectedCompaniesSelected = false
            
            btnMyBusiness.isSelected = true
            btnMyCompaniesOfInterest.isSelected = false
            btnSelectedCompany.isSelected = false
            
            myBusinessView.isHidden = false
            companyOfIntrustView.isHidden = true
            selectedCompaniesView.isHidden = true
            
            btnLeft.isHidden = true
            btnRight.isHidden = true
        }
    }
    
    var selectedIntArray = [Int]()
    
    @IBAction func btnGotoChooseNetworkTapped(_ sender: AnyObject) {
        
        btnDoneFinal.isHidden = false
        btnSelectedCompanyTapped(self)
    }
}

extension SetUpBusinessViewController{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        imgSearchIcon.isHidden = true
        btnCancleSearch.isHidden = false
        searchCompaniesViewHolder.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == tfSearchCompanies {
            
            if textField.text?.characters.count > 1 {
                
                if !rechability.isConnectedToNetwork() {
                    TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                    return
                }
                
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                
                let searchCompanies = WLSearchCompaniesOfIntrust()
                searchCompanies.searchKeyword = tfSearchCompanies.text!
                searchCompanies.searchCompanyOfIntrust({(Void, AnyObject) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.companyObjectsForSearch.removeAll()
                    
                    let response = AnyObject as! [String: AnyObject]
                    
                    self.nextPageURLForSearch = ""
                    self.nextPageURLForSearch = response["next"] as? String ?? ""
                    
                    if let companies = response["results"] as? [[String: AnyObject]] {
                        
                        for company in companies {
                            
                            let id = company["id"] as? Int ?? 0
                            let slug = company["slug"] as? String ?? ""
                            let date_created = company["date_created"] as? String ?? ""
                            let date_changed = company["date_changed"] as? String ?? ""
                            let title = company["title"] as? String ?? ""
                            let profile_image_url = company["profile_image_url"] as? String ?? ""
                            let type = company["type"] as? String ?? ""
                            let primary_role = company["primary_role"] as? String ?? ""
                            let unique_thirdparty_ref = company["unique_thirdparty_ref"] as? String ?? ""
                            let short_description = company["short_description"] as? String ?? ""
                            let funding_round_name = company["funding_round_name"] as? String ?? ""
                            let crunchbase_url = company["crunchbase_url"] as? String ?? ""
                            let homepage_url = company["homepage_url"] as? String ?? ""
                            let facebook_url = company["facebook_url"] as? String ?? ""
                            let twitter_url = company["twitter_url"] as? String ?? ""
                            let linkedin_url = company["linkedin_url"] as? String ?? ""
                            let stock_symbol = company["stock_symbol"] as? String ?? ""
                            let location_city = company["location_city"] as? String ?? ""
                            let location_region = company["location_region"] as? String ?? ""
                            let location_country_code = company["location_country_code"] as? String ?? ""
                            
                            let companyDetail = CompanyObject(id: id, slug: slug, date_created: date_created, date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: false)
                            
                            if self.selectedCompaniesArray.count > 0 {
                                
                                var totalIds = [Int]()
                                for comp in self.selectedCompaniesArray {
                                    totalIds.append(comp.id!)
                                }
                                if !totalIds.contains(id) {
                                    self.tempObjectForSearch.append(companyDetail)
                                }
                            } else {
                                
                                self.tempObjectForSearch.append(companyDetail)
                            }
                        }
                        
                        for object in self.tempObjectForSearch {
                            
                            if object.title!.lowercased().contains(textField.text!.lowercased()) {
                                
                                self.companyObjectsForSearch.append(object)
                            }
                        }
                        self.companyObjectsForSearch = self.companyObjectsForSearch.filterDuplicates { $0.title! == $1.title!}
                        self.tblSearchCompanies.reloadData()
                    }
                    
                }, errorCallback: { (Void, NSError) -> Void in
                    print(NSError)
                    
                })
            }
            
            if textField.text?.characters.count == 0 {
                
                companyObjectsForSearch.removeAll()
                self.tblSearchCompanies.reloadData()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension SetUpBusinessViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            
        case tblCompanies:
            
            return companyObjects.count
            
        case tblSearchCompanies:
            
            return companyObjectsForSearch.count
            
        case tblSelectedCompanies:
            
            return selectedCompaniesArray.count
            
        default:
            
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case tblCompanies:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyInterestIdentifier", for: indexPath) as! CompanyInterestTableViewCell
            
            cell.selectionStyle = .none
            
            let company = companyObjects[indexPath.row]
            cell.lblCompanyTitle.text = company.title
            cell.imgCompanyLogo.image = UIImage(named: "CompanyPlaceHolderImage")
            if let companyURL = company.profile_image_url {
                if let URL = URL(string: companyURL) {
                    cell.imgCompanyLogo.hnk_setImageFromURL(URL)
                } else {
                    cell.imgCompanyLogo.image = UIImage(named: "CompanyPlaceHolderImage")
                }
                
            }
            cell.btnChecked.isSelected = company.isSelected!
            
            return cell
            
        case tblSearchCompanies:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyInterestIdentifier", for: indexPath) as! CompanyInterestTableViewCell
            
            cell.selectionStyle = .none
            
            let company = companyObjectsForSearch[indexPath.row]
            cell.lblCompanyTitle.text = company.title
            cell.imgCompanyLogo.image = UIImage(named: "CompanyPlaceHolderImage")
            
            if let companyURL = company.profile_image_url {
                if let URL = URL(string: companyURL) {
                    cell.imgCompanyLogo.hnk_setImageFromURL(URL)
                } else {
                    cell.imgCompanyLogo.image = UIImage(named: "CompanyPlaceHolderImage")
                }
                
            }
            
            cell.btnChecked.isSelected = company.isSelected!
            
            return cell
            
        case tblSelectedCompanies:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyInterestIdentifier", for: indexPath) as! CompanyInterestTableViewCell
            
            cell.selectionStyle = .none
            
            let company = selectedCompaniesArray[indexPath.row]
            cell.lblCompanyTitle.text = company.title
            cell.imgCompanyLogo.image = UIImage(named: "CompanyPlaceHolderImage")
            
            if let companyURL = company.profile_image_url {
                if let URL = URL(string: companyURL) {
                    cell.imgCompanyLogo.hnk_setImageFromURL(URL)
                } else {
                    cell.imgCompanyLogo.image = UIImage(named: "CompanyPlaceHolderImage")
                }
            }
            
            cell.btnChecked.isSelected = company.isSelected!
            
            return cell
            
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case tblCompanies:
            
            let company = companyObjects[indexPath.row]
            company.isSelected = true
            selectedCompaniesArray.append(company)
            selectedCompaniesArray.sort(by: { $0.title < $1.title })
            let userDefaults = UserDefaults.standard
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: selectedCompaniesArray)
            print("encoded data",encodedData)
            userDefaults.set(encodedData, forKey: "SelectedComp")
            
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            self.tblCompanies.reloadRows(at: [indexPath], with: UITableView.RowAnimation.right)
            btnSelectedCompany.setTitle("\(selectedCompaniesArray.count)", for: UIControl.State())
            companyObjects.remove(at: indexPath.row)
            tblCompanies.reloadData()
            
        case tblSearchCompanies:
            
            let company = companyObjectsForSearch[indexPath.row]
            company.isSelected = true
            selectedCompaniesArray.append(company)
            selectedCompaniesArray.sort(by: { $0.title < $1.title })
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            self.tblSearchCompanies.reloadRows(at: [indexPath], with: UITableView.RowAnimation.right)
            btnSelectedCompany.setTitle("\(selectedCompaniesArray.count)", for: UIControl.State())
            companyObjectsForSearch.remove(at: indexPath.row)
            tblSearchCompanies.reloadData()
            
        case tblSelectedCompanies:
            
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            self.tblSelectedCompanies.reloadRows(at: [indexPath], with: UITableView.RowAnimation.left)
            selectedCompaniesArray.remove(at: indexPath.row)
            btnSelectedCompany.setTitle("\(selectedCompaniesArray.count)", for: UIControl.State())
            tblSelectedCompanies.reloadData()
            tableviewNeedsUpdate = true
            
        default:
            
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case tblCompanies:
            
            if companyObjects.count > 7 {
                
                if nextPageURL.characters.count > 0 {
                    
                    
                    if indexPath.row + 1 == companyObjects.count {
                        
                        if !rechability.isConnectedToNetwork() {
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblCompanies.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            let companyModel = WLLoadMoreCompanyList()
                            companyModel.nextPageURL = nextPageURL
                            companyModel.loadMoreCompanies({(Void, AnyObject) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                let response = AnyObject as! [String: AnyObject]
                                self.nextPageURL = ""
                                self.nextPageURL = response["next"] as! String
                                if let companies = response["results"] as? [[String: AnyObject]] {
                                    
                                    for company in companies {
                                        
                                        let id = company["id"] as? Int ?? 0
                                        let slug = company["slug"] as? String ?? ""
                                        let date_created = company["date_created"] as? String ?? ""
                                        let date_changed = company["date_changed"] as? String ?? ""
                                        let title = company["title"] as? String ?? ""
                                        let profile_image_url = company["profile_image_url"] as? String ?? ""
                                        let type = company["type"] as? String ?? ""
                                        let primary_role = company["primary_role"] as? String ?? ""
                                        let unique_thirdparty_ref = company["unique_thirdparty_ref"] as? String ?? ""
                                        let short_description = company["short_description"] as? String ?? ""
                                        let funding_round_name = company["funding_round_name"] as? String ?? ""
                                        let crunchbase_url = company["crunchbase_url"] as? String ?? ""
                                        let homepage_url = company["homepage_url"] as? String ?? ""
                                        let facebook_url = company["facebook_url"] as? String ?? ""
                                        let twitter_url = company["twitter_url"] as? String ?? ""
                                        let linkedin_url = company["linkedin_url"] as? String ?? ""
                                        let stock_symbol = company["stock_symbol"] as? String ?? ""
                                        let location_city = company["location_city"] as? String ?? ""
                                        let location_region = company["location_region"] as? String ?? ""
                                        let location_country_code = company["location_country_code"] as? String ?? ""
                                        
                                        let companyDetail = CompanyObject(id: id, slug: slug, date_created: date_created, date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: false)
                                        
                                        if self.selectedCompaniesArray.count > 0 {
                                            
                                            var totalIds = [Int]()
                                            for comp in self.selectedCompaniesArray {
                                                totalIds.append(comp.id!)
                                            }
                                            if !totalIds.contains(id) {
                                                self.companyObjects.append(companyDetail)
                                            }
                                        } else {
                                            
                                            self.companyObjects.append(companyDetail)
                                        }
                                    }
                                    
                                    self.tblCompanies.reloadData()
                                }
                                
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                print(NSError)
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                            })
                        } else {
                            
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                        }
                    }
                }
            }
            
        case tblSearchCompanies:
            
            if companyObjectsForSearch.count > 7 {
                
                if nextPageURLForSearch.characters.count > 0 {
                    
                    
                    if indexPath.row + 1 == companyObjectsForSearch.count {
                        
                        if !rechability.isConnectedToNetwork() {
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblSearchCompanies.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            let companyModel = WLLoadMoreCompanyList()
                            companyModel.nextPageURL = nextPageURLForSearch
                            companyModel.loadMoreCompanies({(Void, AnyObject) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                let response = AnyObject as! [String: AnyObject]
                                
                                self.nextPageURLForSearch = ""
                                self.nextPageURLForSearch = response["next"] as? String ?? ""
                                if let companies = response["results"] as? [[String: AnyObject]] {
                                    
                                    for company in companies {
                                        
                                        let id = company["id"] as? Int ?? 0
                                        let slug = company["slug"] as? String ?? ""
                                        let date_created = company["date_created"] as? String ?? ""
                                        let date_changed = company["date_changed"] as? String ?? ""
                                        let title = company["title"] as? String ?? ""
                                        let profile_image_url = company["profile_image_url"] as? String ?? ""
                                        let type = company["type"] as? String ?? ""
                                        let primary_role = company["primary_role"] as? String ?? ""
                                        let unique_thirdparty_ref = company["unique_thirdparty_ref"] as? String ?? ""
                                        let short_description = company["short_description"] as? String ?? ""
                                        let funding_round_name = company["funding_round_name"] as? String ?? ""
                                        let crunchbase_url = company["crunchbase_url"] as? String ?? ""
                                        let homepage_url = company["homepage_url"] as? String ?? ""
                                        let facebook_url = company["facebook_url"] as? String ?? ""
                                        let twitter_url = company["twitter_url"] as? String ?? ""
                                        let linkedin_url = company["linkedin_url"] as? String ?? ""
                                        let stock_symbol = company["stock_symbol"] as? String ?? ""
                                        let location_city = company["location_city"] as? String ?? ""
                                        let location_region = company["location_region"] as? String ?? ""
                                        let location_country_code = company["location_country_code"] as? String ?? ""
                                        
                                        let companyDetail = CompanyObject(id: id, slug: slug, date_created: date_created, date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: false)
                                        
                                        if self.selectedCompaniesArray.count > 0 {
                                            
                                            var totalIds = [Int]()
                                            for comp in self.selectedCompaniesArray {
                                                totalIds.append(comp.id!)
                                            }
                                            if totalIds.contains(id) {
                                                
                                            } else {
                                                self.companyObjectsForSearch.append(companyDetail)
                                            }
                                        } else {
                                            
                                            self.companyObjectsForSearch.append(companyDetail)
                                        }
                                    }
                                    
                                    self.tblSearchCompanies.reloadData()
                                }
                                
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                print(NSError)
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                            })
                        } else {
                            
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                        }
                    }
                }
            }
            
        default:
            
            break
        }
    }
    
}
