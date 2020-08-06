package PA;
class coverage;
  logic [0:3] reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d;
  logic [0:31] reqa_dataa_in, reqa_datab_in, reqb_dataa_in, reqb_datab_in,reqc_dataa_in, reqc_datab_in,reqd_dataa_in, reqd_datab_in;
 
 covergroup covgr;
   coverpoint reqcmd_a {bins cmd_a={1,2,5,6};}
   coverpoint reqcmd_b {bins cmd_b={1,2,5,6};}
   coverpoint reqcmd_c {bins cmd_c={1,2,5,6};}
   coverpoint reqcmd_d {bins cmd_d={1,2,5,6};}
   coverpoint reqa_dataa_in {bins data_a_1 = {[32'h00000000 : 32'hFFFFFFFF]};}
   coverpoint reqa_datab_in {bins data_b_2 = {[32'h00000000 : 32'hFFFFFFFF]};}
   coverpoint reqb_dataa_in {bins data_a_1 = {[32'h00000000 : 32'hFFFFFFFF]};}
   coverpoint reqb_datab_in {bins data_b_2 = {[32'h00000000 : 32'hFFFFFFFF]};}
   coverpoint reqc_dataa_in {bins data_a_1 = {[32'h00000000 : 32'hFFFFFFFF]};}
   coverpoint reqc_datab_in {bins data_b_2 = {[32'h00000000 : 32'hFFFFFFFF]};}
   coverpoint reqd_dataa_in {bins data_a_1 = {[32'h00000000 : 32'hFFFFFFFF]};}
   coverpoint reqd_datab_in {bins data_b_2 = {[32'h00000000 : 32'hFFFFFFFF]};}
 endgroup 
 
  function new();
    covgr=new;
endfunction : new

function void funcov( reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d,
     reqa_dataa_in, reqa_datab_in, reqb_dataa_in, reqb_datab_in,reqc_dataa_in, reqc_datab_in,reqd_dataa_in, reqd_datab_in);
    $display (" Coverage");
    this.reqcmd_a=reqcmd_a;
    this.reqcmd_b=reqcmd_b;
    this.reqcmd_c=reqcmd_c;
    this.reqcmd_d=reqcmd_d;
    this.reqa_dataa_in=reqa_dataa_in;
    this.reqa_datab_in=reqa_datab_in;
    this.reqb_dataa_in=reqb_dataa_in;
    this.reqb_datab_in=reqb_datab_in;
    this.reqc_dataa_in=reqc_dataa_in;
    this.reqc_datab_in=reqc_datab_in;
    this.reqd_dataa_in=reqd_dataa_in;
    this.reqd_datab_in=reqd_datab_in;  
  covgr.sample;
 endfunction 
endclass
endpackage