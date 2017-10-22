//
//  SettingsViewController.swift
//  groov
//
//  Created by KimFeeLGun on 2016. 7. 7..
//  Copyright © 2016년 PilGwonKim. All rights reserved.
//

import UIKit
import MessageUI
import Kingfisher
import RealmSwift
import CWStatusBarNotification

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    @IBOutlet var dismissBarButton: UIBarButtonItem!
    @IBOutlet var mainTableView: UITableView!
    var notification: CWStatusBarNotification!
    
    struct Sections {
        struct Data {
            static let RemoveCache = "kDataRemoveCache"
            static let RemoveRealm = "kDataRemoveRealm"
            static let SaveToiCloud = "kDataSaveToiCloud"
            static let LoadFromiCloud = "kDataLoadFromiCloud"
        }
        struct Info {
            static let Version = "kInfoVersion"
            static let License = "kInfoLicense"
            static let SendMail = "kInfoSendMail"
            static let Facebook = "kInfoFacebook"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.setUpNotification()
        self.setNavigationBar()
        self.initComponents()
    }
    
    func setUpNotification() {
        self.notification = CWStatusBarNotification()
        self.notification.notificationLabelBackgroundColor = UIColor.white
        self.notification.notificationLabelTextColor = UIColor.black
    }
    
    func setNavigationBar() {
        // set navigation title text font
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        // set navigation clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = GRVColor.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func initComponents() {
        self.mainTableView.backgroundColor = GRVColor.backgroundColor
        self.dismissBarButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : GRVColor.mainTextColor, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], for: .normal)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 30, width: tableView.width-40, height: 15))
        switch section {
        case 0:
            titleLabel.text = "데이터"
        default:
            titleLabel.text = "앱 정보"
        }
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = GRVColor.mainTextColor
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingsCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = GRVColor.backgroundColor
        cell.contentView.backgroundColor = GRVColor.backgroundColor
        
        switch indexPath.section {
        case 0: // Sections.Data
            cell.accessoryType = .none
            switch indexPath.row {
            case 0: // Sections.Data.RemoveCache
                cell.textLabel?.text = "이미지 캐시 지우기"
            case 1: // Sections.Data.RemoveRealm
                cell.textLabel?.text = "폴더/비디오 지우기"
            case 2: // Sections.Data.RemoveSearchHistory
                cell.textLabel?.text = "검색 내역 지우기"
            case 3: // Sections.Data.SaveToiCloud
                cell.textLabel?.text = "Save Data to iCloud"
            default: // Sections.Data.LoadFromiCloud
                cell.textLabel?.text = "Load Data from iCloud"
            }
        default: // Sections.Info
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0: // Sections.Info.Version
                cell.textLabel?.text = "현재 버전 \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
                cell.accessoryType = .none
            case 1: // Sections.Info.SendMail
                cell.textLabel?.text = "문의 메일 보내기"
                cell.accessoryType = .disclosureIndicator
            default: // Sections.Info.Facebook
                cell.textLabel?.text = "페이스북 바로가기"
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0: // Sections.Data
            switch indexPath.row {
            case 0: // Sections.Data.RemoveCache
                self.clearCache()
            case 1: // Sections.Data.RemoveRealm
                self.clearRealm()
            case 2: // Sections.Data.RemoveSearchHistory
                self.clearSearchHistory()
            case 3: // Sections.Data.SaveToiCloud
                self.saveToiCloud()
            default: // Sections.Data.LoadFromiCloud
                self.loadFromiCloud()
            }
        default: // Sections.Info
            switch indexPath.row {
            case 0: // Sections.Info.Version
                self.goAppStore()
            case 1: // Sections.Info.SendMail
                self.sendMail()
            default: // Sections.Info.Facebook
                self.goFacebookPage()
            }
        }
    }
    
    func clearCache() {
        let cache = KingfisherManager.shared.cache
        cache.clearMemoryCache()
        cache.clearDiskCache {
            self.notification.display(withMessage: "이미지 캐시 삭제됨", forDuration: 1.5)
        }
    }
    
    func clearRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            self.notification.display(withMessage: "폴더/비디오 삭제됨", forDuration: 1.5)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clear_realm"), object: nil)
        }
    }
    
    func clearSearchHistory() {
    }
    
    func saveToiCloud() {
    }
    
    func loadFromiCloud() {
    }
    
    func goAppStore() {
    }
    
    func goLibrariesVC() {
    }
    
    func sendMail() {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["rlavlfrnjs12@gmail.com"])
        mailVC.setSubject("Service feedback for groov")
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error Occurred", message: "Cannot send mail", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func goFacebookPage() {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/AppGroov")!)
    }
    
    @IBAction func showSideMenu() {
        let center = NotificationCenter.default
        center.post(Notification(name: Notification.Name(rawValue: ContainerViewController.Notifications.toggleMenu), object: self))
    }
    
    @IBAction func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}