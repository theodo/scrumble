CREATE TABLE sprint (
  id SERIAL PRIMARY KEY,
  objectId character varying(128),
  projectId integer references project(id) not null,
  goal character varying(256),
  number integer not null,
  isActive boolean,
  bdcBase64 text,
  bdcData json,
  resources json,
  team json,
  dates json,
  columnMapping json,
  createdAt timestamp,
  updatedAt timestamp
);
