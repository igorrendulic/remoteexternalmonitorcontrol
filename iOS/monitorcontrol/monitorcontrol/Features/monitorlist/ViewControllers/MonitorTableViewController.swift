//
//  MonitorTableViewController.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/10/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import UIKit
import MMLanScan
import Alamofire
import SwiftyJSON


class MonitorTableViewController: UITableViewController, MMLANScannerDelegate {

    
    @IBOutlet weak var progressView: UIProgressView!
    
    var allMonitors = [Monitor]()
    
    var lanScanner : MMLANScanner!
    dynamic var connectedDevices:[MMDevice]!
    dynamic var isScanRunning : BooleanLiteralType = false
    dynamic var progressValue : Float = 0.0
    
    var productionServerURL:String = ""
    
    private var myContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        self.connectedDevices = [MMDevice]()
        
        self.isScanRunning = false
        
        self.lanScanner = MMLANScanner(delegate:self)
        
        if (!self.isScanRunning) {
            self.lanScanner.start()
        }
    }
    
    func checkIfServerInReach() {
        if (K.ProductionServer.baseURL.contains("unknown")) {
            if (!self.isScanRunning) {
                self.lanScanner.start()
            }
        } else {
            let parameters = ["ip":K.ProductionServer.baseURL]
            AF.request(K.ProductionServer.baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
                response in
                switch response.result {
                case .success(let pong):
                    print(pong)
                case .failure(let error):
                    print(error.localizedDescription)
                    if (!self.isScanRunning) {
                        self.lanScanner.start()
                   }
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allMonitors.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonitorCell", for: indexPath) as! MonitorViewCell

        cell.monitorName.text = self.allMonitors[indexPath.row].name
        cell.monitorImage.image = UIImage(named: "tv")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Monitors"
    }
    
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "monitorCommandSegue",sender:self)
    }

    // MARK: - MLLScan Delegate methods
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        if (!self.connectedDevices.contains(device)) {
            // not seen before
            let callingIP = String(device.ipAddress)
            let parameters = ["ip":callingIP]
            AF.request("http://" + callingIP + ":7800/ping", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
                response in
                switch response.result {
                case .success(let pong):
                    let obj = JSON(pong)
                    let ip = obj["ip"].stringValue
                    K.ProductionServer.baseURL = "http://" + ip + ":7800"
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.connectedDevices?.append(device)
        }
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        self.isScanRunning = false
        self.progressValue = 0.0
        self.progressView.progress = 0.0
        
        print("This is the server we're connecting to: ", K.ProductionServer.baseURL)
        
        MonitorClient.getMonitors {result in
            switch result {
            case .success(let monitors):
                print(monitors)
                self.allMonitors = monitors
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func lanScanDidFailedToScan() {
        self.isScanRunning = false
        self.progressValue = 0.0
        self.progressView.progress = 0.0
    }
    
    func lanScanProgressPinged(_ pingedHosts: Float, from overallHosts: Int) {
       
        //Updating the progress value. MainVC will be notified by KVO
        self.progressValue = pingedHosts / Float(overallHosts)
        self.progressView.progress = self.progressValue
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "monitorCommandSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! CommandViewController
                controller.monitor = self.allMonitors[indexPath.row]
            }
        }
    }
    
    //MARK: - Deinit
    deinit {
    }
    
}
