package main

import (
	"database/sql"
	"io"
	"io/ioutil"
	"log"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB

var (
	Trace   *log.Logger
	Info    *log.Logger
	Warning *log.Logger
	Error   *log.Logger
)

func InitLogger(
	traceHandle io.Writer,
	infoHandle io.Writer,
	warningHandle io.Writer,
	errorHandle io.Writer) {

	Trace = log.New(traceHandle,
		"TRACE: ",
		log.Ldate|log.Ltime|log.Lshortfile)

	Info = log.New(infoHandle,
		"INFO: ",
		log.Ldate|log.Ltime|log.Lshortfile)

	Warning = log.New(warningHandle,
		"WARNING: ",
		log.Ldate|log.Ltime|log.Lshortfile)

	Error = log.New(errorHandle,
		"ERROR: ",
		log.Ldate|log.Ltime|log.Lshortfile)
}

func main() {

	db, _ = sql.Open("mysql", "root:root@(localhost:8889)/music")
	InitLogger(ioutil.Discard, os.Stdout, os.Stdout, os.Stderr)

	r := gin.Default()
	r.GET("/playlist/:id", GetPlaylist)
	r.GET("/playlists", GetPlaylists)
	// r.GET("/artists", GetArtists)
	// r.GET("/artists/:id/albums", GetArtistAlbums)
	r.GET("/tracks", GetTracks)
	r.GET("/tracks/:id", GetTrack)
	r.PUT("/playlist/:playlist_id/track/:track_id", InsertTrackToPlaylist)
	r.DELETE("/tracks/:id", DeleteTrack)
	r.POST("/tracks", AddTrack)
	r.Run() // listen and serve on 0.0.0.0:8080

	defer db.Close()
}

func GetPlaylist(c *gin.Context) {
	playlistID, err := strconv.ParseInt(c.Params.ByName("id"), 0, 64)

	rows, err := db.Query("select p.id, p.name, t.id, t.name from playlists p join playlists_tracks pt on pt.playlist_id = p.id join tracks t on pt.track_id = t.id where p.id= ?", playlistID)

	playlist := new(Playlist)
	playlist.Tracks = make([]Track, 0, 8)

	for rows.Next() {
		track := new(Track)

		err = rows.Scan(&playlist.ID, &playlist.Name, &track.ID, &track.Name)
		playlist.Tracks = append(playlist.Tracks, *track)
	}

	if err != nil {
		c.JSON(500, gin.H{"error": err})
	} else {
		c.JSON(200, playlist)
	}
}

func GetTrack(c *gin.Context) {
	trackID, err := strconv.ParseInt(c.Params.ByName("id"), 0, 64)

	row := db.QueryRow("select t.id, t.name, al.id, al.name, al.cover, ar.id, ar.name  from tracks t join albums al on t.album_id = al.id join artists ar on ar.id = al.artist_id where t.id = ?", trackID)

	track := new(Track)
	album := new(Album)
	artist := new(Artist)

	err = row.Scan(&track.ID, &track.Name, &album.ID, &album.Name, &album.Cover, &artist.ID, &artist.Name)

	album.Artist = artist
	track.Album = album

	if err != nil {
		c.JSON(500, gin.H{"error": err})
	} else {
		c.JSON(200, track)
	}
}

func GetPlaylists(c *gin.Context) {
	rows, err := db.Query("select * from playlists")
	playlists := make([]Playlist, 0, 8)

	for rows.Next() {
		playlist := new(Playlist)

		err = rows.Scan(&playlist.ID, &playlist.Name)
		playlists = append(playlists, *playlist)
	}

	if err != nil {
		c.JSON(500, gin.H{"error": err})
	} else {
		c.JSON(200, playlists)
	}
}

// func GetArtists(c *gin.Context) {
// 	rows, err := db.Query("select * from artists")
// 	artists := make([]Artist, 0, 8)
//
// 	for rows.Next() {
// 		artist := new(Artist)
//
// 		err = rows.Scan(&artist.ID, &artist.Name)
// 		artists = append(artists, *artist)
// 	}
//
// 	if err != nil {
// 		c.JSON(500, gin.H{"error": err})
// 	} else {
// 		c.JSON(200, artists)
// 	}
// }

func GetTracks(c *gin.Context) {
	q := c.Request.URL.Query()
	var value string
	if len(q["search"]) > 0 {
		value = q["search"][0]
		Warning.Println("query is not empty" + value)
	}

	query := "select t.id, t.name, al.id, al.name, al.cover from tracks t join albums al on al.id = t.album_id"
	if value != "" {
		query = query + " where t.name like concat('%','" + value + "','%')"
	}

	Warning.Println("query is: " + query)

	rows, err := db.Query(query)

	tracks := make([]Track, 0, 8)

	for rows.Next() {
		track := new(Track)
		album := new(Album)

		err = rows.Scan(&track.ID, &track.Name, &album.ID, &album.Name, &album.Cover)

		track.Album = album

		tracks = append(tracks, *track)
	}

	if err != nil {
		c.JSON(500, gin.H{"error": err})
	} else {
		c.JSON(200, tracks)
	}
}

// func GetArtistAlbums(c *gin.Context) {
// 	artistID, err := strconv.ParseInt(c.Params.ByName("id"), 0, 64)
//
// 	rows, err := db.Query("select id, name from albums where albums.artist_id = ?", artistID)
// 	if err != nil {
// 		c.JSON(500, gin.H{"error": "error perfoming request"})
// 	}
//
// 	albums := make([]Album, 0, 8)
//
// 	for rows.Next() {
// 		album := new(Album)
//
// 		err = rows.Scan(&album.ID, &album.Name)
// 		albums = append(albums, *album)
// 	}
//
// 	if err != nil {
// 		c.JSON(500, gin.H{"error": "error scanning"})
// 	} else {
// 		c.JSON(200, albums)
// 	}
// }

func InsertTrackToPlaylist(c *gin.Context) {
	playlistID, err := strconv.ParseInt(c.Params.ByName("playlist_id"), 0, 64)
	trackID, err := strconv.ParseInt(c.Params.ByName("track_id"), 0, 64)

	_, err = db.Query("insert into playlists_tracks (playlist_id, track_id) values (?, ?)", playlistID, trackID)

	if err != nil {
		c.JSON(500, gin.H{"error": err})
	} else {
		c.JSON(200, gin.H{"success": true})
	}
}

func AddTrack(c *gin.Context) {
	var form TrackForm
	c.BindJSON(&form)

	_, err := db.Query("insert into tracks (name, album_id) values (?, ?)", form.Name, form.AlbumID)

	if err != nil {
		c.JSON(500, gin.H{"error": err})
	} else {
		c.JSON(200, gin.H{"success": true})
	}
}

func DeleteTrack(c *gin.Context) {
	trackID, err := strconv.ParseInt(c.Params.ByName("id"), 0, 64)

	_, err = db.Query("delete from tracks where id = ? ", trackID)

	if err != nil {
		c.JSON(500, gin.H{"error": err})
	} else {
		c.JSON(200, gin.H{"success": true})
	}
}

type Playlist struct {
	ID     int64   `json:"id"`
	Name   string  `json:"name"`
	Tracks []Track `json:"tracks,omitempty"`
}

type Artist struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

type Album struct {
	ID     int64   `json:"id"`
	Name   string  `json:"name"`
	Cover  string  `json:"cover"`
	Artist *Artist `json:"artist,omitempty"`
}

type Track struct {
	ID    int64  `json:"id"`
	Name  string `json:"name"`
	Album *Album `json:"album,omitempty"`
}

type TrackForm struct {
	Name    string `json:"name"`
	AlbumID int64  `json:"album_id"`
}
