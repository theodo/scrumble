CREATE TABLE accesstoken (
    id character varying(1024) NOT NULL,
    ttl integer,
    created timestamp with time zone,
    userid integer
);

CREATE TABLE acl (
    model character varying(1024),
    property character varying(1024),
    accesstype character varying(1024),
    permission character varying(1024),
    principaltype character varying(1024),
    principalid character varying(1024),
    id SERIAL PRIMARY KEY
);

CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    name character varying(1024) NOT NULL,
    description character varying(1024),
    created timestamp with time zone,
    modified timestamp with time zone
);

CREATE TABLE rolemapping (
    id SERIAL PRIMARY KEY,
    principaltype character varying(1024),
    principalid character varying(1024),
    roleid integer
);

CREATE TABLE session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);

CREATE TABLE "user" (
    realm character varying(1024),
    username character varying(1024),
    password character varying(1024) NOT NULL,
    credentials character varying(1024),
    challenges character varying(1024),
    email character varying(1024) NOT NULL,
    emailverified boolean,
    verificationtoken character varying(1024),
    status character varying(1024),
    created timestamp with time zone,
    lastupdated timestamp with time zone,
    id SERIAL PRIMARY KEY
);
