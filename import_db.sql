CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL,
  lname VARCHAR(100)
);


CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  user_id SMALLINT,
  title VARCHAR(100),
  body TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id SMALLINT,
  user_id SMALLINT,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)

);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT,
  parent_id SMALLINT,
  user_id SMALLINT NOT NULL,
  question_id SMALLINT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

INSERT INTO users (fname, lname)
  VALUES ('John', 'Doe');

INSERT INTO users (fname, lname)
  VALUES ('Jane', 'Doe');

INSERT INTO users (fname, lname)
  VALUES ('Robert', 'Smith');

INSERT INTO questions
  (user_id, title, body)
  VALUES (1, 'Hello?', "Is anyone there?" );

INSERT INTO questions
  (user_id, title, body)
  VALUES (1, 'Really?', "I need help?" );

INSERT INTO questions
  (user_id, title, body)
  VALUES (1, 'Farewell?', "Death is such sweet sorrow?" );

INSERT INTO questions
  (user_id, title, body)
  VALUES (3, 'Moral Quandry:', "A horse sized duck, or 1,000 duck sized horses?" );

INSERT INTO replies
  (body, parent_id, user_id, question_id)
  VALUES ('horses!', 1, 2, 4);

INSERT INTO replies
  (body, parent_id, user_id, question_id)
  VALUES ('ducks!', 1, 1, 4);

INSERT INTO question_follows
  (question_id, user_id)
  VALUES (3, 2);
