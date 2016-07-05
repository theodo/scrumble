CREATE TABLE tag (
  id SERIAL PRIMARY KEY,
  label character varying(32) UNIQUE,
  createdAt timestamp,
  updatedAt timestamp
);

CREATE TABLE tagInstance (
  id SERIAL PRIMARY KEY,
  tagId integer references tag(id) not null,
  problemId integer references problem(id) not null,
  UNIQUE(tagId, problemId)
);
