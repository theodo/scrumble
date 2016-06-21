CREATE TABLE problem (
  id SERIAL PRIMARY KEY,
  description character varying(4096),
  link character varying(1024),
  action character varying(4096),
  hypothesis character varying(4096),
  type character varying(64),
  happenedDate timestamp,
  projectId integer references project(id) not null,
  createdAt timestamp,
  updatedAt timestamp
);
