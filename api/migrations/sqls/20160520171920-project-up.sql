CREATE TABLE project (
  id SERIAL PRIMARY KEY,
  boardId character varying(128),
  objectId character varying(128),
  name character varying(128),
  columnMapping json,
  settings json,
  createdAt timestamp,
  updatedAt timestamp
);
