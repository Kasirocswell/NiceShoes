-- Up

CREATE TABLE Users (
    address TEXT PRIMARY KEY,
    userName TEXT
);

INSERT INTO Users (address, userName) values ("12345", "@Kasi");

-- Down

DROP TABLE Users;