CREATE TABLE ScrumbleUser (
  id SERIAL PRIMARY KEY,
  realm character varying(1024),
  remoteId character varying(128),
  email character varying(1024) NOT NULL,
  password character varying(1024) NOT NULL,
  username character varying(1024),
  status character varying(1024),
  credentials character varying(1024),
  challenges character varying(1024),
  emailverified boolean,
  projectId integer references project(id),
  verificationtoken character varying(1024),
  created timestamp with time zone,
  lastupdated timestamp with time zone
);
