
// This is the UDP for the output drive with power pins.
primitive udp_dffr3 (out, st1, st0, ck, clr_, set_, retn, pwr, pwrg);
input st1, st0, ck, clr_, set_, retn, pwr, pwrg;
output out;
  table
  // st1 st0 ck clr_ set_ retn pwr pwrg
      ?   ?   ?  ?    ?     ?   0   ?  : x ; // No output power is an x
      ?   ?   ?  ?    ?     ?   x   ?  : x ;
      ?   ?   ?  ?    ?     ?   1   0  : x ; // No global power is an x
      ?   ?   ?  ?    ?     ?   1   x  : x ;

                                             // Strange things happen when
      ?   ?   ?  ?    ?     x   1   1  : x ; //  retn is an x.

      ?   0   ?  ?    ?     1   1   1  : 0 ; // Non retention mode.
      ?   1   ?  ?    ?     1   1   1  : 1 ; // Drive whatever is in
      ?   x   ?  ?    ?     1   1   1  : x ; //  the retn/slave stage.

      ?   ?   ?  0    1     0   1   1  : 0 ; // Reset output
      ?   ?   ?  ?    0     0   1   1  : 1 ; // set output

      ?   0   0  1    1     0   1   1  : 0 ; // Retention mode
      ?   1   0  1    1     0   1   1  : 1 ; //  with clock 0
      ?   x   0  1    1     0   1   1  : x ; //  drive from the retn bit.

      0   ?   1  1    1     0   1   1  : 0 ; // Retention mode
      1   ?   1  1    1     0   1   1  : 1 ; //  with clock 1
      x   ?   1  1    1     0   1   1  : x ; //  drive from the first stage.

      ?   ?   x  1    1     0   1   1  : x ; // Retention mode

  endtable
endprimitive // udp_dffr3



primitive udp_tlat (out, in, hold, clr_, set_, NOTIFIER);
   output out;  
   input  in, hold, clr_, set_, NOTIFIER;
   reg    out;

   table

// in  hold  clr_   set_  NOT  : Qt : Qt+1
//
   1  0   1   ?   ?   : ?  :  1  ; // 
   0  0   ?   1   ?   : ?  :  0  ; // 
   1  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   *  1   ?   ?   ?   : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   ?   : ?  :  1  ; // set output
   ?  1   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   1  ?   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   ?   : ?  :  0  ; // reset output
   ?  1   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  ?   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat

primitive udp_lcg(out, e, mgclk, ovrd, NOT);
   output out;
   input  e, mgclk, ovrd, NOT;
   reg 	  out;

   table
//
//  e    mgclk   ovrd   NOT  : out : out*
//
    0     0      0      ?   :  ?  :  0; //
    1     0      ?      ?   :  ?  :  1; //
    ?     ?      1      ?   :  ?  :  1; // ovrd overrides all other inputs      
    ?     1      *      ?   :  1  :  1; //
    1     ?      *      ?   :  1  :  1; //        
    *     1      0      ?   :  ?  :  -; // retain the old state
    1     *      ?      ?   :  1  :  1; // reduce pessimism
    0     *      0      ?   :  0  :  0; // reduce pessimism
    ?     ?      ?      *   :  ?  :  x;
      
   endtable
endprimitive // udp_lcg


primitive udp_tlatrf2_PWR (out, in1, w1w, in2, w2w, VDD, VSS, NOTIFIER);
   output out;  
   input  in1, w1w, VDD, VSS, NOTIFIER;
   input  in2, w2w;
   reg    out;

   table

// in1 ww1 in2 ww2  VDD  VSS  NOTIFIER  : Qt : Qt+1
//	     
   ?   ?    ?   ?    0  0  ?  : ?  :  x  ; 
   ?   ?    ?   ?    1  1  ?  : ?  :  x  ; 
   ?   ?    ?   ?    0  1  ?  : ?  :  x  ; 
   ?   ?    ?   ?    ?  ?  *  : ?  :  x  ; //
   1   1    ?   0    1  0  ?  : ?  :  1  ; //
   1   *    ?   0    1  0  ?  : 1  :  1  ; //
   0   1    ?   0    1  0  ?  : ?  :  0  ; //
   0   *    ?   0    1  0  ?  : 0  :  0  ; //
   ?   0    1   1    1  0  ?  : ?  :  1  ; //
   ?   0    1   *    1  0  ?  : 1  :  1  ; //
   ?   0    0   1    1  0  ?  : ?  :  0  ; //
   ?   0    0   *    1  0  ?  : 0  :  0  ; //
   *   0    ?   0    1  0  ?  : ?  :  -  ; //
   ?   0    *   0    1  0  ?  : ?  :  -  ; //
   1   *    1   1    1  0  ?  : ?  :  1  ; //
   1   1    1   *    1  0  ?  : ?  :  1  ; //
   0   *    0   1    1  0  ?  : ?  :  0  ; //
   0   1    0   *    1  0  ?  : ?  :  0  ; //
   0   1    0   1    1  0  ?  : ?  :  0  ; //
   1   1    1   1    1  0  ?  : ?  :  1  ; //



   endtable
endprimitive // udp_tlatrf2


primitive udp_tlat_retpwr (out, VDD, VSS, in, hold, clr_, set_, NOTIFIER);
   output out;  
   input  VDD, VSS, in, hold, clr_, set_, NOTIFIER;
   reg    out;

   table

// VDD, VSS, in  hold  clr_   set_  NOT  : Qt : Qt+1
//
    1    0    1   0     1      ?     ?   : ?  :  1  ; // 
    1    0    0   0     ?      1     ?   : ?  :  0  ; // 
    1    0    1   *     1      ?     ?   : 1  :  1  ; // reduce pessimism
    1    0    0   *     ?      1     ?   : 0  :  0  ; // reduce pessimism
    1    0    *   1     ?      ?     ?   : ?  :  -  ; // no changes when in switches
    1    0    ?   ?     ?      0     ?   : ?  :  1  ; // set output
    1    0    ?   1     1      *     ?   : 1  :  1  ; // cover all transistions on set_
    1    0    1   ?     1      *     ?   : 1  :  1  ; // cover all transistions on set_
    1    0    ?   ?     0      1     ?   : ?  :  0  ; // reset output
    1    0    ?   1     *      1     ?   : 0  :  0  ; // cover all transistions on clr_
    1    0    0   ?     *      1     ?   : 0  :  0  ; // cover all transistions on clr_
    0    ?    ?   ?     ?      ?     ?   : ?  :  x  ;
    x    ?    ?   ?     ?      ?     ?   : ?  :  x  ;
    ?    1    ?   ?     ?      ?     ?   : ?  :  x  ;
    ?    x    ?   ?     ?      ?     ?   : ?  :  x  ;
    ?    ?    ?   ?     ?      ?     *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rettlat

primitive udp_lv_pp_or_vdd_vss (y, a, b, vdd, vss);
   output y;
   input  a, b, vdd, vss;

   table
      // a b vdd vss : y
      1 ? 1 0 : 1;
      ? 1 1 0 : 1;
      0 0 1 0 : 0;
   endtable

endprimitive // udp_lv_pp_vdd_vss


primitive udp_rslat_out_ (out_, r, s, NOTIFIER);
   output out_;  
   input  r, s, NOTIFIER;
   reg    out_;

   table

// r   s   NOT : Qt : Qt+1
// 
  (?0) 0   ?   : ?  :  -  ; // no change
   0  (?0) ?   : ?  :  -  ; // no change
  (?1) 0   ?   : ?  :  1  ; // reset
   1  (?0) ?   : ?  :  1  ; // reset
   0   1   ?   : ?  :  0  ; // set
  (?0) x   ?   : 0  :  0  ; // reduced pessimism
   0  (?x) ?   : 0  :  0  ; // reduced pessimism
  (?x) 0   ?   : 1  :  1  ; // reduced pessimism
   x  (?0) ?   : 1  :  1  ; // reduced pessimism
   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out_


primitive udp_sedfft (out, in, clk, clr_, si, se, en, NOTIFIER);
   output out;  
   input  in, clk, clr_, si, se,  en, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  si  se  en  NOT : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   *  : ?  :  x; // any notifier changed
      ?    r    ?     0   1   ?   ?  : ?  :  0;     
      ?    r    ?     1   1   ?   ?  : ?  :  1;
      ?    b    ?     ?   *   ?   ?  : ?  :  -; // no changes when se switches
      ?    b    ?     *   ?   ?   ?  : ?  :  -; // no changes when si switches
      *    b    ?     ?   ?   ?   ?  : ?  :  -; // no changes when in switches
      ?    b    ?     ?   ?   *   ?  : ?  :  -; // no changes when en switches
      ?    b    *     ?   ?   ?   ?  : ?  :  -; // no changes when clr switches
      0    r    ?     0   ?   1   ?  : ?  :  0 ; 
      1    r    1     1   ?   1   ?  : ?  :  1 ; 
      ?    r    ?     0   ?   0   ?  : 0  :  0;
      ?    x    ?     0   ?   0   ?  : 0  :  0;
      ?    r    1     1   ?   0   ?  : 1  :  1;
      ?    x    1     1   ?   0   ?  : 1  :  1;
      ?    *    1     ?   0   0   ?  : ?  :  -;
      ?    *    ?     1   1   ?   ?  : 1  :  1;
      1    *    1     1   ?   ?   ?  : 1  :  1;
      ?    *    ?     0   1   ?   ?  : 0  :  0;
      ?    *    0     0   ?   ?   ?  : 0  :  0;
      0    *    ?     0   ?   ?   ?  : 0  :  0;
      ?    x    1     ?   0   0   ?  : ?  :  -;
      ?    *    ?     ?   0   0   ?  : 0  :  0;
      ?    x    ?     ?   0   0   ?  : 0  :  0;
      ?    x    ?     1   1   ?   ?  : 1  :  1;
      1    x    1     1   ?   ?   ?  : 1  :  1;
      ?    x    ?     0   1   ?   ?  : 0  :  0;
      ?    x    0     0   ?   ?   ?  : 0  :  0;
      0    x    ?     0   ?   ?   ?  : 0  :  0;
      ?    r    0     0   ?   ?   ?  : ?  :  0 ; 
      ?   (?0)  ?     ?   ?   ?   ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   0   1   ?  : ?  :  1;
      0    r    ?     ?   0   1   ?  : ?  :  0;
      ?    r    0     ?   0   ?   ?  : ?  :  0;
      ?    x    0     ?   0   ?   ?  : 0  :  0;
      1    x    1     ?   0   ?   ?  : 1  :  1; // no changes when in switches
      0    x    ?     ?   0   ?   ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   0   ?   ?  : 1  :  1; // reduce pessimism
      0    *    ?     ?   0   ?   ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive  /* udp_sedfft */
   

primitive udp_or_pp (y, a, b, vdd, vss);
   output y;
   input  a, b, vdd, vss;

   table
      // a b vdd vss : y
      1 ? 1 0 : 1;
      ? 1 1 0 : 1;
      0 0 1 0 : 0;
   endtable

