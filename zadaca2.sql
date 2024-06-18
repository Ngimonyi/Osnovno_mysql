-- Table: member
CREATE TABLE member (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    Phone VARCHAR(15),
    MembershipCardNumber VARCHAR(20) UNIQUE
);

-- Table: genre
CREATE TABLE genre (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL
);

-- Table: book
CREATE TABLE book (
    ISBN VARCHAR(13) PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(100),
    GenreID INT,
    FOREIGN KEY (GenreID) REFERENCES genre(GenreID)
);

-- Table: bookCopy
CREATE TABLE bookCopy (
    CopyID INT PRIMARY KEY,
    ISBN VARCHAR(13),
    AvailabilityStatus BOOLEAN DEFAULT true,
    FOREIGN KEY (ISBN) REFERENCES book(ISBN)
);

-- Table: borrow
CREATE TABLE borrow (
    BorrowID INT PRIMARY KEY,
    MemberID INT,
    CopyID INT,
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    DueDate DATE NOT NULL,
    LateFee DECIMAL(5, 2) DEFAULT 0.00,
    FOREIGN KEY (MemberID) REFERENCES member(MemberID),
    FOREIGN KEY (CopyID) REFERENCES bookCopy(CopyID),
    CONSTRAINT valid_return_date CHECK (ReturnDate >= BorrowDate OR ReturnDate IS NULL),
    CONSTRAINT valid_due_date CHECK (DueDate >= BorrowDate)
);





-- Insert sample data into genre table
INSERT INTO genre (GenreID, GenreName) VALUES
    (1, 'Fiction'),
    (2, 'Science Fiction'),
    (3, 'Mystery');

-- Insert sample data into book table
INSERT INTO book (ISBN, Title, Author, GenreID) VALUES
    ('9780316210846', 'The Martian', 'Andy Weir', 2),
    ('9780735211292', 'The Silent Patient', 'Alex Michaelides', 3),
    ('9780735220171', 'Where the Crawdads Sing', 'Delia Owens', 1);

-- Insert sample data into bookCopy table
INSERT INTO bookCopy (CopyID, ISBN) VALUES
    (1, '9780316210846'),
    (2, '9780735211292'),
    (3, '9780735211292'),
    (4, '9780735220171'),
    (5, '9780735220171');

-- Insert sample data into member table
INSERT INTO member (MemberID, Name, Address, Phone, MembershipCardNumber) VALUES
    (1, 'John Doe', '123 Main St, Anytown', '555-1234', 'MEM123'),
    (2, 'Jane Smith', '456 Elm St, Othercity', '555-5678', 'MEM456');

-- Insert sample data into borrow table
INSERT INTO borrow (BorrowID, MemberID, CopyID, BorrowDate, DueDate) VALUES
    (1, 1, 1, '2024-06-01', '2024-06-15'),
    (2, 2, 3, '2024-06-05', '2024-06-19');
