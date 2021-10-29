//
//  File.swift
//  
//
//  Created by Jackson on 7/10/2021.
//

import Foundation
import Fluent
import Vapor
import FluentPostgresDriver

final class PlaygroundController {
    private let genreURI = "/genre/movie/list"
    
    //this will change to load data form our database
    func getActor(req: Request) throws -> EventLoopFuture<[PersonInfo]>{
        // //getting a page number to get the data
        guard let maxItem = Environment.process.PAGE_PER_ITEM else{
            throw Abort(.internalServerError,reason: "INTERNAL ERROR")
        }
        guard  let page = (try? req.query.get(Int.self, at: "page") as Int) else {
            throw Abort(.badRequest,reason: "PAGE MUST BE A POSITIVE NUMBER")
        }

        guard let maxNum = Int(maxItem) else{
            throw Abort(.internalServerError)
        }
        //start at lower to upper
        let lower = (page - 1) * maxNum
        let hight = page * maxNum - 1

        return PersonInfo.query(on: req.db).filter(\.$department == "Acting").range(lower: lower, upper: hight).all()
    }

    //http://127.0.0.1:8080/api/playground/getDirector?page=1s
    func getDirector(req : Request) throws -> EventLoopFuture<[PersonInfo]>{
        guard let maxItem = Environment.process.PAGE_PER_ITEM else{
            throw Abort(.internalServerError,reason: "INTERNAL ERROR")
        }

        // guard let maxNum = Int(maxItem) else{
        //    throw Abort(.internalServerError,reason: "INTERNAL ERROR")
        // }

        let page = abs((try? req.query.get(Int.self, at: "page") as Int) ?? 1 )//default 1
        let pageOffset = 10
        let offset = (page - 1) * pageOffset //if the page is 1 => offset 0 
        let postSQL = (req.db as! PostgresDatabase).sql()

        let sql = """
        SELECT person_infos.adult,person_infos.gender,person_infos.id,person_infos.name,person_infos.popularity,person_infos.profile_path,crews.department 
        FROM (SELECT person_id , department FROM person_crews WHERE department = 'Directing' 
        GROUP BY (person_id,department)) AS crews INNER JOIN person_infos ON person_infos.id =  crews.person_id ORDER BY person_id ASC LIMIT \(maxItem) OFFSET \(offset)
        """
        // print(sql)
        return postSQL.raw(SQLQueryString(sql)).all(decoding: PersonInfo.self)
    }

    func getGenre(req : Request) throws ->  String {
        //join 2 table -> this will
        // let api = APIGenreResponse(id:1)
        return ""

    }


    

    // func getActor(req: Request) throws -> EventLoopFuture<[Person]>{
    //     //return a person source
    //     //send request to tmdb and fetching the person data
    //     guard let apiKey = Environment.process.TMDB_API_KEY else{
    //         throw Abort(.serviceUnavailable,reason:"API KEY ERROR")
    //     }

    //     guard let host = Environment.process.TMDB_DOMAIN_NAME else{
    //         throw Abort(.serviceUnavailable,reason:"DOMAIN NOT FOUND")
    //     }

    //     let page = (try? req.query.get(Int.self, at: "page") as Int) ?? 1
        
    //     let client = req.client
    //     let uri = "\(host)/person/popular?api_key=\(apiKey)&en-US&page=\(page)"
    //     return  client.get(URI(string: uri)).flatMapThrowing{ res -> [Person] in
    //         do{
    //             let personInfo = try res.content.decode(personResult.self)
    //             let personRes = personInfo.results
    //             var personsData : [Person] = []
    //             for person in personRes {
    //                 if person.known_for_department != nil && person.known_for_department == "Acting"{
    //                     //the info is about actor
    //                     //append to the list
    //                     var modifyData = person
    //                     modifyData.known_for = []
    //                     personsData.append(modifyData)
                        
    //                 }
    //             }
    //             return personsData
                
    //         }catch{
    //             throw Abort(.badRequest,reason:"API Error!")
    //         }
    //     }
        
    // }
    
    //this will change to load data form our database
    // func getGenre(req : Request) throws ->  EventLoopFuture<[DragGenreData]> {
    //     /*TODO:
    //      before getting in, we need some algorithmn .....
    //      just getting data and combine data and return
    //      PROCESS: get All genre(futrue) -> fetch data from anthore api(desscription image)(future)
    //      */
    //     guard let apiKey = Environment.process.TMDB_API_KEY else{
    //         throw Abort(.serviceUnavailable,reason:"API KEY ERROR")
    //     }

