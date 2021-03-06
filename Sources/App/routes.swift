import Fluent
import Vapor
import PythonKit

func Pythonsetup(){
    
}


func routes(_ app: Application) throws {
    app.routes.defaultMaxBodySize = "100mb"
    
    try app.register(collection: ListMovieController()) //片單內容
    try app.register(collection: ListController())      //片單
    try app.register(collection: CommentController())   //文章留言
    try app.register(collection: ArticleController())   //討論區文章
    try app.register(collection: MovieAPIController())  //電影資訊
    try app.register(collection: UserController())      //登入註冊
    try app.register(collection: UserPhotoController()) //使用者大頭貼
    try app.register(collection: LikeMovieController()) //喜好的電影
    try app.register(collection: LikeArticleController()) //喜好的文章
    try app.register(collection: APIController())     //API stuff
    
    
    
    //Check connection
    app.get("ping"){req -> ServerStatus in
        return ServerStatus(status: "Online", code: 200)
    }
}


struct Movies : Content {
    let results : [MovieInfo]
}

struct ServerStatus : Content{
    let status : String
    let code : Int
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
