CREATE TABLE feedback (
  id SERIAL PRIMARY KEY,
  message character varying(4096),
  reporter character varying(128),
  status character varying(128),
  createdAt timestamp,
  updatedAt timestamp
);