endprimitive // udp_and_pp

	


primitive udp_jkff (out, j, k, clk, clr_, set_, NOTIFIER);
   output out;  
   input  j, k, clk, clr_, set_, NOTIFIER;
   reg    out;

   table

// j  k  clk  clr_   set_  NOT  : Qt : Qt+1
//       
   0  0  r   1   1   ?   : ?  :  -  ; // output remains same
   0  1  r   ?   1   ?   : ?  :  0  ; // clock in 0
   1  0  r   1   ?   ?   : ?  :  1  ; // clock in 1
//   1  1  r   ?   1   ?   : 1  :  0  ; // clock in 0
   ?  1  r   ?   1   ?   : 1  :  0  ; // clock in 0
//   1  1  r   1   ?   ?   : 0  :  1  ; // clock in 1
   1  ?  r   1   ?   ?   : 0  :  1  ; // clock in 1
   ?  0  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  ?  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   ?  ?  f   ?   ?   ?   : ?  :  -  ; // no changes on negedge clk
   *  ?  b   ?   ?   ?   : ?  :  -  ; // no changes when j switches
   *  0  x   1   ?   ?   : 1  :  1  ; // no changes when j switches
   ?  *  b   ?   ?   ?   : ?  :  -  ; // no changes when k switches
   0  *  x   ?   1   ?   : 0  :  0  ; // no changes when k switches
   ?  ?  ?   ?   0   ?   : ?  :  1  ; // set output
   ?  ?  b   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  0  x   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?  ?   0   1   ?   : ?  :  0  ; // reset output
   ?  ?  b   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  ?  x   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?  ?   ?   ?   *   : ?  :  x  ; // any notifier change

   endtable
endprimitive // udp_jkff


primitive udp_bmx (out, x2, a, s, m1, m0);
   output out;  
   input   x2, a, s, m1, m0;

   table
   //x2 a s m1 m0 : out
     0  ? 0 0  ?  : 1;   // PW a: 1->?
     0  1 ? 1  ?  : 0;   // PW s: 0->?
     0  ? 1 0  ?  : 0;   // PW a: 0->?
     0  0 ? 1  ?  : 1;   // PW s: 1->?
     1  ? 0 ?  0  : 1;   // PW a: 1->?
     1  1 ? ?  1  : 0;   // PW s: 0->?
     1  ? 1 ?  0  : 0;   // PW a: 0->?
     1  0 ? ?  1  : 1;   // PW s: 1->?
     ?  0 0 ?  ?  : 1;
     ?  1 1 ?  ?  : 0;
     ?  ? 1 0  0  : 0;
     ?  0 ? 1  1  : 1;
     ?  ? 0 0  0  : 1;
     ?  1 ? 1  1  : 0;


   endtable
endprimitive // udp_bmx


primitive udp_sedff (out, in, clk, clr_, si, se, en, NOTIFIER);
   output out;  
   input  in, clk, clr_, si, se,  en, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  si  se  en  NOT : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   *  : ?  :  x; // any notifier changed
      ?    ?    0     ?   ?   ?   ?  : ?  :  0;     
      ?    r    ?     0   1   ?   ?  : ?  :  0;     
      ?    r    1     1   1   ?   ?  : ?  :  1;
      ?    b    1     ?   *   ?   ?  : ?  :  -; // no changes when se switches
      ?    b    1     *   ?   ?   ?  : ?  :  -; // no changes when si switches
      *    b    1     ?   ?   ?   ?  : ?  :  -; // no changes when in switches
      *    ?    ?     ?   0   0   ?  : 0  :  0; // no changes when in switches
      ?    ?    ?     *   0   0   ?  : 0  :  0; // no changes when in switches
      ?    b    1     ?   ?   *   ?  : ?  :  -; // no changes when en switches
      ?    b    *     ?   ?   ?   ?  : 0  :  0; // no changes when en switches
      ?    ?    *     ?   0   0   ?  : 0  :  0; // no changes when en switches
      ?    b    ?     ?   ?   *   ?  : 0  :  0; // no changes when en switches
      ?    b    ?     ?   *   ?   ?  : 0  :  0; // no changes when en switches
      ?    b    ?     *   ?   ?   ?  : 0  :  0; // no changes when en switches
      *    b    ?     ?   ?   ?   ?  : 0  :  0; // no changes when en switches
      ?  (10)   ?     ?   ?   ?   ?  : ?  :  -;  // no changes on falling clk edge
      ?    *    1     1   1   ?   ?  : 1  :  1;
      ?    x    1     1   1   ?   ?  : 1  :  1;
      ?    *    1     1   ?   0   ?  : 1  :  1;
      ?    x    1     1   ?   0   ?  : 1  :  1;
      ?    *    ?     0   1   ?   ?  : 0  :  0;
      ?    x    ?     0   1   ?   ?  : 0  :  0;
      ?    *    ?     0   ?   0   ?  : 0  :  0;
      ?    x    ?     0   ?   0   ?  : 0  :  0;
      0    r    ?     0   ?   1   ?  : ?  :  0 ; 
      0    *    ?     0   ?   ?   ?  : 0  :  0 ; 
      0    x    ?     0   ?   ?   ?  : 0  :  0 ; 
      1    r    1     1   ?   1   ?  : ?  :  1 ; 
      1    *    1     1   ?   ?   ?  : 1  :  1 ; 
      1    x    1     1   ?   ?   ?  : 1  :  1 ; 
      ?  (x0)   ?     ?   ?   ?   ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   0   1   ?  : ?  :  1;
      0    r    ?     ?   0   1   ?  : ?  :  0;
      ?    *    ?     ?   0   0   ?  : ?  :  -;
      ?    x    1     ?   0   0   ?  : ?  :  -;
      1    x    1     ?   0   ?   ?  : 1  :  1; // no changes when in switches
      0    x    ?     ?   0   ?   ?  : 0  :  0; // no changes when in switches
      1    x    ?     ?   0   0   ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   0   ?   ?  : 1  :  1; // reduce pessimism
      0    *    ?     ?   0   ?   ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive  /* udp_sedff */
   


primitive udp_mux2 (out, in0, in1, sel);
   output out;  
   input  in0, in1, sel;

   table

// in0 in1  sel :  out
//
   1  ?   0  :  1 ;
   0  ?   0  :  0 ;
   ?  1   1  :  1 ;
   ?  0   1  :  0 ;
   0  0   x  :  0 ;
   1  1   x  :  1 ;

   endtable
endprimitive // udp_mux2


