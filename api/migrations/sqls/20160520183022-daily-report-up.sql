CREATE TABLE dailyReport (
  id SERIAL PRIMARY KEY,
  objectId character varying(128),
  projectId integer references project(id) not null,
  sections json,
  createdAt timestamp,
  updatedAt timestamp
);
