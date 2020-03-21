CREATE TABLE boardGroup (
  id SERIAL PRIMARY KEY,
  name character varying(32),
  boards json,
  userId integer references ScrumbleUser(id) not null,
  createdAt timestamp,
  updatedAt timestamp,
  UNIQUE(userId, name)
);

CREATE INDEX board_group_idx ON boardGroup(userId);
