//
//  PlayerURL.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 26/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation

enum urlGenerateAlgorithm {
    case native //Кодировать кириллицу
    case latin  //Транслитерация
}

class playerURL {
    var bookID:String = ""  //ID аудиокниги
    var charterName:String = "" //Название главы
    
    var currentUrlStr: URL = URL.init(string: "google.com")! //URL текущей главы книги
    var storagePath:Int = 0 //Сервер хранилища используется
    var extraStoragePath:Int = 0 //На сервере

    var urlAlgorithm = urlGenerateAlgorithm.native //Каким способом получать url
    
    /**
     Генерация URL, в котором присутствует кириллица
     - Returns: URL для доступа к файлу
     */
    func generateCyrillicURL() -> URL {
        let url = "https://s\(self.storagePath).knigavuhe.org/\(self.extraStoragePath)/audio/\(self.bookID)/\(self.charterName).mp3"
        //Кодирование
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let urlBook = URL.init(string: encodedURL!)
        
        if urlBook != nil {
            return urlBook!
        }
        return URL.init(string: "google.com")!
    }
    
    /**
     Генерация URL, в котором кириллица заменяется на транслит
     - Returns: URL для доступа к файлу
     */
    func generateLatinURL() -> URL {
        //Транслит
        let latinString = self.charterName.applyingTransform(StringTransform.toLatin, reverse: false)
        let latinURL = latinString?.applyingTransform(StringTransform.stripDiacritics, reverse: false)
        //Убирает пробелы
        let latinUrlWithoutSpaces = latinURL?.replacingOccurrences(of: " ", with: "")

        //let latinUrlWithoutSpaces = latinURL?.replacingOccurrences(of: " ", with: "-")
        //Заменяет символ _
        let latinUrlWithoutSymbol = latinUrlWithoutSpaces?.replacingOccurrences(of: "_", with: "-")
        //Без заглавных букв
        let latinUrl = latinUrlWithoutSymbol?.lowercased()
        //Итоговый путь
        let urlLatin = "https://s\(self.storagePath).knigavuhe.org/\(self.extraStoragePath)/audio/\(self.bookID)/\(String(describing: latinUrl!)).mp3"
        //Создание URL
        let urlBookLatin = URL.init(string: urlLatin)
        
        //print ("latinString: \(String(describing: latinString)) latinURL: \(latinURL) latinUrl: \(String(describing: latinUrl)) urlLatin:\(urlLatin)")
        
        if urlBookLatin != nil {
            return urlBookLatin!
        }
        return URL.init(string: "google.com")!
    }
    /**
     Генерация ссылки в различных вариантах
     - Returns: Ссылки к файлу (в дальнейшем проверяется рабочик ли они)
     */
    func encodeAudioURL() -> (native:URL, latin:URL) {
        return (native:generateCyrillicURL(), latin:generateLatinURL())
    }
    
    struct checkURLElement {
        var storagePath:Int
        var extraStoragePath:Int
        var native: URL
        var latin: URL
    }
    
    /**
     Получение доступа к файлу книги
     
     Файлы хранятся на различных серверах. Проверяется каждый сервер.
     Есть два варианта в url - полное название файла или его транслитерация на латиницу
     Проверяются оба варианта.
     
     - Returns: Статус выполнения операции
     */
    func checkAudioURL() -> Bool {
        var urls = [checkURLElement]()
        
        for i in 1...6 {
            self.storagePath = i
            for j in 1...3 {
                self.extraStoragePath = j
                let encodeURL = encodeAudioURL()
                
                urls.append(checkURLElement.init(
                    storagePath: i,
                    extraStoragePath: j,
                    native: encodeURL.native,
                    latin: encodeURL.latin
                ))
            }
        }
            print ("urls:",urls)
            
            for url in urls {
                    if url.native != URL.init(string: "google.com") {
                        print ("we check:",url)
                        if isValidSoundURL(url.latin) {
                            self.urlAlgorithm = .latin
                            self.currentUrlStr = url.latin
                            self.storagePath = url.storagePath
                            self.extraStoragePath = url.extraStoragePath
                          
                            return true
                        }
                        if isValidSoundURL(url.native) {
                            self.urlAlgorithm = .native
                            self.currentUrlStr = url.native
                            
                            self.storagePath = url.storagePath
                            self.extraStoragePath = url.extraStoragePath
                  
                            return true
                        }
            }
                

        }
        return false
    }

}


/**
 Проверка, существует ли файл по указанному адресу
 - Parameter url: URL файла
 - Returns: Результат проверки
 */
func isValidSoundURL(_ url: URL) -> Bool {
    let semaphore = DispatchSemaphore(value: 0)
    
    var result = false

    let urlconfig = URLSessionConfiguration.default
    //Не скачивать файл, секунда для получения статус кода
    urlconfig.timeoutIntervalForRequest = 1.0
    urlconfig.timeoutIntervalForResource = 1.0
    let session = URLSession(configuration: urlconfig)
 
    let task = session.dataTask(with: url) {(_, response, error) in
        if response != nil {
            let code = (response as! HTTPURLResponse).statusCode
            print("For url \(url) code is \(code)")
            if code == 200 {
                result = true
            }
            semaphore.signal()
        }
        else {
            semaphore.signal()
        }
        
    }
    
    task.resume()
    semaphore.wait()
    
    return result
}
