CREATE TABLE organization (
  id SERIAL PRIMARY KEY,
  remoteId character varying(64),
  name character varying(128),
  checklists json,
  satisfactionSurvey json,
  createdAt timestamp,
  updatedAt timestamp
);

ALTER TABLE Project ADD COLUMN organizationId integer references organization(id);
