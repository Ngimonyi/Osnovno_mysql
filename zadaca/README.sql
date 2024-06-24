-- Create a new database named videoteka
CREATE DATABASE videoteka;

-- Create a new user
CREATE USER 'videoteka_user'@'localhost' IDENTIFIED BY 'your_password';

-- Grant privileges on the videoteka database
GRANT ALL PRIVILEGES ON videoteka.* TO 'videoteka_user'@'localhost';

-- Apply the changes
FLUSH PRIVILEGES;


USE videoteka;

-- Table: member
CREATE TABLE member (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    Phone VARCHAR(15),
    MembershipCardNumber VARCHAR(20) UNIQUE
);

-- Table: genre
CREATE TABLE genre (
    GenreID INT PRIMARY KEY AUTO_INCREMENT,
    GenreName VARCHAR(100) NOT NULL
);

-- Table: film
CREATE TABLE film (
    FilmID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    Director VARCHAR(100),
    GenreID INT,
    Stock INT DEFAULT 0,  -- Stock of available copies
    FOREIGN KEY (GenreID) REFERENCES genre(GenreID)
);

-- Table: filmCopy
CREATE TABLE filmCopy (
    CopyID INT PRIMARY KEY AUTO_INCREMENT,
    FilmID INT,
    Barcode VARCHAR(20) UNIQUE,
    AvailabilityStatus BOOLEAN DEFAULT true,
    FOREIGN KEY (FilmID) REFERENCES film(FilmID)
);

-- Table: borrow
CREATE TABLE borrow (
    BorrowID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    CopyID INT,
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    DueDate DATE NOT NULL,
    LateFee DECIMAL(5, 2) DEFAULT 0.00,
    FOREIGN KEY (MemberID) REFERENCES member(MemberID),
    FOREIGN KEY (CopyID) REFERENCES filmCopy(CopyID),
    CONSTRAINT valid_return_date CHECK (ReturnDate >= BorrowDate OR ReturnDate IS NULL),
    CONSTRAINT valid_due_date CHECK (DueDate >= BorrowDate)
);

-- Insert sample data into genre table
INSERT INTO genre (GenreName) VALUES
    ('Fiction'),
    ('Science Fiction'),
    ('Mystery');

-- Insert sample data into film table
INSERT INTO film (Title, Director, GenreID, Stock) VALUES
    ('The Martian', 'Ridley Scott', 2, 10),
    ('The Silent Patient', 'Alex Michaelides', 3, 5),
    ('Where the Crawdads Sing', 'Delia Owens', 1, 7);

-- Insert sample data into filmCopy table
INSERT INTO filmCopy (FilmID, Barcode) VALUES
    (1, 'BC9780316210846'),
    (1, 'BC9780316210847'),
    (2, 'BC9780735211292'),
    (2, 'BC9780735211293'),
    (3, 'BC9780735220171'),
    (3, 'BC9780735220172');

-- Insert sample data into member table
INSERT INTO member (Name, Address, Phone, MembershipCardNumber) VALUES
    ('John Doe', '123 Main St, Anytown', '555-1234', 'MEM123'),
    ('Jane Smith', '456 Elm St, Othercity', '555-5678', 'MEM456');

-- Insert sample data into borrow table
INSERT INTO borrow (MemberID, CopyID, BorrowDate, DueDate) VALUES
    (1, 1, '2024-06-01', '2024-06-15'),
    (2, 3, '2024-06-05', '2024-06-19');
