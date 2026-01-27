package enemies_struct;

  typedef struct packed {
    logic [11:0] x;
    logic [11:0] y;
    logic        alive;
    logic [1:0] id;
  } enemy_t;

endpackage