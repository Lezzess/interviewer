drop table if exists "answers_selected_values";
drop table if exists "answers";
drop table if exists "questions";
drop table if exists "folders";
drop table if exists "companies";

create table if not exists "companies" (
  "id" text not null primary key,
  "name" text not null,
  "is_template" integer not null
);

create table if not exists "folders" (
  "id" text not null primary key,
  "name" text not null,
  "order_no" integer not null 
);

create table if not exists "questions" (
  "id" text not null primary key,
  "text" text not null,
  "note" text null,
  "folder_id" text null,
  "company_id" text not null,
  foreign key ("folder_id") references "folders" ("id"),
  foreign key ("company_id") references "companies" ("id")
);

create table if not exists "answers" (
  "id" text not null primary key,
  "type" text not null,
  "value_double" real null,
  "value_text" text null,
  "is_multiselect" integer null,
  "is_multiline" integer null,
  "question_id" text not null,
  foreign key ("question_id") references "questions" ("id")
);

create table if not exists "answers_selected_values" (
  "id" text not null primary key,
  "value" text not null,
  "is_selected" integer not null,
  "answer_id" text not null,
  foreign key ("answer_id") references "answers" ("id")
);
