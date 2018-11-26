//
//  Player.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 25/11/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
 Сохранить книгу как последнюю прослушанную
 - Parameter id: Идентификатор книги
 */
func saveAsLastBook(id:String) {
    UserDefaults.standard.set(id, forKey: "lastBookID")
}

/**
 Получить идентификатор последней прослушанной книги
 - Returns: ID аудиокниги
 */
func getLastBookID() -> String {
    return UserDefaults.standard.string(forKey: "lastBookID") ?? ""
}

/**
 Получить информацию о посленей прослушиваемой книги
 - Returns: Данные о книги
 */
func getLastBook() -> [AudioBooks]{
    let book = [AudioBooks]()
    
    let bookID = getLastBookID()
    if bookID != "" {
        return getAudioBookWithID(bookID)
    }
    
    return book
}

/**
 Сохранить сведения о прослушиваемой книги. (Например при паузе)
 - Parameter id: Идентификатор книги
 - Parameter charter: Номер главы
 - Parameter time: Время остановки
 - Returns: Статус выполнения операции
 */
func savePlayer(id:String,charter:Int, time:Float) -> Bool{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Books")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do
    {
        let book = try managedContext.fetch(fetchRequest)

        let objectUpdateBook = book[0] as! NSManagedObject
        objectUpdateBook.setValue(charter, forKey: "charter")
        objectUpdateBook.setValue(time, forKey: "time")

        do{
            try managedContext.save()
            return true
        }
        catch
        {
            print(error)
            return false
        }
    }
    catch
    {
        print(error)
        return false
    }
}
