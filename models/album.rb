require_relative('../db/sql_runner')
require_relative('artist')

class Album

  attr_accessor :title, :genre
  attr_reader :id, :artist_id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @genre = options["genre"]
    @artist_id = options["artist_id"].to_i
  end

  def save
    sql = "INSERT INTO albums (title, genre, artist_id)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@title, @genre, @artist_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def self.delete_all
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT*FROM albums"
    albums = SqlRunner.run(sql)
    return albums.map { |album| Album.new(album)}
  end

  def delete
    sql = "DELETE FROM albums WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE albums SET (title, genre) = ($1, $2)
    WHERE id = $3"
    values = [@title, @genre, @id]
    SqlRunner.run(sql, values)
  end

  def self.find(id_number)
    sql = "SELECT*FROM albums WHERE id = $1"
    values = [id_number]
    album = SqlRunner.run(sql, values)
    return nil if album.count == 0
    return Album.new(album[0])
  end

  def artist
    sql = "SELECT*FROM artists WHERE id = $1"
    values = [@artist_id]
    artist = SqlRunner.run(sql, values)
    return Artist.new(artist[0])
  end

end
