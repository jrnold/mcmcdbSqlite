# Tables

- chains
  - chain_id: integer
- samples
  - chain_id: integer
  - iter: integer
- flatpars
  - flatpar: varchar
  - pararray: varchar
  - idx: integer
- pararrays
  - pararray: varchar
  - dimension: varchar
- flatpar_chains
  - flatpar: varchar
  - chain_id

Initialize: 

- create tables
- need names of parameters in order to create columns of samples.
- Other columns
