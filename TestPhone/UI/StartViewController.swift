//
//  StartViewController.swift
//  TestPhone
//
//  Created by Vitaliy Kozlov on 03/04/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import UIKit


class StartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactsTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let activityView = UIActivityIndicatorView(style: .whiteLarge)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsData.contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        if let dataCell = contactsData.contacts?[indexPath.row] {
            cell.configure(data: dataCell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callNumber (phoneNumber: contactsData.contacts?[indexPath.row].phone ?? "")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            contactsData.contacts?.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        if #available(iOS 10.0, *) {
            contactsTableView.refreshControl = refreshControl
        } else {
            contactsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление данных...")
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: notificatonName, object: nil)
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityView.center = self.view.center
        activityView.color = UIColor.darkGray
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    @objc func updateData() {
        getData()
    }
    
    @objc func updateTableView () {
        switch contactsData.error {
        case "JSONError":
            showAlert(alert: "Ошибка доступа к данным")
        case "Internet Error":
            showAlert(alert: "Проверьте соединение с Интернетом")
        default:
            contactsTableView.reloadData()
        }
        self.refreshControl.endRefreshing()
        self.activityView.stopAnimating()
    }
    
    private func callNumber(phoneNumber:String) {
        var phone = phoneNumber.replacingOccurrences(of: "+", with: "")
        phone = phone.replacingOccurrences(of: "-", with: "")
        phone = phone.replacingOccurrences(of: " (", with: "")
        phone = phone.replacingOccurrences(of: ") ", with: "")
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: notificatonName, object: nil)
    }
}

extension StartViewController {
    func showAlert (alert : String) {
        let alert = UIAlertController(title: "Внимание!", message: alert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
