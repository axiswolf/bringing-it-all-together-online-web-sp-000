class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    # creates the dogs table in the database
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
    SQL
    DB[:conn].execute(sql)
  end

  def save
    # returns an instance of the dog class
    # saves an instance of the dog class to the database
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs(name, breed)
      VALUES(?, ?)
      SQL
      DB[:conn].execute(sql,self.name,self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.drop_table
    # drops the dogs table from the database
    sql = "DROP TABLE dogs;"
    DB[:conn].execute(sql)
  end

  def self.create(name:, breed:)
    # takes in a hash of attributes and uses metaprogramming to create a new dog object.
    # then it uses the #save method to save that dog to the database
    # returns a new dog object
    dog = Dog.new(name, breed)
    dog.save
    dog
  end
  def self.new_from_db(row)
    # creates an instance with corresponding attribute values
    them_dogs = self.new
    them_dogs.id = row[0]
    them_dogs.name = row[1]
    them_dogs.breed = row[2]
    them_dogs
  end

  def self.find_by_id
    # returns a new dog object by id
  end

  def self.find_or_create_by
    # creates an instance of a dog if it does not already exist
    # when two dogs have the same name and different breed, it returns the correct dog
  end

  def self.find_by_name(name)
    # returns an instance of dog that matches the name from the DB
  end

  def update
    # updates the record associated with a given instance
    sql = "UPDATE dog SET name = ?, breed = ?, WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

end
