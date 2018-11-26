//
//  AudioBooks.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 24/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import SwiftSoup

struct Audio {
    var name: String //Название главы
    var time: String // Продолжительность
}

/**
 Получить HTML содержимое страницы
 - Parameter url: URL страницы
 - Returns: Строка, содержащая код страницы
 */
func getHTMLContent(url:URL) -> String {
    do {
        let html = try String(contentsOf: url, encoding: .utf8)
        return html
    }
    catch {
        return ""
    }
}

/**
 Получить список глав аудио книги
 - Parameter url: URL страницы
 - Returns: Строка, содержащая код страницы
 */
func getCharterBook(url:URL) -> [Audio] {
    var audioList = [Audio]()
    
    do {
        
        let html = getHTMLContent(url: url)
        if html != "" {
            let doc: Document = try SwiftSoup.parse(html)
            
            let playlistDiv: Element = try doc.select("div.book_player_playlist").first()!
            let playlistItem: Elements = try playlistDiv.select("div.book_player_playlist_item")

            for i in playlistItem.enumerated() {
                audioList.append(Audio(
                    name: try i.element.select("div.book_player_playlist_item_name").first()!.text(),
                    time: try i.element.select("div.book_player_playlist_item_time").first()!.text()
                ))
            }
            
            return audioList
        }
        
    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    
    return audioList
}

/**
 Получить идентификатор аудиокниги
 - Parameter imageURL: src обложки книги
 - Returns: ID книги
 */
func parceID(imageURL:String) -> String {
    let url = imageURL.components(separatedBy: "/")
    
    if (url.count) > 0 {
        let idBook = url[5]
        
        return idBook
    }
    
    return ""
}

/**
 Получить информацию об аудиокниге по url
 - Parameter url: URL адрес
 - Returns: Информация о книги
 */
func getBookInfoFromURL(_ url:URL) ->AudioBooks? {
    do {
        print (url)
    let html = getHTMLContent(url: url)
 
    if html != "" {
        print (html)

        let doc: Document = try SwiftSoup.parse(html)
        let coverURL = try doc.select("div.book_about_cover").first()?.child(0).attr("src")
        
        if coverURL != nil {
            //Получение обложки
            var cover = Data()
            if coverURL != nil {
                if let url = NSURL(string: coverURL!) {
                    if let data = NSData(contentsOf: url as URL) {
                        cover = data as Data
                    }
                }
            }
            //Получение ID
            let id = parceID(imageURL: coverURL!) //ID аудиокниги
                if id != "" {
                    let bookInfo = AudioBooks.init(
                        id: id,
                        image: cover,
                        name: try doc.select("div.book_title").first()!.text(),
                        url:url,
                        charter: 0,
                        time: 0
                    )
                    
                    return bookInfo
                }
            }
        }
        
    } catch Exception.Error( _, let message) {
        print(message)
    } catch {
        print("error")
    }
    
    return nil
}
