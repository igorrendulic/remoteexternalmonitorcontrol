//
//  CommandViewController.swift
//  monitorcontrol
//
//  Created by Igor Rendulic on 1/11/20.
//  Copyright © 2020 Mailio. All rights reserved.
//

import UIKit

class CommandViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var monitor:Monitor?
    var inputSelections:[Command] = [Command]()
    var allCommands:CommandList?
//    var allCommands:CommandList = CommandList(input_source:[Command]?, monitor_power:[Command]?,speaker_power:[Command]?, speaker_volume:[Command]?)
    
    @IBOutlet weak var lblMonitorName:UILabel!
    @IBOutlet weak var pickerInputSelector:UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerInputSelector.delegate = self
        self.pickerInputSelector.dataSource = self

        // Do any additional setup after loading the view.
        self.lblMonitorName.text = monitor?.name
        
        CommandClient.getCommands {result in
            switch result {
            case .success(let commandList):
                self.allCommands = commandList
                self.inputSelections = commandList.input_source!
                self.pickerInputSelector.reloadAllComponents()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func setInputSource(_ sender: Any) {
        let index = self.pickerInputSelector.selectedRow(inComponent: 0)
        var inputSource = self.inputSelections[index]
        inputSource.monitor_id = self.monitor?.id
        self.executeCommand(command:inputSource)
    }
    
    @IBAction func monitorOnOff(sender: UISwitch) {
        let powerCommands = self.allCommands?.monitor_power
        if sender.isOn {
            for var comm in powerCommands ?? [] {
                if (comm.name.contains("On")) {
                    comm.monitor_id = self.monitor?.id
                    self.executeCommand(command:comm)
                    break
                }
            }
        } else {
            for var comm in powerCommands ?? [] {
                if (comm.name.contains("Off")) {
                    comm.monitor_id = self.monitor?.id
                    self.executeCommand(command:comm)
                    break
                }
            }
        }
    }
    
    @IBAction func muteChange(_ sender: UISwitch) {
        let muteCommands = self.allCommands?.speaker_power
        if sender.isOn {
        for var comm in muteCommands ?? [] {
                if (comm.name.contains("Un-Mute")) {
                    comm.monitor_id = self.monitor?.id
                    self.executeCommand(command:comm)
                    break
                }
            }
        } else {
            for var comm in muteCommands ?? [] {
                if (!comm.name.contains("Un-Mute")) {
                    comm.monitor_id = self.monitor?.id
                    self.executeCommand(command:comm)
                    break
                }
            }
        }
    }
    
    @IBAction func volumeChange(_ sender: UISlider) {
        print("volume change \(sender.value)")
        let sliderVolume = sender.value
        let volume = Int(round(sliderVolume * 254))
        print("new volume \(volume)")
        let volumeCommands = self.allCommands?.speaker_volume
        
        for var comm in volumeCommands ?? [] {
            comm.monitor_id = self.monitor?.id
            comm.number = volume
            self.executeCommand(command:comm)
            break
        }
    }
    
    func executeCommand(command:Command) {
        CommandClient.executeCommand(command:command){ result in
            switch result {
            case .success(let commandResponse):
                print(commandResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Input Picker
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.inputSelections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.inputSelections[row].name
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