    //     guard let host = Environment.process.TMDB_DOMAIN_NAME else{
    //         throw Abort(.serviceUnavailable,reason:"DOMAIN NOT FOUND")
    //     }


    //     let client = req.client
    //     let genreURI = "\(host)/genre/movie/list?api_key=\(apiKey)&language=en-US"
        
    //     return client.get(URI(string: genreURI)).flatMap{ res -> EventLoopFuture<[DragGenreData]> in
    //         do{
    //             let resData = try res.content.decode(Genre.self)
    //             let genreInfo = resData.genres
    //             var genreMovieResults : [EventLoopFuture<SpecifyGenreMovieResult>] = []
    // //
    //             for info in genreInfo {
    //                 let uri = "\(host)/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&page=1&with_genres=\(info.id)"
    //                 let movieInfoFuture = client.get(URI(string: uri)).flatMapThrowing{infoRes -> SpecifyGenreMovieResult in
    //                     return try infoRes.content.decode(SpecifyGenreMovieResult.self) //try to decode content ->body to our model
    //                 }
    //                 genreMovieResults.append(movieInfoFuture)
    //             }
                
    //            return genreMovieResults.flatten(on: req.eventLoop).map{info -> [DragGenreData] in
    //                 var dragResult : [DragGenreData] = []
    //                 for i in 0..<info.count{
    //                     let result = DragGenreData(info: genreInfo[i], describeImg: info[i].results.randomElement()!.poster_path)
    //                     dragResult.append(result)
    //                 }
    //                 return dragResult
    //             }
    //         } catch{
    //             return req.eventLoop.makeFailedFuture(error)
    //         }
    //     }
    // }
    
    // func getDirector(req : Request) throws -> EventLoopFuture<[Person]>{
    //     guard let apiKey = Environment.process.TMDB_API_KEY else{
    //         throw Abort(.serviceUnavailable,reason:"API KEY ERROR")
    //     }

    //     guard let host = Environment.process.TMDB_DOMAIN_NAME else{
    //         throw Abort(.serviceUnavailable,reason:"DOMAIN NOT FOUND")
    //     }

    //     let page = (try? req.query.get(Int.self, at: "page") as Int) ?? 1
    //     let client = req.client
    //     let uri = "\(host)/person/popular?api_key=\(apiKey)&en-US&page=\(page)"
    //     return client.get(URI(string: uri)).flatMapThrowing{res -> [Person] in
    //         do{
    //             let personsInfo = try res.content.decode(personResult.self)
    //             let personResults = personsInfo.results
    //             var director : [Person] = []
    //             for info in personResults{
    //                 if info.known_for_department != nil && info.known_for_department == "Art" {
    //                     var modifyData = info
    //                     modifyData.known_for = []
    //                     director.append(modifyData)
    //                 }
    //             }
    //             return director
    //         }catch{
    //             throw Abort(.badRequest,reason:"API Error!")
    //         }
    //     }
    // }

    func getPreviewResult(req : Request) throws -> String{
        //this route will only send 1 result ,account to provided data
        return "result route is coming soon..."
    }

    func getMorePreviewResult(req : Request) throws -> String{
        //this route will send all the avaliable results
        return "more result route is coming soon..."
    }

    // func getTestMovie(req : Request) throws -> EventLoopFuture<[MovieCharacter]>{
    //     //join
    //     let personID : Int = 258
    //     return PersonInfo.query(on: req.db)
    //         .join(MovieCharacter.self, on: \MovieCharacter.$id == \PersonInfo.$id)
    //         .with(\.$person)
    //         .filter(\.$person.$id ,.equal,personID)
    //         .all()
            
    // }
}

//Grag items
struct GenreData : Content {
    let id : Int
    let name : String
}

struct Genre : Content{
    let genres : [GenreData]
}

struct DragGenreData : Content {
    let info : GenreData
    let describeImg : String //using any image which movie can describe this Genre (URL)
}

struct SpecifyGenreMovieResult: Content{
    let page : Int
    let results : [GenreMovieInfo]
}

struct GenreMovieInfo : Content{
    let poster_path : String
}


//Actor items


//director items
struct personResult : Content{
    let results : [Person]
}

struct Person: Content {
    let id:Int
    let name: String
    let known_for_department: String?
    let profile_path: String?
    var known_for: [knownFor]
}

struct knownFor: Content{
    let id: Int
    let title: String?      //電影名稱可能被放在title也可能被放在name
    let name: String?
    let poster_path: String?
}

struct MovieContent : Content{
    
}