import Fluent
import Vapor
import PythonKit

func Pythonsetup(){
    
}


func routes(_ app: Application) throws {
    try app.register(collection: ListMovieController()) //片單內容
    try app.register(collection: ListController())      //片單
    try app.register(collection: CommentController())   //文章留言
    try app.register(collection: ArticleController())   //討論區文章
    try app.register(collection: UserController())      //登入註冊
    try app.register(collection: APIController())     //API stuff
}


struct Movies : Content {
    let results : [MovieInfo]
}



struct MovieInfo : Content{
    let id : Int
    let title : String
    let genre_ids : [Int]
    let adult: Bool
    let backdrop_path: String
    let original_language: String
    let original_title: String
    let overview: String
    let popularity : Float
    let poster_path: String
    let release_date: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}
