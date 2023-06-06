//
//  DBManager.swift
//  Day6Lab1OnlineMovieList
//
//  Created by Hossam on 10/05/2023.
//

import Foundation

import SQLite3
import UIKit
import CoreData

class DBManager{
    static let sharedMovieDB = DBManager()
    static let favoritesDB = DBManager()
    
    var title: String? = nil
    var rating: Double? = nil
    var releaseDate: Int? = nil
    var genere: String? = nil
    var movieImg: String? = nil
    var arrayOfMovies: Array<Item> = []
    var nsManagedMovies : [NSManagedObject] = []
    let manager : NSManagedObjectContext!
    let entity: NSEntityDescription!
    let favEntity: NSEntityDescription!
    
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manager = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "MovieEntity2", in: manager)
        favEntity = NSEntityDescription.entity(forEntityName: "FavoriteEntity", in: manager)
    }
    
    func insertToFav(movie: Item){
        insert(newMovie: movie, entity: favEntity)
    }
    func insertToHome(movie: Item){
        insert(newMovie: movie, entity: entity)
    }
    
    func insert(newMovie: Item, entity: NSEntityDescription){
        
        let movie = NSManagedObject(entity: entity, insertInto: manager)
        
        movie.setValue(newMovie.header, forKey: "header")
        movie.setValue(newMovie.id, forKey: "id")
        movie.setValue(newMovie.rank, forKey: "rank")
        movie.setValue(newMovie.image, forKey: "image")
        movie.setValue(newMovie.gross, forKey: "gross")
        movie.setValue(newMovie.weeks, forKey: "weeks")
        movie.setValue(newMovie.weekend, forKey: "weekend")
        
        do{
            try manager.save()
            print("saved")
        }catch let error as NSError{
            print(error)
        }
    }
    
    func getHomeMovies()-> Array<Item>?{
        return getAllMoviesQuery(entityName: "MovieEntity2")
    }
    
    func getFavMovies()-> Array<Item>?{
        return getAllMoviesQuery(entityName: "FavoriteEntity")
    }
    
    func getAllMoviesQuery(entityName: String)-> Array<Item>?{
        arrayOfMovies = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do{
            print(nsManagedMovies.count)
            nsManagedMovies = try manager.fetch(fetchRequest)
            print(nsManagedMovies.count)
            for (_, item) in nsManagedMovies.enumerated(){
                
                let movieObj: Item = Item()
                movieObj.id = item.value(forKey: "id") as? String
                movieObj.header = item.value(forKey: "header") as? String
                movieObj.rank = (item.value(forKey: "rank") as? String)
                movieObj.image = (item.value(forKey: "image") as! String)
                movieObj.weekend = (item.value(forKey: "weekend") as! String)
                movieObj.gross = (item.value(forKey: "gross") as! String)
                movieObj.weeks = (item.value(forKey: "weeks") as! String)
                arrayOfMovies += [movieObj]
            }
            print(arrayOfMovies.count)
            return arrayOfMovies
        }catch let error as NSError{
            print(error)
            return []
        }
    }
    
    func deleteFromHome(id: String){
        getHomeMovies()
        deleteMovie(id: id)
    }
    func deleteFromFav(id: String){
        getFavMovies()
        deleteMovie(id: id)
    }
    
    
    func deleteMovie(id: String) {
        for (index, element) in nsManagedMovies.enumerated(){
            let deletedID = element.value(forKey: "id") as? String
            if deletedID == id {
                arrayOfMovies.remove(at: index)
                manager.delete(element)
                break
            }
        }
        do{
            
            try manager.save()
            print("Deleted!")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func deleteAll() {
        getHomeMovies()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity2")
        
        do{
            nsManagedMovies = try manager.fetch(fetchRequest)
        }
        catch let error as NSError{
            print(error)
        }
        
        for element in nsManagedMovies{
            manager.delete(element)
        }
        
        do{
            
            try manager.save()
            print("Deleted!")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
}

