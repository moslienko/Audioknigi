//
//  EditCharterViewController.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 08/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class EditCharterViewController: UIViewController {

    @IBOutlet weak var nameCharter: UITextField!
    @IBOutlet weak var urlCharter: UITextField!
    @IBOutlet weak var numberCharter: UITextField!
    
    var charterInfo = [Charter]()
    var bookID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if charterInfo.count > 0 {
            let data = charterInfo[0]
            
            self.navigationItem.title = data.name

            nameCharter.text = data.name
            urlCharter.text = String(describing: data.url)
            numberCharter.text = String(describing:data.number + 1) //Отсчет в базе идет с нуля
        }
        else {
            self.navigationItem.title = "Add new charter"
            numberCharter.text = String(describing: getChartersForBookID(self.bookID).count+1)
        }
        /* Главу редактировать нельзя что бы не создавать конфликтов в core data.
         Предполагается что создание новых глав будет происходить последовательно, с #1 */
        numberCharter.isEnabled = false
    }

    @IBAction func saveCharter(_ sender: UIBarButtonItem) {
        let name = nameCharter.text
        let url = NSURL(string: urlCharter.text ?? "www.google.com")
        
        let number = Int(numberCharter.text!)!-1
        
        let duration = ""
        if isValidSoundURL(url! as URL) {
            
            if charterInfo.count > 0 {
                //Обновить
                var data = charterInfo[0]
                
                data.name = name ?? "Charter name"
                data.number = number
                data.url = url! as URL
                
                print ("update data:", data)
                
                if updateCharter(charterInfo: data) {
                    navigationController?.popViewController(animated: true)
                }
            }
            else {
                //Создать
                let data = Charter.init(
                    number: number,
                    bookID: self.bookID,
                    name: name ?? "Charter name",
                    duration: duration,
                    url: url! as URL)
                
                print ("save data:", data)
                
                if saveCharters(charterData: data) {
                    navigationController?.popViewController(animated: true)
                }
            }
            
        }
        else {
            //todo сообщение о неправильном url
            print ("false url")
        }
        
    }
}
