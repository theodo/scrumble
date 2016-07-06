alter table taginstance
drop constraint taginstance_problemid_fkey,
add constraint taginstance_problemid_fkey
   foreign key (problemId)
   references problem(id)
   on delete cascade;