primitive udp_sedffsr (out, in, clk, clr_, set_, si, se, en, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, si, se,  en, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  set_ si  se  en  NOT : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   ?   *  : ?  :  x; // any notifier changed
      ?    ?    0     1   ?   ?   ?   ?  : ?  :  0; 
      ?    ?    ?     0   ?   ?   ?   ?  : ?  :  1; 
      ?    r    ?     1   0   1   ?   ?  : ?  :  0;
      ?    r    1     ?   1   1   ?   ?  : ?  :  1;      
      ?    b    ?     1   ?   *   ?   ?  : 0  :  0; // no changes when se switches
      ?    b    1     ?   ?   *   ?   ?  : 1  :  1; // no changes when se switches
      ?    b    ?     1   *   ?   ?   ?  : 0  :  0; // no changes when si switches
      ?    b    1     ?   *   ?   ?   ?  : 1  :  1; // no changes when si switches
      *    b    ?     1   ?   ?   ?   ?  : 0  :  0; // no changes when in switches
      *    b    1     ?   ?   ?   ?   ?  : 1  :  1; // no changes when in switches
      ?    b    ?     1   ?   ?   *   ?  : 0  :  0; // no changes when en switches
      ?    b    1     ?   ?   ?   *   ?  : 1  :  1; // no changes when en switches
      ?    ?    *     1   ?   0   0   ?  : 0  :  0; //new
      ?    x    1     1   ?   0   0   ?  : 0  :  0;
      ?    x    1     1   ?   0   0   ?  : 1  :  1;
      ?    ?    *     1   0   ?   0   ?  : 0  :  0; //new
      0    ?    *     1   ?   0   1   ?  : 0  :  0; //new
      ?    b    *     1   ?   ?   ?   ?  : 0  :  0; //new
      ?    ?    1     *   ?   0   0   ?  : 1  :  1; //new
      ?    ?    1     *   1   ?   0   ?  : 1  :  1; //new
      1    ?    1     *   ?   0   1   ?  : 1  :  1; //new
      ?    b    1     *   ?   ?   ?   ?  : 1  :  1; //new
      ?    *    1     ?   1   1   ?   ?  : 1  :  1;
      ?    x    1     ?   1   1   ?   ?  : 1  :  1;
      ?    x    1     ?   ?   0   0   ?  : 1  :  1;
      ?    x    1     ?   1   ?   0   ?  : 1  :  1;
      ?    *    1     ?   1   ?   0   ?  : 1  :  1;
      ?    *    ?     1   0   1   ?   ?  : 0  :  0;
      ?    x    ?     1   0   1   ?   ?  : 0  :  0;
      ?    x    ?     1   ?   0   0   ?  : 0  :  0;
      ?    x    ?     1   0   ?   0   ?  : 0  :  0;
      ?    *    ?     1   0   ?   0   ?  : 0  :  0;
      0    r    ?     1   0   ?   1   ?  : ?  :  0 ; 
      0    *    ?     1   0   ?   ?   ?  : 0  :  0 ;
      0    x    ?     1   0   ?   ?   ?  : 0  :  0 ; 
      1    r    1     ?   1   ?   1   ?  : ?  :  1 ; 
      1    *    1     ?   1   ?   ?   ?  : 1  :  1 ; 
      1    x    1     ?   1   ?   ?   ?  : 1  :  1 ; 
      ?  (10)   ?     ?   ?   ?   ?   ?  : ?  :  -;  // no changes on falling clk edge
      ?  (x0)   ?     ?   ?   ?   ?   ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   ?   0   1   ?  : ?  :  1;
      0    r    ?     1   ?   0   1   ?  : ?  :  0 ; 
      ?    *    ?     1   ?   0   0   ?  : 0  :  0;
      ?    *    1     ?   ?   0   0   ?  : 1  :  1;
      1    x    1     ?   ?   0   ?   ?  : 1  :  1; // no changes when in switches
      0    x    ?     1   ?   0   ?   ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   ?   0   ?   ?  : 1  :  1; // reduce pessimism
      0    *    ?     1   ?   0   ?   ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive // udp_sedffsr

   


primitive udp_mux4 (out, in0, in1, in2, in3, sel_0, sel_1);
   output out;  
   input  in0, in1, in2, in3, sel_0, sel_1;

   table

// in0 in1 in2 in3 sel_0 sel_1 :  out
//
   0  ?  ?  ?  0  0  :  0;
   1  ?  ?  ?  0  0  :  1;
   ?  0  ?  ?  1  0  :  0;
   ?  1  ?  ?  1  0  :  1;
   ?  ?  0  ?  0  1  :  0;
   ?  ?  1  ?  0  1  :  1;
   ?  ?  ?  0  1  1  :  0;
   ?  ?  ?  1  1  1  :  1;
   0  0  ?  ?  x  0  :  0;
   1  1  ?  ?  x  0  :  1;
   ?  ?  0  0  x  1  :  0;
   ?  ?  1  1  x  1  :  1;
   0  ?  0  ?  0  x  :  0;
   1  ?  1  ?  0  x  :  1;
   ?  0  ?  0  1  x  :  0;
   ?  1  ?  1  1  x  :  1;
   1  1  1  1  x  x  :  1;
   0  0  0  0  x  x  :  0;

   endtable
endprimitive // udp_mux4


primitive udp_retn_pwr (out, VDD, VSS, n2, n4, clk, xRN, xSN);
   output out;  
   input  VDD, VSS, n2, n4, clk, xRN, xSN;

   table
// VDD, VSS, n2, n4, clk, xRN, xSN 
//
    1    0   0   ?    1    1   1 : 0;
    1    0   1   ?    1    1   1 : 1;
    1    0   ?   0    0    1   1 : 0;
    1    0   ?   1    0    1   1 : 1;
    1    0   ?   ?    ?    ?   0 : 1;
    1    0   ?   ?    ?    0   1 : 0;
    1    0   ?   1    0    1   ? : 1; //reducing pessimisim
    1    0   1   ?    1    1   ? : 1;
    1    0   1   1    ?    1   ? : 1;
    1    0   ?   0    0    ?   1 : 0;
    1    0   0   ?    1    ?   1 : 0;
    1    0   0   0    ?    ?   1 : 0;
    0    ?   ?   ?    ?    ?   ? : x;
    x    ?   ?   ?    ?    ?   ? : x;
    ?    1   ?   ?    ?    ?   ? : x;
    ?    x   ?   ?    ?    ?   ? : x;
   endtable
endprimitive // udp_mux


primitive udp_rslat_out_PWR (out, r, s, VDD, VSS, NOTIFIER);
   output out;  
   input  r, s, VDD, VSS, NOTIFIER;
   reg    out;

   table

// r   s   VDD  VSS  NOTIFIER : Qt : Qt+1
// 
  (?0) 0   1  0  ?  : ?  :  -  ; // no change
   0  (?0) 1  0  ?  : ?  :  -  ; // no change
   1   0   1  0  ?  : ?  :  0  ; // reset
  (?0) 1   1  0  ?  : ?  :  1  ; // set
   0  (?1) 1  0  ?  : ?  :  1  ; // set
  (?0) x   1  0  ?  : 1  :  1  ; // reduced pessimism
   0  (?x) 1  0  ?  : 1  :  1  ; // reduced pessimism
  (?x) 0   1  0  ?  : 0  :  0  ; // reduced pessimism
   x  (?0) 1  0  ?  : 0  :  0  ; // reduced pessimism
   ?   ?   0  0  ?  : ?  :  x  ; 
   ?   ?   1  1  ?  : ?  :  x  ; 
   ?   ?   0  1  ?  : ?  :  x  ; 
   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out

primitive udp_o2lvluu_pp_or_vddi_vdd_vss (y, a, b, vddi, vdd, vss);
   output y;
   input  a, b, vddi, vdd, vss;

   table
      // a b vddi vdd vss : y
      1 ? 1 1 0 : 1;
      ? 1 1 1 0 : 1;
      0 0 1 1 0 : 0;
   endtable

endprimitive // udp_lv_pp_vddi_vdd_vss

primitive udp_ph2p (LOUT, CLK1, CLK2, DATA1, DATA2, SET, RESET);
    output LOUT; reg LOUT;
    input CLK1;
    input CLK2;
    input DATA1;
    input DATA2;
    input SET;
    input RESET;
    table
    //  **NOTE that for input combo's not given , the output will be x=unknown
    //  CLK1 CLK2 DATA1 DATA2 SET  RESET : state : LOUT
         ?    ?    ?     ?     0    0    :   ?   :  0 ;// Reset only on
         ?    ?    ?     ?     1    1    :   ?   :  1 ;// Set only on
         ?    ?    ?     ?     1    0    :   ?   :  1 ;// Both S/R active
         ?    ?    ?     ?     1    X    :   ?   :  1 ;// Set on, reset X
         0    0    ?     ?     0    1    :   ?   :  - ;// No Change
         1    0    0     ?     0    ?    :   ?   :  0 ;// First Port Function
         1    0    1     ?     ?    1    :   ?   :  1 ;
         0    1    ?     0     0    ?    :   ?   :  0 ;// Second Port Function
         0    1    ?     1     ?    1    :   ?   :  1 ;
         1    1    0     0     0    ?    :   ?   :  0 ;// Both Clocks ON
         1    1    1     1     ?    1    :   ?   :  1 ;
         ?    0    0     ?     0    1    :   0   :  - ;// Clocks Unknown
         ?    0    1     ?     0    1    :   1   :  - ;
         ?    1    0     0     0    ?    :   ?   :  0 ;
         ?    1    1     1     ?    1    :   ?   :  1 ;
         0    ?    ?     0     0    1    :   0   :  - ;
         0    ?    ?     1     0    1    :   1   :  - ;
         1    ?    0     0     0    ?    :   ?   :  0 ;
         1    ?    1     1     ?    1    :   ?   :  1 ;
         ?    ?    0     0     0    1    :   0   :  - ;
         ?    ?    1     1     0    1    :   1   :  - ;
         0    0    ?     ?     0    X    :   0   :  - ;// Reset Unknown
         ?    ?    0     0     0    X    :   0   :  - ;
         ?    0    0     ?     0    X    :   0   :  - ;
         0    ?    ?     0     0    X    :   0   :  - ;
         0    0    ?     ?     X    1    :   1   :  - ;// Set Unknown
         ?    ?    1     1     X    1    :   1   :  - ;
         ?    0    1     ?     X    1    :   1   :  - ;
         0    ?    ?     1     X    1    :   1   :  - ;
    endtable
endprimitive


primitive udp_mux (out, in, s_in, s_sel);
   output out;  
   input  in, s_in, s_sel;

   table

// in  s_in  s_sel :  out
//
   1  ?   0  :  1 ;
   0  ?   0  :  0 ;
   ?  1   1  :  1 ;
   ?  0   1  :  0 ;
   0  0   x  :  0 ;
   1  1   x  :  1 ;

   endtable
endprimitive // udp_mux

primitive udp_buf_pp (y, a, vddg, vssg);
   output y;
   input  a, vddg, vssg;

   table
    // a vddg vssg : y
       0  1    0   : 0;
       1  1    0   : 1;
    endtable
  
endprimitive
 

primitive udp_lv_pp_vddi_vdd_vss (y, a, b, vddi, vdd, vss);
   output y;
   input  a, b, vddi, vdd, vss;

   table
      // a b vddi vdd vss : y
      0 ? 1 1 0 : 0;
      ? 0 1 1 0 : 0;
      1 1 1 1 0 : 1;
      ? 0 ? 1 0 : 0;
   endtable

endprimitive // udp_lv_pp_vddi_vdd_vss


primitive udp_tlatrf2 (out, in1, w1w, in2, w2w, NOTIFIER);
   output out;  
   input  in1, w1w, NOTIFIER;
   input  in2, w2w;
   reg    out;

   table

// in1 ww1 in2 ww2  NOT  : Qt : Qt+1
//	     
   ?   ?    ?   ?    *    : ?  :  x  ; //
   1   1    ?   0    ?    : ?  :  1  ; //
   1   *    ?   0    ?    : 1  :  1  ; //
   0   1    ?   0    ?    : ?  :  0  ; //
   0   *    ?   0    ?    : 0  :  0  ; //
   ?   0    1   1    ?    : ?  :  1  ; //
   ?   0    1   *    ?    : 1  :  1  ; //
   ?   0    0   1    ?    : ?  :  0  ; //
   ?   0    0   *    ?    : 0  :  0  ; //
   *   0    ?   0    ?    : ?  :  -  ; //
   ?   0    *   0    ?    : ?  :  -  ; //
   1   *    1   1    ?    : ?  :  1  ; //
   1   1    1   *    ?    : ?  :  1  ; //
   0   *    0   1    ?    : ?  :  0  ; //
   0   1    0   *    ?    : ?  :  0  ; //
   0   1    0   1    ?    : ?  :  0  ; //
   1   1    1   1    ?    : ?  :  1  ; //



   endtable
endprimitive // udp_tlatrf2



primitive udp_tlatrf_PWR (out, in, ww, wwn, VDD, VSS, NOTIFIER);
   output out;  
   input  in, ww, wwn, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  ww    wwn  VDD  VSS  NOTIFIER  : Qt : Qt+1
//	     
   1   ?     0    1  0  ?  : ?  :  1  ; // 
   1   1     ?    1  0  ?  : ?  :  1  ; // 
   0   ?     0    1  0  ?  : ?  :  0  ; // 
   0   1     ?    1  0  ?  : ?  :  0  ; // 
   1   *     ?    1  0  ?  : 1  :  1  ; // reduce pessimism
   1   ?     *    1  0  ?  : 1  :  1  ; // reduce pessimism
   0   *     ?    1  0  ?  : 0  :  0  ; // reduce pessimism
   0   ?     *    1  0  ?  : 0  :  0  ; // reduce pessimism
   *   0     1    1  0  ?  : ?  :  -  ; // no changes when in switches
   ?   ?     ?    0  0  ?  : ?  :  x  ; 
   ?   ?     ?    1  1  ?  : ?  :  x  ; 
   ?   ?     ?    0  1  ?  : ?  :  x  ; 
   ?   ?     ?    ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlatrf



primitive udp_dff_PWR (out, in, clk, clr_, set_, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   0  r   ?   1   1  0  ?  : ?  :  0  ; // clock in 0
   1  r   1   ?   1  0  ?  : ?  :  1  ; // clock in 1
   1  *   1   ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0  *   ?   1   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?  f   ?   ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *  b   ?   ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   1  0  ?  : ?  :  1  ; // set output
   ?  b   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   1  x   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   1  0  ?  : ?  :  0  ; // reset output
   ?  b   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   0  x   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   0  0  ?  : ?  :  x  ; 
   ?  ?   ?   ?   1  1  ?  : ?  :  x  ; 
   ?  ?   ?   ?   0  1  ?  : ?  :  x  ; 
   ?  ?   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_dff

primitive udp_a2lvluu_pp_vddi_vdd_vss (y, a, b, vddi, vdd, vss);
   output y;
   input  a, b, vddi, vdd, vss;

   table
      // a b vddi vdd vss : y
      0 ? 1 1 0 : 0;
      ? 0 1 1 0 : 0;
      1 1 1 1 0 : 1;
   endtable

endprimitive // udp_lv_pp_vddi_vdd_vss


primitive udp_edff_PWR (out, in, clk, clr_, set_, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, en, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  en  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   0   r    ?      1     1   1  0  ?  : ?  :  0  ; // clock in 0
   1   r    1      ?     1   1  0  ?  : ?  :  1  ; // clock in 1
   ?   *    ?      ?     0   1  0  ?  : ?  :  -  ; // no changes, not enabled
   *   ?    ?      ?     0   1  0  ?  : ?  :  -  ; // no changes, not enabled
   1   *    1      ?     ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0   *    ?      1     ?   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?   f    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *   b    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   1   x    1      ?     ?   1  0  ?  : 1  :  1  ; // no changes when in switches
   0   x    ?      1     ?   1  0  ?  : 0  :  0  ; // no changes when in switches
   ?   b    ?      ?     *   1  0  ?  : ?  :  -  ; // no changes when en switches
   ?   x    1      1     0   1  0  ?  : ?  :  -  ; // no changes when en is disabled
   ?   ?    ?      0     ?   1  0  ?  : ?  :  1  ; // set output
   ?   b    1      *     ?   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?   ?    1      *     0   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?   ?    0      1     ?   1  0  ?  : ?  :  0  ; // reset output
   ?   b    *      1     ?   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?   ?    *      1     0   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?   ?    ?      ?     ?   0  0  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   1  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   0  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_edff


primitive udp_tlat_pwr (out, VDD, VSS, in, hold, clr_, set_, NOTIFIER);
   output out;  
   input  VDD, VSS, in, hold, clr_, set_, NOTIFIER;
   reg    out;

   table

// VDD, VSS, in  hold  clr_   set_  NOT  : Qt : Qt+1
//
    1    0    1   0     1      ?     ?   : ?  :  1  ; // 
    1    0    0   0     ?      1     ?   : ?  :  0  ; // 
    1    0    1   *     1      ?     ?   : 1  :  1  ; // reduce pessimism
    1    0    0   *     ?      1     ?   : 0  :  0  ; // reduce pessimism
    1    0    *   1     ?      ?     ?   : ?  :  -  ; // no changes when in switches
    1    0    ?   ?     ?      0     ?   : ?  :  1  ; // set output
    1    0    ?   1     1      *     ?   : 1  :  1  ; // cover all transistions on set_
    1    0    1   ?     1      *     ?   : 1  :  1  ; // cover all transistions on set_
    1    0    ?   ?     0      1     ?   : ?  :  0  ; // reset output
    1    0    ?   1     *      1     ?   : 0  :  0  ; // cover all transistions on clr_
    1    0    0   ?     *      1     ?   : 0  :  0  ; // cover all transistions on clr_
    0    ?    ?   ?     ?      ?     ?   : ?  :  x  ;
    x    ?    ?   ?     ?      ?     ?   : ?  :  x  ;
    ?    1    ?   ?     ?      ?     ?   : ?  :  x  ;
    ?    x    ?   ?     ?      ?     ?   : ?  :  x  ;
    ?    ?    ?   ?     ?      ?     *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat


primitive udp_outrf (out, in, rwn, rw);
   output out;  
   input  in, rwn, rw;

   table

// in  rwn   rw   : out;
//	     	  
   0   0     ?    : 1  ; // 
   1   ?     1    : 1  ; // 
   ?   1     0    : 0  ; // 
   1   ?     0    : 0  ; // 
   0   1     ?    : 0  ; // 

   endtable
endprimitive // udp_outrf


primitive udp_and_pp (y, a, b, vdd, vss);
   output y;
   input  a, b, vdd, vss;

   table
      // a b vdd vss : y
      0 ? 1 0 : 0;
      ? 0 1 0 : 0;
      1 1 1 0 : 1;
   endtable

endprimitive // udp_and_pp

// This is the UDP for the input/master stage of flip flop.
// Store one bit if we have power.
primitive udp_dffr2 (out, d, ck, clr_, set_, pwr, notifier);
input d, ck, clr_, set_, pwr, notifier;
output out;

   reg out;

   
  table
  // d  ck clr_ set_ pwr NOT
                                     // Load the bit from d
     0   f   1   1    1   ?  : ?  :  0  ; // Clock in 0
     1   f   1   1    1   ?  : ?  :  1  ; // Clock in 1
     0   0   1   1    1   ?  : ?  :  0  ; // Pass in a 0
     1   0   1   1    1   ?  : ?  :  1  ; // Pass in a 1

                                     // Allow harmless transitions
     ?   r   1   1    1   ?  : ?  :  -  ; // No change on clock rise
     *   1   1   1    1   ?  : ?  :  -  ; // No change when ck is high
     ?   1   1   1    1   ?  : ?  :  -  ; // No change when ck is high

                                     // Handle clr
     ?   ?   0   1    1   ?  : ?  :  0  ; // Reset output
     ?   ?   ?   0    1   ?  : ?  :  1  ; // set output
     ?   b   1   *    1   ?  : 1  :  1  ; // Cover all transistions on set_
     0   x   1   *    1   ?  : 1  :  1  ; // Cover all transistions on set_
     ?   b   *   1    1   ?  : 0  :  0  ; // Cover all transistions on clr_
     0   x   *   1    1   ?  : 0  :  0  ; // Cover all transistions on clr_

     ?   ?   ?   ?    ?   *  : ?  :  x  ; // Any notifier changed

     ?   ?   ?   ?    *   ?  : ?  :  x  ; // pwrg should never go away and any pwr
     ?   ?   ?   ?    0   ?  : ?  :  x  ; // value other than 1 creates an x
     ?   ?   ?   ?    x   ?  : ?  :  x  ;

  endtable
endprimitive // udp_dffr2

// This is the UDP for the output drive without power pins.
// This is a conservative model.  We don't know when the power
//  will be turned off so drive the output to x immediately when
//  retention is asserted.
primitive udp_dffr4 (out, st1, st0, ck, retn);
input st1, st0, ck, retn;
output out;
  table
  // st1 st0 ck retn
                           // Strange things happen when
      ?   ?   ?   x  : x ; //  retn is an x.

      ?   0   ?   1  : 0 ; // Non retention mode.
      ?   1   ?   1  : 1 ; // Drive whatever is in
      ?   x   ?   1  : x ; //  the retn/slave stage.

      ?   ?   ?   0  : x ; // Retention mode
                           //  drive the output to x

  endtable
endprimitive // udp_dffr4

primitive udp_xprop (DOUT, DIN, NOTIFIER, RESET);
    output DOUT; reg DOUT;
    input  DIN;
    input  NOTIFIER;
    input  RESET;
    table
    //  DIN  NOTIFIER  RESET : state :DOUT
         ?      *        ?   :   ?   :  x ;  // Timing violation -- takes precendence
         0      ?      (?1)  :   ?   :  0 ;  // Reset
         1      ?      (?1)  :   ?   :  1 ;
         0      ?      (0?)  :   0   :  0 ;  // Reset  Lena updated-----
         1      ?      (0?)  :   1   :  1 ;  // Lena updated---------
         0      ?      (1?)  :   0   :  0 ;  // Lena added-----------
         1      ?      (1?)  :   1   :  1 ;  // Lena added-----------
         ?      ?      (?0)  :   ?   :  - ;  // Ignore falling edge on reset
        (?1)    ?        ?   :   ?   :  1 ;
        (?0)    ?        ?   :   ?   :  0 ;
    // *****
    endtable
endprimitive


primitive udp_lv_pp_vdd_vss (y, a, b, vdd, vss);
   output y;
   input  a, b, vdd, vss;

   table
      // a b vdd vss : y
      0 ? 1 0 : 0;
      ? 0 1 0 : 0;
      1 1 1 0 : 1;
   endtable

endprimitive // udp_lv_pp_vdd_vss

primitive udp_ph1p (LOUT, CLK, DATA, SET, RESET);
    output LOUT; reg LOUT;
    input CLK;
    input DATA;
    input SET;
    input RESET;
    table
    //  CLK  DATA  SET  RESET : state : LOUT
         ?    ?     0    0    :   ?   :  0 ;// Reset only on
         ?    ?     1    ?    :   ?   :  1 ;// Set on (Set Dominant)
         0    ?     0    1    :   ?   :  - ;// No Change
         1    0     0    ?    :   ?   :  0 ;// First Port Function
         1    1     ?    1    :   ?   :  1 ;
         ?    0     0    1    :   0   :  - ;// Clock Unknown
         ?    1     0    1    :   1   :  - ;
         0    ?     0    X    :   0   :  - ;// Reset Unknown
         ?    0     0    X    :   0   :  - ;
         0    ?     X    1    :   1   :  - ;// Set Unknown
         ?    1     X    1    :   1   :  - ;
    endtable
endprimitive


// This is the UDP for the power pins.
// VDD and VSS must always be connected.
// VSS must always be zero.
// VDD can be 0 or 1 depending if we are powered down or not.
// Any illegal states create an x.  The other udps will use this
// value to decide what to do.
primitive udp_dffpower (out, vdd, vss);
input vdd,vss;
output out;
  table
  // vdd vss
      ?   x  : x ;
      x   ?  : x ;
      1   0  : 1 ;
      0   0  : 0 ;
      1   1  : x ;
      0   1  : x ;
  endtable
endprimitive // udp_dffrp




primitive udp_rslat_out (out, r, s, NOTIFIER);
   output out;  
   input  r, s, NOTIFIER;
   reg    out;

   table

// r   s   NOT : Qt : Qt+1
// 
  (?0) 0   ?   : ?  :  -  ; // no change
   0  (?0) ?   : ?  :  -  ; // no change
   1   0   ?   : ?  :  0  ; // reset
  (?0) 1   ?   : ?  :  1  ; // set
   0  (?1) ?   : ?  :  1  ; // set
  (?0) x   ?   : 1  :  1  ; // reduced pessimism
   0  (?x) ?   : 1  :  1  ; // reduced pessimism
  (?x) 0   ?   : 0  :  0  ; // reduced pessimism
   x  (?0) ?   : 0  :  0  ; // reduced pessimism
   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out

primitive udp_always0_pp (y, vddg, vssg);
   output y;
   input  vddg, vssg;

   table
    //vddg vssg : y
       1    0   : 0;
    endtable
  
endprimitive
 


primitive udp_edfft_PWR (out, in, clk, clr_, set_, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, en, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  en  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   ?   r    0      1     ?   1  0  ?  : ?  :  0  ; // clock in 0
   0   r    ?      1     1   1  0  ?  : ?  :  0  ; // clock in 0
   ?   r    ?      0     ?   1  0  ?  : ?  :  1  ; // clock in 1
   1   r    1      ?     1   1  0  ?  : ?  :  1  ; // clock in 1
   ?   *    1      1     0   1  0  ?  : ?  :  -  ; // no changes, not enabled
   ?   *    ?      1     0   1  0  ?  : 0  :  0  ; // no changes, not enabled
   ?   *    1      ?     0   1  0  ?  : 1  :  1  ; // no changes, not enabled
   ?  (x0)  ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes
   ?  (x1)  ?      0     ?   1  0  ?  : 1  :  1  ; // no changes
   1   *    1      ?     ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0   *    ?      1     ?   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?   f    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *   b    ?      ?     ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   1   x    1      ?     ?   1  0  ?  : 1  :  1  ; // no changes when in switches
   ?   x    1      ?     0   1  0  ?  : 1  :  1  ; // no changes when in switches
   0   x    ?      1     ?   1  0  ?  : 0  :  0  ; // no changes when in switches
   ?   x    ?      1     0   1  0  ?  : 0  :  0  ; // no changes when in switches
   ?   b    ?      ?     *   1  0  ?  : ?  :  -  ; // no changes when en switches
   ?   b    *      ?     ?   1  0  ?  : ?  :  -  ; // no changes when clr_ switches
   ?   x    0      1     ?   1  0  ?  : 0  :  0  ; // no changes when clr_ switches
   ?   b    ?      *     ?   1  0  ?  : ?  :  -  ; // no changes when set_ switches
   ?   x    ?      0     ?   1  0  ?  : 1  :  1  ; // no changes when set_ switches
   ?   ?    ?      ?     ?   0  0  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   1  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   0  1  ?  : ?  :  x  ; 
   ?   ?    ?      ?     ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_edfft


primitive udp_rslatn_out__PWR (out_, r_, s_, VDD, VSS, NOTIFIER);
   output out_;  
   input  r_, s_, VDD, VSS, NOTIFIER;
   reg    out_;

   table

// r_  s_  VDD  VSS  NOTIFIER : Qt : Qt+1
// 
  (?1) 1   1  0  ?  : ?  :  -  ; // no change
   1  (?1) 1  0  ?  : ?  :  -  ; // no change
   0   1   1  0  ?  : ?  :  1  ; // reset
  (?1) 0   1  0  ?  : ?  :  0  ; // set
   1  (?0) 1  0  ?  : ?  :  0  ; // set
  (?1) x   1  0  ?  : 0  :  0  ; // reduced pessimism
   1  (?x) 1  0  ?  : 0  :  0  ; // reduced pessimism
  (?x) 1   1  0  ?  : 1  :  1  ; // reduced pessimism
   x  (?1) 1  0  ?  : 1  :  1  ; // reduced pessimism
   ?   ?   0  0  ?  : ?  :  x  ; 
   ?   ?   1  1  ?  : ?  :  x  ; 
   ?   ?   0  1  ?  : ?  :  x  ; 
   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslatn_out_

//Clear dominates set

primitive udp_dff_ros (out, in, clk, clr_, set_, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  NOT  : Qt : Qt+1
//
   0  r   ?   1   ?   : ?  :  0  ; // clock in 0
   1  r   1   ?   ?   : ?  :  1  ; // clock in 1
   1  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   ?  f   ?   ?   ?   : ?  :  -  ; // no changes on negedge clk
   *  b   ?   ?   ?   : ?  :  -  ; // no changes when in switches
   ?  ?   1   0   ?   : ?  :  1  ; // set output
   ?  b   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   1  x   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   ?   ?   : ?  :  0  ; // reset output
   ?  b   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  x   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_dff


primitive udp_rslatn_out_PWR (out, r_, s_, VDD, VSS, NOTIFIER);
   output out;  
   input  r_, s_, VDD, VSS, NOTIFIER;
   reg    out;

   table

// r_  s_  VDD  VSS  NOTIFIER : Qt : Qt+1
// 
  (?1) 1   1  0  ?  : ?  :  -  ; // no change
   1  (?1) 1  0  ?  : ?  :  -  ; // no change
  (?0) 1   1  0  ?  : ?  :  0  ; // reset
   0  (?1) 1  0  ?  : ?  :  0  ; // reset
   1   0   1  0  ?  : ?  :  1  ; // unused state
  (?1) x   1  0  ?  : 1  :  1  ; // reduced pessimism
   1  (?x) 1  0  ?  : 1  :  1  ; // reduced pessimism
  (?x) 1   1  0  ?  : 0  :  0  ; // reduced pessimism
   x  (?1) 1  0  ?  : 0  :  0  ; // reduced pessimism
   ?   ?   0  0  ?  : ?  :  x  ; 
   ?   ?   1  1  ?  : ?  :  x  ; 
   ?   ?   0  1  ?  : ?  :  x  ; 
   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslatn_out

// This primitive table models the behaviour of
// a wired AND-OR function. There are 2 inputs
// with two enables.
// in1a and in2a are pins of And 'a'
// in1b and in2b are pins of And 'b'
// out is an Or of And a and And b. 

primitive udp_wao (out, in1a, in1b, in2a, in2b);
   output out;
   input in1a, in1b, in2a, in2b;
  
   table

// in1a in1b in2a in2b: out
//
   1     1    1    ?  :  1;
   1     1    ?    1  :  1;
   0     0    1    ?  :  0;
   0     0    ?    1  :  0;
   1     ?    1    0  :  1;
   0     ?    1    0  :  0;
   ?     1    0    1  :  1;
   ?     0    0    1  :  0;

   endtable
endprimitive


primitive udp_mx21 (MUXOUT, SEL, DATA0, DATA1);
    output MUXOUT;
    input SEL;
    input DATA0;
    input DATA1;
    table
    //  SEL  DATA0 DATA1 : MUXOUT
         0     0     ?    :  0 ;// Note that inputs not specif.
         0     1     ?    :  1 ;// (like x) will make out=x
         1     ?     0    :  0 ;
         1     ?     1    :  1 ;
         x     0     0    :  0 ;
         x     1     1    :  1 ;
    endtable
endprimitive


// This udp simulates the special latch behaviour of
// posticg cells.
primitive udp_plat_PWR (out, ovrd, clock, ena, VDD, VSS, NOTIFIER);
   output out;  
   input  ovrd, clock, ena, VDD, VSS, NOTIFIER;
   reg    out;

   table

// ovrd clock ena VDD, VSS, NOTIFIER : Qt : Qt+1
//
   1    ?    ?    1  0  ?  : ?  :  1  ;
   0    0    0    1  0  ?  : ?  :  0  ;
   0    0    1    1  0  ?  : ?  :  1  ;
   0    1    ?    1  0  ?  : ?  :  -  ;
   ?    1    *    1  0  ?  : ?  :  -  ; // no changes when in switches
   ?    ?    ?    0  0  ?  : ?  :  x  ; 
   ?    ?    ?    1  1  ?  : ?  :  x  ; 
   ?    ?    ?    0  1  ?  : ?  :  x  ; 
   ?    ?    ?    ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_plat

primitive udp_lvl_pp_vddi_vdd_vss (y, a, vddi, vdd, vss);
   output y;
   input  a, vddi, vdd, vss;

   table
   // a vddi vdd vss : y
      0 1 1 0 : 0;
      1 1 1 0 : 1;
   endtable

endprimitive // udp_lvl_pp_vddi_vdd_vss


primitive udp_tlatrf (out, in, ww, wwn, NOTIFIER);
   output out;  
   input  in, ww, wwn, NOTIFIER;
   reg    out;

   table

// in  ww    wwn  NOT  : Qt : Qt+1
//	     
   1   ?     0    ?    : ?  :  1  ; // 
   1   1     ?    ?    : ?  :  1  ; // 
   0   ?     0    ?    : ?  :  0  ; // 
   0   1     ?    ?    : ?  :  0  ; // 
   1   *     ?    ?    : 1  :  1  ; // reduce pessimism
   1   ?     *    ?    : 1  :  1  ; // reduce pessimism
   0   *     ?    ?    : 0  :  0  ; // reduce pessimism
   0   ?     *    ?    : 0  :  0  ; // reduce pessimism
   *   0     1    ?    : ?  :  -  ; // no changes when in switches
   ?   ?     ?    *    : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlatrf



primitive udp_power (out, out_temp, vdd, vss);
   output out;
   input out_temp, vdd, vss;

   table

// out_temp, vdd, vss : out
//
      1       1    0  :  1 ;
      0       1    0  :  0 ;

   endtable
endprimitive // udp_power


primitive udp_tlat_PWR (out, in, hold, clr_, set_, VDD, VSS, NOTIFIER);
   output out;  
   input  in, hold, clr_, set_, VDD, VSS, NOTIFIER;
   reg    out;

   table

// in  hold  clr_   set_  VDD  VSS  NOTIFIER  : Qt : Qt+1
//
   1  0   1   ?   1  0  ?  : ?  :  1  ; // 
   0  0   ?   1   1  0  ?  : ?  :  0  ; // 
   1  *   1   ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0  *   ?   1   1  0  ?  : 0  :  0  ; // reduce pessimism
   *  1   ?   ?   1  0  ?  : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   1  0  ?  : ?  :  1  ; // set output
   ?  1   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   1  ?   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   1  0  ?  : ?  :  0  ; // reset output
   ?  1   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   0  ?   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   0  0  ?  : ?  :  x  ; 
   ?  ?   ?   ?   1  1  ?  : ?  :  x  ; 
   ?  ?   ?   ?   0  1  ?  : ?  :  x  ; 
   ?  ?   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat


primitive udp_dff (out, in, clk, clr_, set_, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  NOT  : Qt : Qt+1
//
   0  r   ?   1   ?   : ?  :  0  ; // clock in 0
   1  r   1   ?   ?   : ?  :  1  ; // clock in 1
   1  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   ?  f   ?   ?   ?   : ?  :  -  ; // no changes on negedge clk
   *  b   ?   ?   ?   : ?  :  -  ; // no changes when in switches
   ?  ?   ?   0   ?   : ?  :  1  ; // set output
   ?  b   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   1  x   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   1   ?   : ?  :  0  ; // reset output
   ?  b   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  x   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_dff
primitive udp_ph2p_pwr (LOUT, VDD, VSS, CLK1, CLK2, DATA1, DATA2, SET, RESET);
    output LOUT; reg LOUT;
    input VDD, VSS, CLK1, CLK2, DATA1, DATA2, SET, RESET;
    table
    //  **NOTE that for input combo's not given , the output will be x=unknown
    //  VDD VSS CLK1 CLK2 DATA1 DATA2 SET  RESET : state : LOUT
         1   0   ?    ?    ?     ?     0    0    :   ?   :  0 ;// Reset only on
         1   0   ?    ?    ?     ?     1    1    :   ?   :  1 ;// Set only on
         1   0   ?    ?    ?     ?     1    0    :   ?   :  1 ;// Both S/R active
         1   0   ?    ?    ?     ?     1    X    :   ?   :  1 ;// Set on, reset X
         1   0   0    0    ?     ?     0    1    :   ?   :  - ;// No Change
         1   0   1    0    0     ?     0    ?    :   ?   :  0 ;// First Port Function
         1   0   1    0    1     ?     ?    1    :   ?   :  1 ;
         1   0   0    1    ?     0     0    ?    :   ?   :  0 ;// Second Port Function
         1   0   0    1    ?     1     ?    1    :   ?   :  1 ;
         1   0   1    1    0     0     0    ?    :   ?   :  0 ;// Both Clocks ON
         1   0   1    1    1     1     ?    1    :   ?   :  1 ;
         1   0   ?    0    0     ?     0    1    :   0   :  - ;// Clocks Unknown
         1   0   ?    0    1     ?     0    1    :   1   :  - ;
         1   0   ?    1    0     0     0    ?    :   ?   :  0 ;
         1   0   ?    1    1     1     ?    1    :   ?   :  1 ;
         1   0   0    ?    ?     0     0    1    :   0   :  - ;
         1   0   0    ?    ?     1     0    1    :   1   :  - ;
         1   0   1    ?    0     0     0    ?    :   ?   :  0 ;
         1   0   1    ?    1     1     ?    1    :   ?   :  1 ;
         1   0   ?    ?    0     0     0    1    :   0   :  - ;
         1   0   ?    ?    1     1     0    1    :   1   :  - ;
         1   0   0    0    ?     ?     0    X    :   0   :  - ;// Reset Unknown
         1   0   ?    ?    0     0     0    X    :   0   :  - ;
         1   0   ?    0    0     ?     0    X    :   0   :  - ;
         1   0   0    ?    ?     0     0    X    :   0   :  - ;
         1   0   0    0    ?     ?     X    1    :   1   :  - ;// Set Unknown
         1   0   ?    ?    1     1     X    1    :   1   :  - ;
         1   0   ?    0    1     ?     X    1    :   1   :  - ;
         1   0   0    ?    ?     1     X    1    :   1   :  - ;
	 0   ?   ?    ?    ?     ?     ?    ?    :   ?   :  x ;  
	 ?   1   ?    ?    ?     ?     ?    ?    :   ?   :  x ;  
    endtable
endprimitive



primitive udp_rslat_out__PWR (out_, r, s, VDD, VSS, NOTIFIER);
   output out_;  
   input  r, s, VDD, VSS, NOTIFIER;
   reg    out_;

   table

// r   s   VDD  VSS  NOTIFIER : Qt : Qt+1
// 
  (?0) 0   1  0  ?  : ?  :  -  ; // no change
   0  (?0) 1  0  ?  : ?  :  -  ; // no change
  (?1) 0   1  0  ?  : ?  :  1  ; // reset
   1  (?0) 1  0  ?  : ?  :  1  ; // reset
   0   1   1  0  ?  : ?  :  0  ; // set
  (?0) x   1  0  ?  : 0  :  0  ; // reduced pessimism
   0  (?x) 1  0  ?  : 0  :  0  ; // reduced pessimism
  (?x) 0   1  0  ?  : 1  :  1  ; // reduced pessimism
   x  (?0) 1  0  ?  : 1  :  1  ; // reduced pessimism
   ?   ?   0  0  ?  : ?  :  x  ; 
   ?   ?   1  1  ?  : ?  :  x  ; 
   ?   ?   0  1  ?  : ?  :  x  ; 
   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslat_out_


primitive udp_sedfft_PWR (out, in, clk, clr_, si, se, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, si, se,  en, VDD, VSS, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  si  se  en  VDD  VSS  NOTIFIER : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   0  0  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   1  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   0  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   ?  ?  *  : ?  :  x; // any notifier changed
      ?    r    ?     0   1   ?   1  0  ?  : ?  :  0;     
      ?    r    ?     1   1   ?   1  0  ?  : ?  :  1;
      ?    b    ?     ?   *   ?   1  0  ?  : ?  :  -; // no changes when se switches
      ?    b    ?     *   ?   ?   1  0  ?  : ?  :  -; // no changes when si switches
      *    b    ?     ?   ?   ?   1  0  ?  : ?  :  -; // no changes when in switches
      ?    b    ?     ?   ?   *   1  0  ?  : ?  :  -; // no changes when en switches
      ?    b    *     ?   ?   ?   1  0  ?  : ?  :  -; // no changes when clr switches
      0    r    ?     0   ?   1   1  0  ?  : ?  :  0 ; 
      1    r    1     1   ?   1   1  0  ?  : ?  :  1 ; 
      ?    r    ?     0   ?   0   1  0  ?  : 0  :  0;
      ?    x    ?     0   ?   0   1  0  ?  : 0  :  0;
      ?    r    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    x    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    *    1     ?   0   0   1  0  ?  : ?  :  -;
      ?    *    ?     1   1   ?   1  0  ?  : 1  :  1;
      1    *    1     1   ?   ?   1  0  ?  : 1  :  1;
      ?    *    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    *    0     0   ?   ?   1  0  ?  : 0  :  0;
      0    *    ?     0   ?   ?   1  0  ?  : 0  :  0;
      ?    x    1     ?   0   0   1  0  ?  : ?  :  -;
      ?    *    ?     ?   0   0   1  0  ?  : 0  :  0;
      ?    x    ?     ?   0   0   1  0  ?  : 0  :  0;
      ?    x    ?     1   1   ?   1  0  ?  : 1  :  1;
      1    x    1     1   ?   ?   1  0  ?  : 1  :  1;
      ?    x    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    x    0     0   ?   ?   1  0  ?  : 0  :  0;
      0    x    ?     0   ?   ?   1  0  ?  : 0  :  0;
      ?    r    0     0   ?   ?   1  0  ?  : ?  :  0 ; 
      ?   (?0)  ?     ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   0   1   1  0  ?  : ?  :  1;
      0    r    ?     ?   0   1   1  0  ?  : ?  :  0;
      ?    r    0     ?   0   ?   1  0  ?  : ?  :  0;
      ?    x    0     ?   0   ?   1  0  ?  : 0  :  0;
      1    x    1     ?   0   ?   1  0  ?  : 1  :  1; // no changes when in switches
      0    x    ?     ?   0   ?   1  0  ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   0   ?   1  0  ?  : 1  :  1; // reduce pessimism
      0    *    ?     ?   0   ?   1  0  ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive  /* udp_sedfft */
   


primitive udp_edff (out, in, clk, clr_, set_, en, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, en, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  en  NOT  : Qt : Qt+1
//
   0   r    ?      1     1   ?    : ?  :  0  ; // clock in 0
   1   r    1      ?     1   ?    : ?  :  1  ; // clock in 1
   ?   *    ?      ?     0   ?    : ?  :  -  ; // no changes, not enabled
   *   ?    ?      ?     0   ?    : ?  :  -  ; // no changes, not enabled
   1   *    1      ?     ?   ?    : 1  :  1  ; // reduce pessimism
   0   *    ?      1     ?   ?    : 0  :  0  ; // reduce pessimism
   ?   f    ?      ?     ?   ?    : ?  :  -  ; // no changes on negedge clk
   *   b    ?      ?     ?   ?    : ?  :  -  ; // no changes when in switches
   1   x    1      ?     ?   ?    : 1  :  1  ; // no changes when in switches
   0   x    ?      1     ?   ?    : 0  :  0  ; // no changes when in switches
   ?   b    ?      ?     *   ?    : ?  :  -  ; // no changes when en switches
   ?   x    1      1     0   ?    : ?  :  -  ; // no changes when en is disabled
   ?   ?    ?      0     ?   ?    : ?  :  1  ; // set output
   ?   b    1      *     ?   ?    : 1  :  1  ; // cover all transistions on set_
   ?   ?    1      *     0   ?    : 1  :  1  ; // cover all transistions on set_
   ?   ?    0      1     ?   ?    : ?  :  0  ; // reset output
   ?   b    *      1     ?   ?    : 0  :  0  ; // cover all transistions on clr_
   ?   ?    *      1     0   ?    : 0  :  0  ; // cover all transistions on clr_
   ?   ?    ?      ?     ?   *    : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_edff


primitive udp_jkff_PWR (out, j, k, clk, clr_, set_, VDD, VSS, NOTIFIER);
   output out;  
   input  j, k, clk, clr_, set_, VDD, VSS, NOTIFIER;
   reg    out;

   table

// j  k  clk  clr_   set_  VDD  VSS  NOTIFIER  : Qt : Qt+1
//       
   0  0  r   1   1   1  0  ?  : ?  :  -  ; // output remains same
   0  1  r   ?   1   1  0  ?  : ?  :  0  ; // clock in 0
   1  0  r   1   ?   1  0  ?  : ?  :  1  ; // clock in 1
//   1  1  r   ?   1   1  0  ?  : 1  :  0  ; // clock in 0
   ?  1  r   ?   1   1  0  ?  : 1  :  0  ; // clock in 0
//   1  1  r   1   ?   1  0  ?  : 0  :  1  ; // clock in 1
   1  ?  r   1   ?   1  0  ?  : 0  :  1  ; // clock in 1
   ?  0  *   1   ?   1  0  ?  : 1  :  1  ; // reduce pessimism
   0  ?  *   ?   1   1  0  ?  : 0  :  0  ; // reduce pessimism
   ?  ?  f   ?   ?   1  0  ?  : ?  :  -  ; // no changes on negedge clk
   *  ?  b   ?   ?   1  0  ?  : ?  :  -  ; // no changes when j switches
   *  0  x   1   ?   1  0  ?  : 1  :  1  ; // no changes when j switches
   ?  *  b   ?   ?   1  0  ?  : ?  :  -  ; // no changes when k switches
   0  *  x   ?   1   1  0  ?  : 0  :  0  ; // no changes when k switches
   ?  ?  ?   ?   0   1  0  ?  : ?  :  1  ; // set output
   ?  ?  b   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  0  x   1   *   1  0  ?  : 1  :  1  ; // cover all transistions on set_
   ?  ?  ?   0   1   1  0  ?  : ?  :  0  ; // reset output
   ?  ?  b   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   0  ?  x   *   1   1  0  ?  : 0  :  0  ; // cover all transistions on clr_
   ?  ?  ?   ?   ?   0  0  ?  : ?  :  x  ; 
   ?  ?  ?   ?   ?   1  1  ?  : ?  :  x  ; 
   ?  ?  ?   ?   ?   0  1  ?  : ?  :  x  ; 
   ?  ?  ?   ?   ?   ?  ?  *  : ?  :  x  ; // any notifier change

   endtable
endprimitive // udp_jkff


primitive udp_retn (out, n2, n4, clk, xRN, xSN);
   output out;  
   input  n2, n4, clk, xRN, xSN;

   table
// n2, n4, clk, xRN, xSN
//
   0   ?    1    1   1 : 0;
   1   ?    1    1   1 : 1;
   ?   0    0    1   1 : 0;
   ?   1    0    1   1 : 1;
   ?   ?    ?    ?   0 : 1;
   ?   ?    ?    0   1 : 0;

   ?   1    0    1   ? : 1; //reducing pessimisim
   1   ?    1    1   ? : 1;
   1   1    ?    1   ? : 1;
   ?   0    0    ?   1 : 0;
   0   ?    1    ?   1 : 0;
   0   0    ?    ?   1 : 0;
   endtable
endprimitive // udp_mux

primitive udp_lv_pp_or_vddi_vdd_vss (y, a, b, vddi, vdd, vss);
   output y;
   input  a, b, vddi, vdd, vss;

   table
      // a b vddi vdd vss : y
      1 ? 1 1 0 : 1;
      ? 1 1 1 0 : 1;
      0 0 1 1 0 : 0;
      ? 1 ? 1 0 : 1;
   endtable

endprimitive // udp_lv_pp_vddi_vdd_vss

primitive udp_csa4to2_carry(carry, a, b, c, ci, d);
output carry;
input a, b, c, ci, d;
table
// a  b  c  ci  d : carry
   ?  ?  ?   1  1  : 1;
   0  1  0   ?  1  : 1;
   0  0  1   ?  1  : 1;
   1  0  0   ?  1  : 1;
   1  1  1   1  ?  : 1;
   1  1  1   ?  1  : 1;
   1  0  0   1  ?  : 1;
   0  1  0   1  ?  : 1;
   0  0  1   1  ?  : 1;
   0  1  1   0  ?  : 0;
   0  0  0   0  ?  : 0;
   0  0  0   ?  0  : 0;
   1  0  1   ?  0  : 0;
   1  1  0   ?  0  : 0;
   ?  ?  ?   0  0  : 0;
   0  1  1   ?  0  : 0;
   1  1  0   0  ?  : 0;
   1  0  1   0  ?  : 0;
   
endtable
endprimitive



primitive udp_sedff_PWR (out, in, clk, clr_, si, se, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, si, se,  en, VDD, VSS, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  si  se  en  VDD  VSS  NOTIFIER : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   0  0  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   1  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   0  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   ?  ?  *  : ?  :  x; // any notifier changed
      ?    ?    0     ?   ?   ?   1  0  ?  : ?  :  0;     
      ?    r    ?     0   1   ?   1  0  ?  : ?  :  0;     
      ?    r    1     1   1   ?   1  0  ?  : ?  :  1;
      ?    b    1     ?   *   ?   1  0  ?  : ?  :  -; // no changes when se switches
      ?    b    1     *   ?   ?   1  0  ?  : ?  :  -; // no changes when si switches
      *    b    1     ?   ?   ?   1  0  ?  : ?  :  -; // no changes when in switches
      *    ?    ?     ?   0   0   1  0  ?  : 0  :  0; // no changes when in switches
      ?    ?    ?     *   0   0   1  0  ?  : 0  :  0; // no changes when in switches
      ?    b    1     ?   ?   *   1  0  ?  : ?  :  -; // no changes when en switches
      ?    b    *     ?   ?   ?   1  0  ?  : 0  :  0; // no changes when en switches
      ?    ?    *     ?   0   0   1  0  ?  : 0  :  0; // no changes when en switches
      ?    b    ?     ?   ?   *   1  0  ?  : 0  :  0; // no changes when en switches
      ?    b    ?     ?   *   ?   1  0  ?  : 0  :  0; // no changes when en switches
      ?    b    ?     *   ?   ?   1  0  ?  : 0  :  0; // no changes when en switches
      *    b    ?     ?   ?   ?   1  0  ?  : 0  :  0; // no changes when en switches
      ?  (10)   ?     ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      ?    *    1     1   1   ?   1  0  ?  : 1  :  1;
      ?    x    1     1   1   ?   1  0  ?  : 1  :  1;
      ?    *    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    x    1     1   ?   0   1  0  ?  : 1  :  1;
      ?    *    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    x    ?     0   1   ?   1  0  ?  : 0  :  0;
      ?    *    ?     0   ?   0   1  0  ?  : 0  :  0;
      ?    x    ?     0   ?   0   1  0  ?  : 0  :  0;
      0    r    ?     0   ?   1   1  0  ?  : ?  :  0 ; 
      0    *    ?     0   ?   ?   1  0  ?  : 0  :  0 ; 
      0    x    ?     0   ?   ?   1  0  ?  : 0  :  0 ; 
      1    r    1     1   ?   1   1  0  ?  : ?  :  1 ; 
      1    *    1     1   ?   ?   1  0  ?  : 1  :  1 ; 
      1    x    1     1   ?   ?   1  0  ?  : 1  :  1 ; 
      ?  (x0)   ?     ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   0   1   1  0  ?  : ?  :  1;
      0    r    ?     ?   0   1   1  0  ?  : ?  :  0;
      ?    *    ?     ?   0   0   1  0  ?  : ?  :  -;
      ?    x    1     ?   0   0   1  0  ?  : ?  :  -;
      1    x    1     ?   0   ?   1  0  ?  : 1  :  1; // no changes when in switches
      0    x    ?     ?   0   ?   1  0  ?  : 0  :  0; // no changes when in switches
      1    x    ?     ?   0   0   1  0  ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   0   ?   1  0  ?  : 1  :  1; // reduce pessimism
      0    *    ?     ?   0   ?   1  0  ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive  /* udp_sedff */
   

primitive udp_always1_pp (y, vddg, vssg);
   output y;
   input  vddg, vssg;

   table
    //vddg vssg : y
       1    0   : 1;
    endtable
  
endprimitive
 
primitive udp_ando_pp (y, a, b, vddo, vsso, vdd, vss);
   output y;
   input  a, b, vddo, vsso, vdd, vss;

   table
      // a b vddo vsso vdd vss : y
         0 ?   1    0   ?   ?  : 0;
         ? 0   1    0   ?   ?  : 0;
         1 1   1    0   1   0  : 1;
   endtable

endprimitive // udp_ando_pp

primitive udp_lvl_pp_vdd_vss (y, a, vdd, vss);
   output y;
   input  a, vdd, vss;

   table
   // a vdd vss : y
      0 1 0 : 0;
      1 1 0 : 1;
   endtable

endprimitive // udp_lvl_pp_vdd_vss


primitive udp_sedffsr_PWR (out, in, clk, clr_, set_, si, se, en, VDD, VSS, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, si, se,  en, VDD, VSS, NOTIFIER;
   reg    out;

   table
   // in  clk  clr_  set_ si  se  en  VDD  VSS  NOTIFIER : Qt : Qt+1
      ?    ?    ?     ?   ?   ?   ?   0  0  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   ?   1  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   ?   0  1  ?  : ?  :  x; 
      ?    ?    ?     ?   ?   ?   ?   ?  ?  *  : ?  :  x; // any notifier changed
      ?    ?    0     1   ?   ?   ?   1  0  ?  : ?  :  0; 
      ?    ?    ?     0   ?   ?   ?   1  0  ?  : ?  :  1; 
      ?    r    ?     1   0   1   ?   1  0  ?  : ?  :  0;
      ?    r    1     ?   1   1   ?   1  0  ?  : ?  :  1;      
      ?    b    ?     1   ?   *   ?   1  0  ?  : 0  :  0; // no changes when se switches
      ?    b    1     ?   ?   *   ?   1  0  ?  : 1  :  1; // no changes when se switches
      ?    b    ?     1   *   ?   ?   1  0  ?  : 0  :  0; // no changes when si switches
      ?    b    1     ?   *   ?   ?   1  0  ?  : 1  :  1; // no changes when si switches
      *    b    ?     1   ?   ?   ?   1  0  ?  : 0  :  0; // no changes when in switches
      *    b    1     ?   ?   ?   ?   1  0  ?  : 1  :  1; // no changes when in switches
      ?    b    ?     1   ?   ?   *   1  0  ?  : 0  :  0; // no changes when en switches
      ?    b    1     ?   ?   ?   *   1  0  ?  : 1  :  1; // no changes when en switches
      ?    ?    *     1   ?   0   0   1  0  ?  : 0  :  0; //new
      ?    x    1     1   ?   0   0   1  0  ?  : 0  :  0;
      ?    x    1     1   ?   0   0   1  0  ?  : 1  :  1;
      ?    ?    *     1   0   ?   0   1  0  ?  : 0  :  0; //new
      0    ?    *     1   ?   0   1   1  0  ?  : 0  :  0; //new
      ?    b    *     1   ?   ?   ?   1  0  ?  : 0  :  0; //new
      ?    ?    1     *   ?   0   0   1  0  ?  : 1  :  1; //new
      ?    ?    1     *   1   ?   0   1  0  ?  : 1  :  1; //new
      1    ?    1     *   ?   0   1   1  0  ?  : 1  :  1; //new
      ?    b    1     *   ?   ?   ?   1  0  ?  : 1  :  1; //new
      ?    *    1     ?   1   1   ?   1  0  ?  : 1  :  1;
      ?    x    1     ?   1   1   ?   1  0  ?  : 1  :  1;
      ?    x    1     ?   ?   0   0   1  0  ?  : 1  :  1;
      ?    x    1     ?   1   ?   0   1  0  ?  : 1  :  1;
      ?    *    1     ?   1   ?   0   1  0  ?  : 1  :  1;
      ?    *    ?     1   0   1   ?   1  0  ?  : 0  :  0;
      ?    x    ?     1   0   1   ?   1  0  ?  : 0  :  0;
      ?    x    ?     1   ?   0   0   1  0  ?  : 0  :  0;
      ?    x    ?     1   0   ?   0   1  0  ?  : 0  :  0;
      ?    *    ?     1   0   ?   0   1  0  ?  : 0  :  0;
      0    r    ?     1   0   ?   1   1  0  ?  : ?  :  0 ; 
      0    *    ?     1   0   ?   ?   1  0  ?  : 0  :  0 ;
      0    x    ?     1   0   ?   ?   1  0  ?  : 0  :  0 ; 
      1    r    1     ?   1   ?   1   1  0  ?  : ?  :  1 ; 
      1    *    1     ?   1   ?   ?   1  0  ?  : 1  :  1 ; 
      1    x    1     ?   1   ?   ?   1  0  ?  : 1  :  1 ; 
      ?  (10)   ?     ?   ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      ?  (x0)   ?     ?   ?   ?   ?   1  0  ?  : ?  :  -;  // no changes on falling clk edge
      1    r    1     ?   ?   0   1   1  0  ?  : ?  :  1;
      0    r    ?     1   ?   0   1   1  0  ?  : ?  :  0 ; 
      ?    *    ?     1   ?   0   0   1  0  ?  : 0  :  0;
      ?    *    1     ?   ?   0   0   1  0  ?  : 1  :  1;
      1    x    1     ?   ?   0   ?   1  0  ?  : 1  :  1; // no changes when in switches
      0    x    ?     1   ?   0   ?   1  0  ?  : 0  :  0; // no changes when in switches
      1    *    1     ?   ?   0   ?   1  0  ?  : 1  :  1; // reduce pessimism
      0    *    ?     1   ?   0   ?   1  0  ?  : 0  :  0; // reduce pessimism

   endtable
endprimitive // udp_sedffsr

   

// clear dominates set

primitive udp_tlat_ros (out, in, hold, clr_, set_, NOTIFIER);
   output out;  
   input  in, hold, clr_, set_, NOTIFIER;
   reg    out;

   table

// in  hold  clr_   set_  NOT  : Qt : Qt+1
//
   1  0   1   ?   ?   : ?  :  1  ; // 
   0  0   ?   1   ?   : ?  :  0  ; // 
   1  *   1   ?   ?   : 1  :  1  ; // reduce pessimism
   0  *   ?   1   ?   : 0  :  0  ; // reduce pessimism
   *  1   ?   ?   ?   : ?  :  -  ; // no changes when in switches
   ?  ?   1   0   ?   : ?  :  1  ; // set output
   ?  1   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   1  ?   1   *   ?   : 1  :  1  ; // cover all transistions on set_
   ?  ?   0   ?   ?   : ?  :  0  ; // reset output
   ?  1   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   0  ?   *   1   ?   : 0  :  0  ; // cover all transistions on clr_
   ?  ?   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_tlat


primitive udp_edfft (out, in, clk, clr_, set_, en, NOTIFIER);
   output out;  
   input  in, clk, clr_, set_, en, NOTIFIER;
   reg    out;

   table

// in  clk  clr_   set_  en  NOT  : Qt : Qt+1
//
   ?   r    0      1     ?   ?    : ?  :  0  ; // clock in 0
   0   r    ?      1     1   ?    : ?  :  0  ; // clock in 0
   ?   r    ?      0     ?   ?    : ?  :  1  ; // clock in 1
   1   r    1      ?     1   ?    : ?  :  1  ; // clock in 1
   ?   *    1      1     0   ?    : ?  :  -  ; // no changes, not enabled
   ?   *    ?      1     0   ?    : 0  :  0  ; // no changes, not enabled
   ?   *    1      ?     0   ?    : 1  :  1  ; // no changes, not enabled
   ?  (x0)  ?      ?     ?   ?    : ?  :  -  ; // no changes
   ?  (x1)  ?      0     ?   ?    : 1  :  1  ; // no changes
   1   *    1      ?     ?   ?    : 1  :  1  ; // reduce pessimism
   0   *    ?      1     ?   ?    : 0  :  0  ; // reduce pessimism
   ?   f    ?      ?     ?   ?    : ?  :  -  ; // no changes on negedge clk
   *   b    ?      ?     ?   ?    : ?  :  -  ; // no changes when in switches
   1   x    1      ?     ?   ?    : 1  :  1  ; // no changes when in switches
   ?   x    1      ?     0   ?    : 1  :  1  ; // no changes when in switches
   0   x    ?      1     ?   ?    : 0  :  0  ; // no changes when in switches
   ?   x    ?      1     0   ?    : 0  :  0  ; // no changes when in switches
   ?   b    ?      ?     *   ?    : ?  :  -  ; // no changes when en switches
   ?   b    *      ?     ?   ?    : ?  :  -  ; // no changes when clr_ switches
   ?   x    0      1     ?   ?    : 0  :  0  ; // no changes when clr_ switches
   ?   b    ?      *     ?   ?    : ?  :  -  ; // no changes when set_ switches
   ?   x    ?      0     ?   ?    : 1  :  1  ; // no changes when set_ switches
   ?   ?    ?      ?     ?   *    : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_edfft


primitive udp_rslatn_out_ (out_, r_, s_, NOTIFIER);
   output out_;  
   input  r_, s_, NOTIFIER;
   reg    out_;

   table

// r_  s_  NOT : Qt : Qt+1
// 
  (?1) 1   ?   : ?  :  -  ; // no change
   1  (?1) ?   : ?  :  -  ; // no change
   0   1   ?   : ?  :  1  ; // reset
  (?1) 0   ?   : ?  :  0  ; // set
   1  (?0) ?   : ?  :  0  ; // set
  (?1) x   ?   : 0  :  0  ; // reduced pessimism
   1  (?x) ?   : 0  :  0  ; // reduced pessimism
  (?x) 1   ?   : 1  :  1  ; // reduced pessimism
   x  (?1) ?   : 1  :  1  ; // reduced pessimism
   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslatn_out_


primitive udp_rslatn_out (out, r_, s_, NOTIFIER);
   output out;  
   input  r_, s_, NOTIFIER;
   reg    out;

   table

// r_  s_  NOT : Qt : Qt+1
// 
  (?1) 1   ?   : ?  :  -  ; // no change
   1  (?1) ?   : ?  :  -  ; // no change
  (?0) 1   ?   : ?  :  0  ; // reset
   0  (?1) ?   : ?  :  0  ; // reset
   1   0   ?   : ?  :  1  ; // unused state
  (?1) x   ?   : 1  :  1  ; // reduced pessimism
   1  (?x) ?   : 1  :  1  ; // reduced pessimism
  (?x) 1   ?   : 0  :  0  ; // reduced pessimism
   x  (?1) ?   : 0  :  0  ; // reduced pessimism
   ?   ?   *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_rslatn_out
primitive udp_oro_pp (y, a, b, vddo, vsso, vdd, vss);
   output y;
   input  a, b, vddo, vsso, vdd, vss;

   table
      // a b vddo vss0 vdd vss : y
         1 ?   1   0    ?   ?  : 1;
         ? 1   1   0    ?   ?  : 1;
         0 0   1   0    1   0  : 0;
   endtable

endprimitive // udp_oro_pp

primitive udp_not_pp (y, a, vddg, vssg);
   output y;
   input  a, vddg, vssg;

   table
   // a vddg vssg : y
      0  1    0   : 1;
      1  1    0   : 0;
    endtable
  
endprimitive
 

// This udp simulates the special latch behaviour of
// posticg cells.
primitive udp_plat (out, ovrd, clock, ena, NOTIFIER);
   output out;  
   input  ovrd, clock, ena, NOTIFIER;
   reg    out;

   table

// ovrd clock ena NOTIFIER : Qt : Qt+1
//
   1    ?    ?    ?   : ?  :  1  ;
   0    0    0    ?   : ?  :  0  ;
   0    0    1    ?   : ?  :  1  ;
   0    1    ?    ?   : ?  :  -  ;
   ?    1    *    ?   : ?  :  -  ; // no changes when in switches
   ?    ?    ?    *   : ?  :  x  ; // any notifier changed

   endtable
endprimitive // udp_plat
primitive udp_ph1p_pwr (LOUT, VDD, VSS, CLK, DATA, SET, RESET);
    output LOUT; reg LOUT;
    input CLK;
    input DATA;
    input SET;
    input RESET;
    input VDD, VSS;
    table
    //  VDD   VSS  CLK  DATA  SET  RESET : state : LOUT
         1     0    ?    ?     0    0    :   ?   :  0 ;// Reset only on
         1     0    ?    ?     1    ?    :   ?   :  1 ;// Set on (Set Dominant)
         1     0    0    ?     0    1    :   ?   :  - ;// No Change
         1     0    1    0     0    ?    :   ?   :  0 ;// First Port Function
         1     0    1    1     ?    1    :   ?   :  1 ;
         1     0    ?    0     0    1    :   0   :  - ;// Clock Unknown
         1     0    ?    1     0    1    :   1   :  - ;
         1     0    0    ?     0    X    :   0   :  - ;// Reset Unknown
         1     0    ?    0     0    X    :   0   :  - ;
         1     0    0    ?     X    1    :   1   :  - ;// Set Unknown
         1     0    ?    1     X    1    :   1   :  - ;
	 0     ?    ?    ?     ?    ?    :   ?   :  x ;//Power down
	 ?     1    ?    ?     ?    ?    :   ?   :  x ;//Power down
    endtable
endprimitive



primitive udp_xgen (out, in, en, e);
   output out;  
   input  in, en, e;

   table

// in  en    e   : out;
//	     	  
   0   0     0    : x  ; // 
   0   0     1    : 0  ; // 
   0   1     0    : 0  ; // 
   0   1     1    : x  ; // 
   1   0     0    : x  ; // 
   1   0     1    : 1  ; // 
   1   1     0    : 1  ; // 
   1   1     1    : x  ; // 

   endtable
endprimitive // udp_xgen


// This is the UDP for the retention stage of the flop.
// Store one bit in the slave/retention part.
primitive udp_dffr1 (out, in, clk, clr_, set_, retn, pwr, pwrg, NOTIFIER);
  output out;  
  input  in, clk, clr_, set_, retn, pwr, pwrg, NOTIFIER;

   reg 	 out;
   
  table

// in clk clr_ set_ retn pwr pwrg NOT : Qt : Qt+1
                                              // Clock in data, watch for set and clr
   0   r   ?    1    1    1   1    ?  : ?  :  0  ; // Clock in 0
   1   r   1    ?    1    1   1    ?  : ?  :  1  ; // Clock in 1

                                              // Allow wierd clock values if the state matches the input
   1   *   1    ?    1    1   1    ?  : 1  :  1  ; // Reduce pessimism
   0   *   ?    1    1    1   1    ?  : 0  :  0  ; // Reduce pessimism

                                              // Allow harmless transitions
   ?   f   ?    ?    1    1   1    ?  : ?  :  -  ; // No changes on negedge clk
   *   b   ?    ?    1    1   1    ?  : ?  :  -  ; // No changes when in switches

                                              // Handle clr
   ?   ?   0    1    1    1   1    ?  : ?  :  0  ; // Reset output
   ?   ?   ?    0    1    1   1    ?  : ?  :  1  ; // set output
   ?   b   1    *    1    1   1    ?  : 1  :  1  ; // Cover all transistions on set_
   0   x   1    *    1    1   1    ?  : 1  :  1  ; // Cover all transistions on set_
   ?   b   *    1    1    1   1    ?  : 0  :  0  ; // Cover  transistions on clr_
   0   x   *    1    1    1   1    ?  : 0  :  0  ; // Cover  transistions on clr_

   ?   ?   ?    ?    ?    ?   ?    *  : ?  :  x  ; // Any notifier changed

   ?   ?   ?    ?    ?    ?   *    ?  : ?  :  x  ; // pwrg should never go away and any pwr
   ?   ?   ?    ?    ?    ?   0    ?  : ?  :  x  ; // value other than 1 creates an x
   ?   ?   ?    ?    ?    ?   x    ?  : ?  :  x  ;

                                              // No change coming out of retention if
   ?   0   ?    ?    r    1   1    ?  : ?  :  -  ; // clock is low and the supplies are OK
   ?   1   ?    ?    r    1   1    ?  : ?  :  x  ; // Coming out with a high clock is bad
   ?   x   ?    ?    r    1   1    ?  : ?  :  x  ; // Coming out with a x on the clock is bad

   ?   0   ?    ?    f    1   1    ?  : ?  :  -  ; // No change going into retention if
   ?   1   ?    ?    f    1   1    ?  : ?  :  -  ; // the supplies are OK, clock can be 0 or 1
   ?   x   ?    ?    f    1   1    ?  : ?  :  x  ; // Going into retenetion with an x clock is bad.

   ?   ?   ?    ?    0    ?   1    ?  : ?  :  -  ; // While in retention we care nothing about
   

  endtable
endprimitive // udp_dffr1
