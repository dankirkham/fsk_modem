

module top(clock,tx,rx);
    
    // Module arguments
    input wire  clock;
    output reg  tx;
    input wire  rx;
    
    // Stub signals
    reg  demodulator$clock;
    reg signed [15:0] demodulator$data_in;
    reg  demodulator$strobe_in;
    wire  demodulator$mark_out;
    reg  modulator$clock;
    reg  modulator$mark_in;
    wire signed [15:0] modulator$data_out;
    wire  modulator$strobe_out;
    reg  mark$d;
    wire  mark$q;
    reg  mark$clock;
    reg  rx_buffer$sig_in;
    wire  rx_buffer$sig_out;
    reg  rx_buffer$clock;
    
    // Sub module instances
    top$demodulator demodulator(
        .clock(demodulator$clock),
        .data_in(demodulator$data_in),
        .strobe_in(demodulator$strobe_in),
        .mark_out(demodulator$mark_out)
    );
    top$modulator modulator(
        .clock(modulator$clock),
        .mark_in(modulator$mark_in),
        .data_out(modulator$data_out),
        .strobe_out(modulator$strobe_out)
    );
    top$mark mark(
        .d(mark$d),
        .q(mark$q),
        .clock(mark$clock)
    );
    top$rx_buffer rx_buffer(
        .sig_in(rx_buffer$sig_in),
        .sig_out(rx_buffer$sig_out),
        .clock(rx_buffer$clock)
    );
    
    // Update code
    always @(*) begin
        demodulator$clock = clock;
        modulator$clock = clock;
        rx_buffer$clock = clock;
        mark$clock = clock;
        mark$d = mark$q;
        rx_buffer$sig_in = rx;
        tx = demodulator$mark_out;
        modulator$mark_in = rx_buffer$sig_out;
        demodulator$data_in = modulator$data_out;
        demodulator$strobe_in = modulator$strobe_out;
    end
    
endmodule // top


module top$demodulator(clock,data_in,strobe_in,mark_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg  mark_out;
    
    // Stub signals
    reg  lo$clock;
    wire signed [15:0] lo$data_out;
    reg  lo$mark;
    wire  lo$strobe_out;
    reg  mixer$clock;
    reg signed [15:0] mixer$data_in_1;
    reg signed [15:0] mixer$data_in_2;
    wire signed [15:0] mixer$data_out;
    reg  mixer$strobe_in;
    wire  mixer$strobe_out;
    reg  lpf_down_1$clock;
    reg signed [15:0] lpf_down_1$data_in;
    wire signed [15:0] lpf_down_1$data_out;
    reg  lpf_down_1$strobe_in;
    wire  lpf_down_1$strobe_out;
    reg  lpf_down_2$clock;
    reg signed [15:0] lpf_down_2$data_in;
    wire signed [15:0] lpf_down_2$data_out;
    reg  lpf_down_2$strobe_in;
    wire  lpf_down_2$strobe_out;
    reg  space_pipeline$clock;
    reg signed [15:0] space_pipeline$data_in;
    wire signed [15:0] space_pipeline$data_out;
    reg  space_pipeline$strobe_in;
    wire  space_pipeline$strobe_out;
    reg  mark_pipeline$clock;
    reg signed [15:0] mark_pipeline$data_in;
    wire signed [15:0] mark_pipeline$data_out;
    reg  mark_pipeline$strobe_in;
    wire  mark_pipeline$strobe_out;
    reg  decider$clock;
    reg signed [15:0] decider$space_data_in;
    reg  decider$space_strobe_in;
    reg signed [15:0] decider$mark_data_in;
    reg  decider$mark_strobe_in;
    wire  decider$mark_out;
    
    // Sub module instances
    top$demodulator$lo lo(
        .clock(lo$clock),
        .data_out(lo$data_out),
        .mark(lo$mark),
        .strobe_out(lo$strobe_out)
    );
    top$demodulator$mixer mixer(
        .clock(mixer$clock),
        .data_in_1(mixer$data_in_1),
        .data_in_2(mixer$data_in_2),
        .data_out(mixer$data_out),
        .strobe_in(mixer$strobe_in),
        .strobe_out(mixer$strobe_out)
    );
    top$demodulator$lpf_down_1 lpf_down_1(
        .clock(lpf_down_1$clock),
        .data_in(lpf_down_1$data_in),
        .data_out(lpf_down_1$data_out),
        .strobe_in(lpf_down_1$strobe_in),
        .strobe_out(lpf_down_1$strobe_out)
    );
    top$demodulator$lpf_down_2 lpf_down_2(
        .clock(lpf_down_2$clock),
        .data_in(lpf_down_2$data_in),
        .data_out(lpf_down_2$data_out),
        .strobe_in(lpf_down_2$strobe_in),
        .strobe_out(lpf_down_2$strobe_out)
    );
    top$demodulator$space_pipeline space_pipeline(
        .clock(space_pipeline$clock),
        .data_in(space_pipeline$data_in),
        .data_out(space_pipeline$data_out),
        .strobe_in(space_pipeline$strobe_in),
        .strobe_out(space_pipeline$strobe_out)
    );
    top$demodulator$mark_pipeline mark_pipeline(
        .clock(mark_pipeline$clock),
        .data_in(mark_pipeline$data_in),
        .data_out(mark_pipeline$data_out),
        .strobe_in(mark_pipeline$strobe_in),
        .strobe_out(mark_pipeline$strobe_out)
    );
    top$demodulator$decider decider(
        .clock(decider$clock),
        .space_data_in(decider$space_data_in),
        .space_strobe_in(decider$space_strobe_in),
        .mark_data_in(decider$mark_data_in),
        .mark_strobe_in(decider$mark_strobe_in),
        .mark_out(decider$mark_out)
    );
    
    // Update code
    always @(*) begin
        lo$clock = clock;
        mixer$clock = clock;
        lpf_down_1$clock = clock;
        lpf_down_2$clock = clock;
        space_pipeline$clock = clock;
        mark_pipeline$clock = clock;
        decider$clock = clock;
        lo$mark = 1'b0;
        mixer$data_in_1 = data_in;
        mixer$data_in_2 = lo$data_out;
        mixer$strobe_in = strobe_in;
        lpf_down_1$data_in = mixer$data_out;
        lpf_down_1$strobe_in = mixer$strobe_out;
        lpf_down_2$data_in = lpf_down_1$data_out;
        lpf_down_2$strobe_in = lpf_down_1$strobe_out;
        space_pipeline$data_in = lpf_down_2$data_out;
        space_pipeline$strobe_in = lpf_down_2$strobe_out;
        mark_pipeline$data_in = lpf_down_2$data_out;
        mark_pipeline$strobe_in = lpf_down_2$strobe_out;
        decider$space_data_in = space_pipeline$data_out;
        decider$space_strobe_in = space_pipeline$strobe_out;
        decider$mark_data_in = mark_pipeline$data_out;
        decider$mark_strobe_in = mark_pipeline$strobe_out;
        mark_out = decider$mark_out;
    end
    
endmodule // top$demodulator


module top$demodulator$decider(clock,space_data_in,space_strobe_in,mark_data_in,mark_strobe_in,mark_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] space_data_in;
    input wire  space_strobe_in;
    input wire signed [15:0] mark_data_in;
    input wire  mark_strobe_in;
    output reg  mark_out;
    
    // Stub signals
    reg  mark_data_ready$d;
    wire  mark_data_ready$q;
    reg  mark_data_ready$clock;
    reg signed [15:0] mark_data_staged$d;
    wire signed [15:0] mark_data_staged$q;
    reg  mark_data_staged$clock;
    reg  space_data_ready$d;
    wire  space_data_ready$q;
    reg  space_data_ready$clock;
    reg signed [15:0] space_data_staged$d;
    wire signed [15:0] space_data_staged$q;
    reg  space_data_staged$clock;
    reg signed [15:0] mark_data$d;
    wire signed [15:0] mark_data$q;
    reg  mark_data$clock;
    reg signed [15:0] space_data$d;
    wire signed [15:0] space_data$q;
    reg  space_data$clock;
    reg  mark$d;
    wire  mark$q;
    reg  mark$clock;
    
    // Sub module instances
    top$demodulator$decider$mark_data_ready mark_data_ready(
        .d(mark_data_ready$d),
        .q(mark_data_ready$q),
        .clock(mark_data_ready$clock)
    );
    top$demodulator$decider$mark_data_staged mark_data_staged(
        .d(mark_data_staged$d),
        .q(mark_data_staged$q),
        .clock(mark_data_staged$clock)
    );
    top$demodulator$decider$space_data_ready space_data_ready(
        .d(space_data_ready$d),
        .q(space_data_ready$q),
        .clock(space_data_ready$clock)
    );
    top$demodulator$decider$space_data_staged space_data_staged(
        .d(space_data_staged$d),
        .q(space_data_staged$q),
        .clock(space_data_staged$clock)
    );
    top$demodulator$decider$mark_data mark_data(
        .d(mark_data$d),
        .q(mark_data$q),
        .clock(mark_data$clock)
    );
    top$demodulator$decider$space_data space_data(
        .d(space_data$d),
        .q(space_data$q),
        .clock(space_data$clock)
    );
    top$demodulator$decider$mark mark(
        .d(mark$d),
        .q(mark$q),
        .clock(mark$clock)
    );
    
    // Update code
    always @(*) begin
        mark_data_ready$clock = clock;
        mark_data_staged$clock = clock;
        space_data_ready$clock = clock;
        space_data_staged$clock = clock;
        mark_data$clock = clock;
        space_data$clock = clock;
        mark$clock = clock;
        mark_data_ready$d = mark_data_ready$q;
        mark_data_staged$d = mark_data_staged$q;
        space_data_ready$d = space_data_ready$q;
        space_data_staged$d = space_data_staged$q;
        mark_data$d = mark_data$q;
        space_data$d = space_data$q;
        mark$d = mark$q;
        mark_out = mark$q;
        if (space_strobe_in) begin
            space_data_staged$d = space_data_in;
            space_data_ready$d = 1'b1;
        end
        if (mark_strobe_in) begin
            mark_data_staged$d = mark_data_in;
            mark_data_ready$d = 1'b1;
        end
        if (space_data_ready$q && mark_data_ready$q) begin
            space_data_ready$d = 1'b0;
            space_data$d = space_data_staged$q;
            mark_data_ready$d = 1'b0;
            mark_data$d = mark_data_staged$q;
        end
        mark$d = mark_data$q > space_data$q;
    end
    
endmodule // top$demodulator$decider


module top$demodulator$decider$mark(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$decider$mark


module top$demodulator$decider$mark_data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$decider$mark_data


module top$demodulator$decider$mark_data_ready(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$decider$mark_data_ready


module top$demodulator$decider$mark_data_staged(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$decider$mark_data_staged


module top$demodulator$decider$space_data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$decider$space_data


module top$demodulator$decider$space_data_ready(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$decider$space_data_ready


module top$demodulator$decider$space_data_staged(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$decider$space_data_staged


module top$demodulator$lo(clock,data_out,mark,strobe_out);
    
    // Module arguments
    input wire  clock;
    output reg signed [15:0] data_out;
    input wire  mark;
    output reg  strobe_out;
    
    // Stub signals
    reg  [7:0] sin_rom$address;
    wire signed [15:0] sin_rom$data;
    reg  phase_accumulator$clock;
    wire  [7:0] phase_accumulator$ramp;
    wire  phase_accumulator$strobe_out;
    reg  phase_accumulator$mark;
    reg signed [15:0] sample$d;
    wire signed [15:0] sample$q;
    reg  sample$clock;
    reg  [7:0] rom_address$d;
    wire  [7:0] rom_address$q;
    reg  rom_address$clock;
    reg  mark_delay$d;
    wire  mark_delay$q;
    reg  mark_delay$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    reg  access_rom$d;
    wire  access_rom$q;
    reg  access_rom$clock;
    
    // Sub module instances
    top$demodulator$lo$sin_rom sin_rom(
        .address(sin_rom$address),
        .data(sin_rom$data)
    );
    top$demodulator$lo$phase_accumulator phase_accumulator(
        .clock(phase_accumulator$clock),
        .ramp(phase_accumulator$ramp),
        .strobe_out(phase_accumulator$strobe_out),
        .mark(phase_accumulator$mark)
    );
    top$demodulator$lo$sample sample(
        .d(sample$d),
        .q(sample$q),
        .clock(sample$clock)
    );
    top$demodulator$lo$rom_address rom_address(
        .d(rom_address$d),
        .q(rom_address$q),
        .clock(rom_address$clock)
    );
    top$demodulator$lo$mark_delay mark_delay(
        .d(mark_delay$d),
        .q(mark_delay$q),
        .clock(mark_delay$clock)
    );
    top$demodulator$lo$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    top$demodulator$lo$access_rom access_rom(
        .d(access_rom$d),
        .q(access_rom$q),
        .clock(access_rom$clock)
    );
    
    // Update code
    always @(*) begin
        phase_accumulator$clock = clock;
        rom_address$clock = clock;
        mark_delay$clock = clock;
        strobe$clock = clock;
        access_rom$clock = clock;
        sample$clock = clock;
        rom_address$d = rom_address$q;
        mark_delay$d = mark_delay$q;
        strobe$d = strobe$q;
        access_rom$d = access_rom$q;
        sample$d = sample$q;
        mark_delay$d = mark;
        phase_accumulator$mark = mark_delay$q;
        strobe_out = strobe$q;
        sin_rom$address = rom_address$q;
        data_out = sample$q;
        if (phase_accumulator$strobe_out) begin
            rom_address$d = phase_accumulator$ramp;
            access_rom$d = 1'b1;
        end
        if (access_rom$q) begin
            sample$d = sin_rom$data;
            access_rom$d = 1'b0;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$lo


module top$demodulator$lo$access_rom(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$access_rom


module top$demodulator$lo$mark_delay(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$mark_delay


module top$demodulator$lo$phase_accumulator(clock,ramp,strobe_out,mark);
    
    // Module arguments
    input wire  clock;
    output reg  [7:0] ramp;
    output reg  strobe_out;
    input wire  mark;
    
    // Constant declarations
    localparam  mark_tuning_word = 24'h1f2b02;
    localparam  space_tuning_word = 24'h1f2b02;
    
    // Stub signals
    reg  [23:0] counter$d;
    wire  [23:0] counter$q;
    reg  counter$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    reg  downclock$enable;
    wire  downclock$strobe;
    reg  downclock$clock;
    
    // Sub module instances
    top$demodulator$lo$phase_accumulator$counter counter(
        .d(counter$d),
        .q(counter$q),
        .clock(counter$clock)
    );
    top$demodulator$lo$phase_accumulator$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    top$demodulator$lo$phase_accumulator$downclock downclock(
        .enable(downclock$enable),
        .strobe(downclock$strobe),
        .clock(downclock$clock)
    );
    
    // Update code
    always @(*) begin
        downclock$clock = clock;
        counter$clock = clock;
        strobe$clock = clock;
        counter$d = counter$q;
        strobe$d = strobe$q;
        downclock$enable = 1'b1;
        strobe_out = strobe$q;
        ramp = counter$q[(32'h10)+:(8)];
        if (downclock$strobe) begin
            if (mark) begin
                counter$d = counter$q + mark_tuning_word;
            end
            else begin
                counter$d = counter$q + space_tuning_word;
            end
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$lo$phase_accumulator


module top$demodulator$lo$phase_accumulator$counter(d,q,clock);
    
    // Module arguments
    input wire  [23:0] d;
    output reg  [23:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 24'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$phase_accumulator$counter


module top$demodulator$lo$phase_accumulator$downclock(enable,strobe,clock);
    
    // Module arguments
    input wire  enable;
    output reg  strobe;
    input wire  clock;
    
    // Constant declarations
    localparam  threshold = 20'h14;
    
    // Stub signals
    reg  [19:0] counter$d;
    wire  [19:0] counter$q;
    reg  counter$clock;
    
    // Sub module instances
    top$demodulator$lo$phase_accumulator$downclock$counter counter(
        .d(counter$d),
        .q(counter$q),
        .clock(counter$clock)
    );
    
    // Update code
    always @(*) begin
        counter$clock = clock;
        counter$d = counter$q;
        if (enable) begin
            counter$d = counter$q + 32'h1;
        end
        strobe = enable & (counter$q == threshold);
        if (strobe) begin
            counter$d = 32'h1;
        end
    end
    
endmodule // top$demodulator$lo$phase_accumulator$downclock


module top$demodulator$lo$phase_accumulator$downclock$counter(d,q,clock);
    
    // Module arguments
    input wire  [19:0] d;
    output reg  [19:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 20'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$phase_accumulator$downclock$counter


module top$demodulator$lo$phase_accumulator$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$phase_accumulator$strobe


module top$demodulator$lo$rom_address(d,q,clock);
    
    // Module arguments
    input wire  [7:0] d;
    output reg  [7:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 8'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$rom_address


module top$demodulator$lo$sample(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$sample


module top$demodulator$lo$sin_rom(address,data);
    
    // Module arguments
    input wire  [7:0] address;
    output reg signed [15:0] data;
    
    // Update code (custom)
    always @*
    case (address)
        8'h0: data = 16'h0;
      8'h1: data = 16'h324;
      8'h2: data = 16'h647;
      8'h3: data = 16'h96a;
      8'h4: data = 16'hc8b;
      8'h5: data = 16'hfaa;
      8'h6: data = 16'h12c7;
      8'h7: data = 16'h15e1;
      8'h8: data = 16'h18f8;
      8'h9: data = 16'h1c0a;
      8'ha: data = 16'h1f19;
      8'hb: data = 16'h2222;
      8'hc: data = 16'h2527;
      8'hd: data = 16'h2825;
      8'he: data = 16'h2b1e;
      8'hf: data = 16'h2e0f;
      8'h10: data = 16'h30fa;
      8'h11: data = 16'h33dd;
      8'h12: data = 16'h36b8;
      8'h13: data = 16'h398b;
      8'h14: data = 16'h3c55;
      8'h15: data = 16'h3f15;
      8'h16: data = 16'h41cc;
      8'h17: data = 16'h4479;
      8'h18: data = 16'h471b;
      8'h19: data = 16'h49b2;
      8'h1a: data = 16'h4c3d;
      8'h1b: data = 16'h4ebd;
      8'h1c: data = 16'h5131;
      8'h1d: data = 16'h5399;
      8'h1e: data = 16'h55f3;
      8'h1f: data = 16'h5840;
      8'h20: data = 16'h5a80;
      8'h21: data = 16'h5cb1;
      8'h22: data = 16'h5ed5;
      8'h23: data = 16'h60e9;
      8'h24: data = 16'h62ef;
      8'h25: data = 16'h64e5;
      8'h26: data = 16'h66cc;
      8'h27: data = 16'h68a3;
      8'h28: data = 16'h6a6a;
      8'h29: data = 16'h6c21;
      8'h2a: data = 16'h6dc7;
      8'h2b: data = 16'h6f5c;
      8'h2c: data = 16'h70df;
      8'h2d: data = 16'h7252;
      8'h2e: data = 16'h73b2;
      8'h2f: data = 16'h7501;
      8'h30: data = 16'h763e;
      8'h31: data = 16'h7769;
      8'h32: data = 16'h7881;
      8'h33: data = 16'h7987;
      8'h34: data = 16'h7a79;
      8'h35: data = 16'h7b59;
      8'h36: data = 16'h7c26;
      8'h37: data = 16'h7ce0;
      8'h38: data = 16'h7d87;
      8'h39: data = 16'h7e1a;
      8'h3a: data = 16'h7e9a;
      8'h3b: data = 16'h7f06;
      8'h3c: data = 16'h7f5e;
      8'h3d: data = 16'h7fa3;
      8'h3e: data = 16'h7fd5;
      8'h3f: data = 16'h7ff2;
      8'h40: data = 16'h7ffc;
      8'h41: data = 16'h7ff2;
      8'h42: data = 16'h7fd5;
      8'h43: data = 16'h7fa3;
      8'h44: data = 16'h7f5e;
      8'h45: data = 16'h7f06;
      8'h46: data = 16'h7e9a;
      8'h47: data = 16'h7e1a;
      8'h48: data = 16'h7d87;
      8'h49: data = 16'h7ce0;
      8'h4a: data = 16'h7c26;
      8'h4b: data = 16'h7b59;
      8'h4c: data = 16'h7a79;
      8'h4d: data = 16'h7987;
      8'h4e: data = 16'h7881;
      8'h4f: data = 16'h7769;
      8'h50: data = 16'h763e;
      8'h51: data = 16'h7501;
      8'h52: data = 16'h73b2;
      8'h53: data = 16'h7252;
      8'h54: data = 16'h70df;
      8'h55: data = 16'h6f5c;
      8'h56: data = 16'h6dc7;
      8'h57: data = 16'h6c21;
      8'h58: data = 16'h6a6a;
      8'h59: data = 16'h68a3;
      8'h5a: data = 16'h66cc;
      8'h5b: data = 16'h64e5;
      8'h5c: data = 16'h62ef;
      8'h5d: data = 16'h60e9;
      8'h5e: data = 16'h5ed5;
      8'h5f: data = 16'h5cb1;
      8'h60: data = 16'h5a80;
      8'h61: data = 16'h5840;
      8'h62: data = 16'h55f3;
      8'h63: data = 16'h5399;
      8'h64: data = 16'h5131;
      8'h65: data = 16'h4ebd;
      8'h66: data = 16'h4c3d;
      8'h67: data = 16'h49b2;
      8'h68: data = 16'h471b;
      8'h69: data = 16'h4479;
      8'h6a: data = 16'h41cc;
      8'h6b: data = 16'h3f15;
      8'h6c: data = 16'h3c55;
      8'h6d: data = 16'h398b;
      8'h6e: data = 16'h36b8;
      8'h6f: data = 16'h33dd;
      8'h70: data = 16'h30fa;
      8'h71: data = 16'h2e0f;
      8'h72: data = 16'h2b1e;
      8'h73: data = 16'h2825;
      8'h74: data = 16'h2527;
      8'h75: data = 16'h2222;
      8'h76: data = 16'h1f19;
      8'h77: data = 16'h1c0a;
      8'h78: data = 16'h18f8;
      8'h79: data = 16'h15e1;
      8'h7a: data = 16'h12c7;
      8'h7b: data = 16'hfaa;
      8'h7c: data = 16'hc8b;
      8'h7d: data = 16'h96a;
      8'h7e: data = 16'h647;
      8'h7f: data = 16'h324;
      8'h80: data = 16'h0;
      8'h81: data = 16'hfcdc;
      8'h82: data = 16'hf9b9;
      8'h83: data = 16'hf696;
      8'h84: data = 16'hf375;
      8'h85: data = 16'hf056;
      8'h86: data = 16'hed39;
      8'h87: data = 16'hea1f;
      8'h88: data = 16'he708;
      8'h89: data = 16'he3f6;
      8'h8a: data = 16'he0e7;
      8'h8b: data = 16'hddde;
      8'h8c: data = 16'hdad9;
      8'h8d: data = 16'hd7db;
      8'h8e: data = 16'hd4e2;
      8'h8f: data = 16'hd1f1;
      8'h90: data = 16'hcf06;
      8'h91: data = 16'hcc23;
      8'h92: data = 16'hc948;
      8'h93: data = 16'hc675;
      8'h94: data = 16'hc3ab;
      8'h95: data = 16'hc0eb;
      8'h96: data = 16'hbe34;
      8'h97: data = 16'hbb87;
      8'h98: data = 16'hb8e5;
      8'h99: data = 16'hb64e;
      8'h9a: data = 16'hb3c3;
      8'h9b: data = 16'hb143;
      8'h9c: data = 16'haecf;
      8'h9d: data = 16'hac67;
      8'h9e: data = 16'haa0d;
      8'h9f: data = 16'ha7c0;
      8'ha0: data = 16'ha580;
      8'ha1: data = 16'ha34f;
      8'ha2: data = 16'ha12b;
      8'ha3: data = 16'h9f17;
      8'ha4: data = 16'h9d11;
      8'ha5: data = 16'h9b1b;
      8'ha6: data = 16'h9934;
      8'ha7: data = 16'h975d;
      8'ha8: data = 16'h9596;
      8'ha9: data = 16'h93df;
      8'haa: data = 16'h9239;
      8'hab: data = 16'h90a4;
      8'hac: data = 16'h8f21;
      8'had: data = 16'h8dae;
      8'hae: data = 16'h8c4e;
      8'haf: data = 16'h8aff;
      8'hb0: data = 16'h89c2;
      8'hb1: data = 16'h8897;
      8'hb2: data = 16'h877f;
      8'hb3: data = 16'h8679;
      8'hb4: data = 16'h8587;
      8'hb5: data = 16'h84a7;
      8'hb6: data = 16'h83da;
      8'hb7: data = 16'h8320;
      8'hb8: data = 16'h8279;
      8'hb9: data = 16'h81e6;
      8'hba: data = 16'h8166;
      8'hbb: data = 16'h80fa;
      8'hbc: data = 16'h80a2;
      8'hbd: data = 16'h805d;
      8'hbe: data = 16'h802b;
      8'hbf: data = 16'h800e;
      8'hc0: data = 16'h8004;
      8'hc1: data = 16'h800e;
      8'hc2: data = 16'h802b;
      8'hc3: data = 16'h805d;
      8'hc4: data = 16'h80a2;
      8'hc5: data = 16'h80fa;
      8'hc6: data = 16'h8166;
      8'hc7: data = 16'h81e6;
      8'hc8: data = 16'h8279;
      8'hc9: data = 16'h8320;
      8'hca: data = 16'h83da;
      8'hcb: data = 16'h84a7;
      8'hcc: data = 16'h8587;
      8'hcd: data = 16'h8679;
      8'hce: data = 16'h877f;
      8'hcf: data = 16'h8897;
      8'hd0: data = 16'h89c2;
      8'hd1: data = 16'h8aff;
      8'hd2: data = 16'h8c4e;
      8'hd3: data = 16'h8dae;
      8'hd4: data = 16'h8f21;
      8'hd5: data = 16'h90a4;
      8'hd6: data = 16'h9239;
      8'hd7: data = 16'h93df;
      8'hd8: data = 16'h9596;
      8'hd9: data = 16'h975d;
      8'hda: data = 16'h9934;
      8'hdb: data = 16'h9b1b;
      8'hdc: data = 16'h9d11;
      8'hdd: data = 16'h9f17;
      8'hde: data = 16'ha12b;
      8'hdf: data = 16'ha34f;
      8'he0: data = 16'ha580;
      8'he1: data = 16'ha7c0;
      8'he2: data = 16'haa0d;
      8'he3: data = 16'hac67;
      8'he4: data = 16'haecf;
      8'he5: data = 16'hb143;
      8'he6: data = 16'hb3c3;
      8'he7: data = 16'hb64e;
      8'he8: data = 16'hb8e5;
      8'he9: data = 16'hbb87;
      8'hea: data = 16'hbe34;
      8'heb: data = 16'hc0eb;
      8'hec: data = 16'hc3ab;
      8'hed: data = 16'hc675;
      8'hee: data = 16'hc948;
      8'hef: data = 16'hcc23;
      8'hf0: data = 16'hcf06;
      8'hf1: data = 16'hd1f1;
      8'hf2: data = 16'hd4e2;
      8'hf3: data = 16'hd7db;
      8'hf4: data = 16'hdad9;
      8'hf5: data = 16'hddde;
      8'hf6: data = 16'he0e7;
      8'hf7: data = 16'he3f6;
      8'hf8: data = 16'he708;
      8'hf9: data = 16'hea1f;
      8'hfa: data = 16'hed39;
      8'hfb: data = 16'hf056;
      8'hfc: data = 16'hf375;
      8'hfd: data = 16'hf696;
      8'hfe: data = 16'hf9b9;
      8'hff: data = 16'hfcdc;
      default: data = 16'h0;
    endcase
            
endmodule // top$demodulator$lo$sin_rom


module top$demodulator$lo$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lo$strobe


module top$demodulator$lpf_down_1(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] fir$data_in;
    reg  fir$strobe_in;
    wire signed [47:0] fir$data_out;
    wire  fir$strobe_out;
    reg  fir$clock;
    wire  fir$busy;
    reg  downsample$clock;
    reg signed [15:0] downsample$data_in;
    reg  downsample$strobe_in;
    wire signed [15:0] downsample$data_out;
    wire  downsample$strobe_out;
    reg  fir_buffer$clock;
    reg signed [15:0] fir_buffer$data_in;
    reg  fir_buffer$strobe_in;
    wire signed [15:0] fir_buffer$data_out;
    wire  fir_buffer$strobe_out;
    reg  output_round$clock;
    reg signed [47:0] output_round$data_in;
    wire signed [15:0] output_round$data_out;
    reg  output_round$strobe_in;
    wire  output_round$strobe_out;
    
    // Sub module instances
    top$demodulator$lpf_down_1$fir fir(
        .data_in(fir$data_in),
        .strobe_in(fir$strobe_in),
        .data_out(fir$data_out),
        .strobe_out(fir$strobe_out),
        .clock(fir$clock),
        .busy(fir$busy)
    );
    top$demodulator$lpf_down_1$downsample downsample(
        .clock(downsample$clock),
        .data_in(downsample$data_in),
        .strobe_in(downsample$strobe_in),
        .data_out(downsample$data_out),
        .strobe_out(downsample$strobe_out)
    );
    top$demodulator$lpf_down_1$fir_buffer fir_buffer(
        .clock(fir_buffer$clock),
        .data_in(fir_buffer$data_in),
        .strobe_in(fir_buffer$strobe_in),
        .data_out(fir_buffer$data_out),
        .strobe_out(fir_buffer$strobe_out)
    );
    top$demodulator$lpf_down_1$output_round output_round(
        .clock(output_round$clock),
        .data_in(output_round$data_in),
        .data_out(output_round$data_out),
        .strobe_in(output_round$strobe_in),
        .strobe_out(output_round$strobe_out)
    );
    
    // Update code
    always @(*) begin
        fir$clock = clock;
        fir_buffer$clock = clock;
        output_round$clock = clock;
        downsample$clock = clock;
        fir$data_in = data_in;
        fir$strobe_in = strobe_in;
        output_round$data_in = fir$data_out;
        output_round$strobe_in = fir$strobe_out;
        fir_buffer$data_in = output_round$data_out;
        fir_buffer$strobe_in = output_round$strobe_out;
        downsample$data_in = fir_buffer$data_out;
        downsample$strobe_in = fir_buffer$strobe_out;
        data_out = downsample$data_out;
        strobe_out = downsample$strobe_out;
    end
    
endmodule // top$demodulator$lpf_down_1


module top$demodulator$lpf_down_1$downsample(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Constant declarations
    localparam  decimation_factor = 5'b100;
    
    // Stub signals
    reg  [4:0] counter$d;
    wire  [4:0] counter$q;
    reg  counter$clock;
    reg signed [15:0] hold_out$d;
    wire signed [15:0] hold_out$q;
    reg  hold_out$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$lpf_down_1$downsample$counter counter(
        .d(counter$d),
        .q(counter$q),
        .clock(counter$clock)
    );
    top$demodulator$lpf_down_1$downsample$hold_out hold_out(
        .d(hold_out$d),
        .q(hold_out$q),
        .clock(hold_out$clock)
    );
    top$demodulator$lpf_down_1$downsample$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        counter$clock = clock;
        hold_out$clock = clock;
        strobe$clock = clock;
        counter$d = counter$q;
        hold_out$d = hold_out$q;
        strobe$d = strobe$q;
        data_out = hold_out$q;
        strobe_out = strobe$q;
        strobe$d = 1'b0;
        if (strobe_in) begin
            if (counter$q == decimation_factor - 32'h1) begin
                counter$d = 32'h0;
                hold_out$d = data_in;
                strobe$d = 1'b1;
            end
            else begin
                counter$d = counter$q + 32'h1;
            end
        end
    end
    
endmodule // top$demodulator$lpf_down_1$downsample


module top$demodulator$lpf_down_1$downsample$counter(d,q,clock);
    
    // Module arguments
    input wire  [4:0] d;
    output reg  [4:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 5'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$downsample$counter


module top$demodulator$lpf_down_1$downsample$hold_out(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$downsample$hold_out


module top$demodulator$lpf_down_1$downsample$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$downsample$strobe


module top$demodulator$lpf_down_1$fir(data_in,strobe_in,data_out,strobe_out,clock,busy);
    
    // Module arguments
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [47:0] data_out;
    output reg  strobe_out;
    input wire  clock;
    output reg  busy;
    
    // Constant declarations
    localparam  iters = 7'b1000;
    localparam  bufsize = 32'h80;
    localparam  taps = 32'h11;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Stub signals
    reg  [6:0] coeff_memory$address;
    reg  coeff_memory$clock;
    wire signed [15:0] coeff_memory$data;
    reg  [6:0] left_bank$read_address;
    reg  left_bank$read_clock;
    wire signed [15:0] left_bank$read_data;
    reg  [6:0] left_bank$write_address;
    reg  left_bank$write_clock;
    reg signed [15:0] left_bank$write_data;
    reg  left_bank$write_enable;
    reg  [6:0] right_bank$read_address;
    reg  right_bank$read_clock;
    wire signed [15:0] right_bank$read_data;
    reg  [6:0] right_bank$write_address;
    reg  right_bank$write_clock;
    reg signed [15:0] right_bank$write_data;
    reg  right_bank$write_enable;
    reg  [6:0] head_ptr$d;
    wire  [6:0] head_ptr$q;
    reg  head_ptr$clock;
    reg  [6:0] index$d;
    wire  [6:0] index$q;
    reg  index$clock;
    reg signed [47:0] accum$d;
    wire signed [47:0] accum$q;
    reg  accum$clock;
    reg  [2:0] state$d;
    wire  [2:0] state$q;
    reg  state$clock;
    
    // Local signals
    reg  [6:0] left_ptr;
    reg  [6:0] right_ptr;
    reg signed [15:0] left_sample;
    reg signed [15:0] right_sample;
    reg signed [31:0] multiply_output;
    reg signed [47:0] mac_output;
    reg  [6:0] data_write;
    
    // Sub module instances
    top$demodulator$lpf_down_1$fir$coeff_memory coeff_memory(
        .address(coeff_memory$address),
        .clock(coeff_memory$clock),
        .data(coeff_memory$data)
    );
    top$demodulator$lpf_down_1$fir$left_bank left_bank(
        .read_address(left_bank$read_address),
        .read_clock(left_bank$read_clock),
        .read_data(left_bank$read_data),
        .write_address(left_bank$write_address),
        .write_clock(left_bank$write_clock),
        .write_data(left_bank$write_data),
        .write_enable(left_bank$write_enable)
    );
    top$demodulator$lpf_down_1$fir$right_bank right_bank(
        .read_address(right_bank$read_address),
        .read_clock(right_bank$read_clock),
        .read_data(right_bank$read_data),
        .write_address(right_bank$write_address),
        .write_clock(right_bank$write_clock),
        .write_data(right_bank$write_data),
        .write_enable(right_bank$write_enable)
    );
    top$demodulator$lpf_down_1$fir$head_ptr head_ptr(
        .d(head_ptr$d),
        .q(head_ptr$q),
        .clock(head_ptr$clock)
    );
    top$demodulator$lpf_down_1$fir$index index(
        .d(index$d),
        .q(index$q),
        .clock(index$clock)
    );
    top$demodulator$lpf_down_1$fir$accum accum(
        .d(accum$d),
        .q(accum$q),
        .clock(accum$clock)
    );
    top$demodulator$lpf_down_1$fir$state state(
        .d(state$d),
        .q(state$q),
        .clock(state$clock)
    );
    
    // Update code
    always @(*) begin
        coeff_memory$clock = clock;
        left_bank$read_clock = clock;
        left_bank$write_clock = clock;
        right_bank$read_clock = clock;
        right_bank$write_clock = clock;
        head_ptr$clock = clock;
        index$clock = clock;
        accum$clock = clock;
        state$clock = clock;
        head_ptr$d = head_ptr$q;
        index$d = index$q;
        accum$d = accum$q;
        state$d = state$q;
        left_bank$write_address = head_ptr$d;
        right_bank$write_address = head_ptr$d;
        left_bank$write_data = data_in;
        right_bank$write_data = data_in;
        left_bank$write_enable = strobe_in;
        right_bank$write_enable = strobe_in;
        left_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - taps + 32'h1 + ((index$q) & 32'hffffffff)) & 7'h7f);
        right_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - ((index$q) & 32'hffffffff)) & 7'h7f);
        left_bank$read_address = left_ptr;
        right_bank$read_address = right_ptr;
        coeff_memory$address = index$q;
        left_sample = left_bank$read_data;
        right_sample = right_bank$read_data;
        if (state$q == MACFIRState$CenterTap) begin
            right_sample = 32'h0;
        end
        multiply_output = (left_sample + right_sample) * (coeff_memory$data);
        mac_output = $signed(multiply_output) + accum$q;
        if (state$q == MACFIRState$Idle) begin
            mac_output = 32'h0;
        end
        data_write = head_ptr$q;
        data_out = accum$q;
        strobe_out = 1'b0;
        busy = state$q != MACFIRState$Idle;
        case (state$q)
            MACFIRState$Idle:
                begin
                    if (strobe_in) begin
                        state$d = MACFIRState$Dwell;
                    end
                end
            MACFIRState$Dwell:
                begin
                    index$d = index$q + 32'h1;
                    state$d = MACFIRState$Compute;
                end
            MACFIRState$Compute:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    if (index$q == iters) begin
                        state$d = MACFIRState$CenterTap;
                    end
                end
            MACFIRState$CenterTap:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    state$d = MACFIRState$Write;
                end
            MACFIRState$Write:
                begin
                    strobe_out = 1'b1;
                    state$d = MACFIRState$Idle;
                    head_ptr$d = head_ptr$q + 32'h1;
                    index$d = 32'h0;
                    accum$d = 32'h0;
                end
            default:
                begin
                    state$d = MACFIRState$Idle;
                end
        endcase
        data_write = head_ptr$q;
    end
    
endmodule // top$demodulator$lpf_down_1$fir


module top$demodulator$lpf_down_1$fir$accum(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$fir$accum


module top$demodulator$lpf_down_1$fir$coeff_memory(address,clock,data);
    
    // Module arguments
    input wire  [6:0] address;
    input wire  clock;
    output reg signed [15:0] data;
    
    // Update code (custom)
    reg[15:0] mem [127:0];
    
    initial begin
    mem[7'b0] = 16'hf902;
    mem[7'b1] = 16'hfbbb;
    mem[7'b10] = 16'hfd1c;
    mem[7'b11] = 16'he2;
    mem[7'b100] = 16'h6da;
    mem[7'b101] = 16'he0a;
    mem[7'b110] = 16'h14f1;
    mem[7'b111] = 16'h19ee;
    mem[7'b1000] = 16'h1bbf;
    end
    
    always @(posedge clock) begin
       data <= mem[address];
    end
endmodule // top$demodulator$lpf_down_1$fir$coeff_memory


module top$demodulator$lpf_down_1$fir$head_ptr(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$fir$head_ptr


module top$demodulator$lpf_down_1$fir$index(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$fir$index


module top$demodulator$lpf_down_1$fir$left_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$lpf_down_1$fir$left_bank


module top$demodulator$lpf_down_1$fir$right_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$lpf_down_1$fir$right_bank


module top$demodulator$lpf_down_1$fir$state(d,q,clock);
    
    // Module arguments
    input wire  [2:0] d;
    output reg  [2:0] q;
    input wire  clock;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Update code (custom)
    initial begin
       q = 64'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$fir$state


module top$demodulator$lpf_down_1$fir_buffer(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$lpf_down_1$fir_buffer$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$lpf_down_1$fir_buffer$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        data_out = data$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$lpf_down_1$fir_buffer


module top$demodulator$lpf_down_1$fir_buffer$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$fir_buffer$data


module top$demodulator$lpf_down_1$fir_buffer$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$fir_buffer$strobe


module top$demodulator$lpf_down_1$output_round(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [47:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [47:0] data$d;
    wire signed [47:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Local signals
    reg signed [15:0] truncated;
    
    // Sub module instances
    top$demodulator$lpf_down_1$output_round$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$lpf_down_1$output_round$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        if (strobe$q) begin
            strobe$d = 1'b0;
        end
        truncated = data$q[(32'h10)+:(16)];
        if (data$q[32'he]) begin
            data_out = truncated + 32'h1;
        end
        else begin
            data_out = truncated;
        end
    end
    
endmodule // top$demodulator$lpf_down_1$output_round


module top$demodulator$lpf_down_1$output_round$data(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$output_round$data


module top$demodulator$lpf_down_1$output_round$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_1$output_round$strobe


module top$demodulator$lpf_down_2(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] fir$data_in;
    reg  fir$strobe_in;
    wire signed [47:0] fir$data_out;
    wire  fir$strobe_out;
    reg  fir$clock;
    wire  fir$busy;
    reg  downsample$clock;
    reg signed [15:0] downsample$data_in;
    reg  downsample$strobe_in;
    wire signed [15:0] downsample$data_out;
    wire  downsample$strobe_out;
    reg  fir_buffer$clock;
    reg signed [15:0] fir_buffer$data_in;
    reg  fir_buffer$strobe_in;
    wire signed [15:0] fir_buffer$data_out;
    wire  fir_buffer$strobe_out;
    reg  output_round$clock;
    reg signed [47:0] output_round$data_in;
    wire signed [15:0] output_round$data_out;
    reg  output_round$strobe_in;
    wire  output_round$strobe_out;
    
    // Sub module instances
    top$demodulator$lpf_down_2$fir fir(
        .data_in(fir$data_in),
        .strobe_in(fir$strobe_in),
        .data_out(fir$data_out),
        .strobe_out(fir$strobe_out),
        .clock(fir$clock),
        .busy(fir$busy)
    );
    top$demodulator$lpf_down_2$downsample downsample(
        .clock(downsample$clock),
        .data_in(downsample$data_in),
        .strobe_in(downsample$strobe_in),
        .data_out(downsample$data_out),
        .strobe_out(downsample$strobe_out)
    );
    top$demodulator$lpf_down_2$fir_buffer fir_buffer(
        .clock(fir_buffer$clock),
        .data_in(fir_buffer$data_in),
        .strobe_in(fir_buffer$strobe_in),
        .data_out(fir_buffer$data_out),
        .strobe_out(fir_buffer$strobe_out)
    );
    top$demodulator$lpf_down_2$output_round output_round(
        .clock(output_round$clock),
        .data_in(output_round$data_in),
        .data_out(output_round$data_out),
        .strobe_in(output_round$strobe_in),
        .strobe_out(output_round$strobe_out)
    );
    
    // Update code
    always @(*) begin
        fir$clock = clock;
        fir_buffer$clock = clock;
        output_round$clock = clock;
        downsample$clock = clock;
        fir$data_in = data_in;
        fir$strobe_in = strobe_in;
        output_round$data_in = fir$data_out;
        output_round$strobe_in = fir$strobe_out;
        fir_buffer$data_in = output_round$data_out;
        fir_buffer$strobe_in = output_round$strobe_out;
        downsample$data_in = fir_buffer$data_out;
        downsample$strobe_in = fir_buffer$strobe_out;
        data_out = downsample$data_out;
        strobe_out = downsample$strobe_out;
    end
    
endmodule // top$demodulator$lpf_down_2


module top$demodulator$lpf_down_2$downsample(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Constant declarations
    localparam  decimation_factor = 5'b100;
    
    // Stub signals
    reg  [4:0] counter$d;
    wire  [4:0] counter$q;
    reg  counter$clock;
    reg signed [15:0] hold_out$d;
    wire signed [15:0] hold_out$q;
    reg  hold_out$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$lpf_down_2$downsample$counter counter(
        .d(counter$d),
        .q(counter$q),
        .clock(counter$clock)
    );
    top$demodulator$lpf_down_2$downsample$hold_out hold_out(
        .d(hold_out$d),
        .q(hold_out$q),
        .clock(hold_out$clock)
    );
    top$demodulator$lpf_down_2$downsample$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        counter$clock = clock;
        hold_out$clock = clock;
        strobe$clock = clock;
        counter$d = counter$q;
        hold_out$d = hold_out$q;
        strobe$d = strobe$q;
        data_out = hold_out$q;
        strobe_out = strobe$q;
        strobe$d = 1'b0;
        if (strobe_in) begin
            if (counter$q == decimation_factor - 32'h1) begin
                counter$d = 32'h0;
                hold_out$d = data_in;
                strobe$d = 1'b1;
            end
            else begin
                counter$d = counter$q + 32'h1;
            end
        end
    end
    
endmodule // top$demodulator$lpf_down_2$downsample


module top$demodulator$lpf_down_2$downsample$counter(d,q,clock);
    
    // Module arguments
    input wire  [4:0] d;
    output reg  [4:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 5'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$downsample$counter


module top$demodulator$lpf_down_2$downsample$hold_out(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$downsample$hold_out


module top$demodulator$lpf_down_2$downsample$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$downsample$strobe


module top$demodulator$lpf_down_2$fir(data_in,strobe_in,data_out,strobe_out,clock,busy);
    
    // Module arguments
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [47:0] data_out;
    output reg  strobe_out;
    input wire  clock;
    output reg  busy;
    
    // Constant declarations
    localparam  iters = 7'b1000;
    localparam  bufsize = 32'h80;
    localparam  taps = 32'h11;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Stub signals
    reg  [6:0] coeff_memory$address;
    reg  coeff_memory$clock;
    wire signed [15:0] coeff_memory$data;
    reg  [6:0] left_bank$read_address;
    reg  left_bank$read_clock;
    wire signed [15:0] left_bank$read_data;
    reg  [6:0] left_bank$write_address;
    reg  left_bank$write_clock;
    reg signed [15:0] left_bank$write_data;
    reg  left_bank$write_enable;
    reg  [6:0] right_bank$read_address;
    reg  right_bank$read_clock;
    wire signed [15:0] right_bank$read_data;
    reg  [6:0] right_bank$write_address;
    reg  right_bank$write_clock;
    reg signed [15:0] right_bank$write_data;
    reg  right_bank$write_enable;
    reg  [6:0] head_ptr$d;
    wire  [6:0] head_ptr$q;
    reg  head_ptr$clock;
    reg  [6:0] index$d;
    wire  [6:0] index$q;
    reg  index$clock;
    reg signed [47:0] accum$d;
    wire signed [47:0] accum$q;
    reg  accum$clock;
    reg  [2:0] state$d;
    wire  [2:0] state$q;
    reg  state$clock;
    
    // Local signals
    reg  [6:0] left_ptr;
    reg  [6:0] right_ptr;
    reg signed [15:0] left_sample;
    reg signed [15:0] right_sample;
    reg signed [31:0] multiply_output;
    reg signed [47:0] mac_output;
    reg  [6:0] data_write;
    
    // Sub module instances
    top$demodulator$lpf_down_2$fir$coeff_memory coeff_memory(
        .address(coeff_memory$address),
        .clock(coeff_memory$clock),
        .data(coeff_memory$data)
    );
    top$demodulator$lpf_down_2$fir$left_bank left_bank(
        .read_address(left_bank$read_address),
        .read_clock(left_bank$read_clock),
        .read_data(left_bank$read_data),
        .write_address(left_bank$write_address),
        .write_clock(left_bank$write_clock),
        .write_data(left_bank$write_data),
        .write_enable(left_bank$write_enable)
    );
    top$demodulator$lpf_down_2$fir$right_bank right_bank(
        .read_address(right_bank$read_address),
        .read_clock(right_bank$read_clock),
        .read_data(right_bank$read_data),
        .write_address(right_bank$write_address),
        .write_clock(right_bank$write_clock),
        .write_data(right_bank$write_data),
        .write_enable(right_bank$write_enable)
    );
    top$demodulator$lpf_down_2$fir$head_ptr head_ptr(
        .d(head_ptr$d),
        .q(head_ptr$q),
        .clock(head_ptr$clock)
    );
    top$demodulator$lpf_down_2$fir$index index(
        .d(index$d),
        .q(index$q),
        .clock(index$clock)
    );
    top$demodulator$lpf_down_2$fir$accum accum(
        .d(accum$d),
        .q(accum$q),
        .clock(accum$clock)
    );
    top$demodulator$lpf_down_2$fir$state state(
        .d(state$d),
        .q(state$q),
        .clock(state$clock)
    );
    
    // Update code
    always @(*) begin
        coeff_memory$clock = clock;
        left_bank$read_clock = clock;
        left_bank$write_clock = clock;
        right_bank$read_clock = clock;
        right_bank$write_clock = clock;
        head_ptr$clock = clock;
        index$clock = clock;
        accum$clock = clock;
        state$clock = clock;
        head_ptr$d = head_ptr$q;
        index$d = index$q;
        accum$d = accum$q;
        state$d = state$q;
        left_bank$write_address = head_ptr$d;
        right_bank$write_address = head_ptr$d;
        left_bank$write_data = data_in;
        right_bank$write_data = data_in;
        left_bank$write_enable = strobe_in;
        right_bank$write_enable = strobe_in;
        left_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - taps + 32'h1 + ((index$q) & 32'hffffffff)) & 7'h7f);
        right_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - ((index$q) & 32'hffffffff)) & 7'h7f);
        left_bank$read_address = left_ptr;
        right_bank$read_address = right_ptr;
        coeff_memory$address = index$q;
        left_sample = left_bank$read_data;
        right_sample = right_bank$read_data;
        if (state$q == MACFIRState$CenterTap) begin
            right_sample = 32'h0;
        end
        multiply_output = (left_sample + right_sample) * (coeff_memory$data);
        mac_output = $signed(multiply_output) + accum$q;
        if (state$q == MACFIRState$Idle) begin
            mac_output = 32'h0;
        end
        data_write = head_ptr$q;
        data_out = accum$q;
        strobe_out = 1'b0;
        busy = state$q != MACFIRState$Idle;
        case (state$q)
            MACFIRState$Idle:
                begin
                    if (strobe_in) begin
                        state$d = MACFIRState$Dwell;
                    end
                end
            MACFIRState$Dwell:
                begin
                    index$d = index$q + 32'h1;
                    state$d = MACFIRState$Compute;
                end
            MACFIRState$Compute:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    if (index$q == iters) begin
                        state$d = MACFIRState$CenterTap;
                    end
                end
            MACFIRState$CenterTap:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    state$d = MACFIRState$Write;
                end
            MACFIRState$Write:
                begin
                    strobe_out = 1'b1;
                    state$d = MACFIRState$Idle;
                    head_ptr$d = head_ptr$q + 32'h1;
                    index$d = 32'h0;
                    accum$d = 32'h0;
                end
            default:
                begin
                    state$d = MACFIRState$Idle;
                end
        endcase
        data_write = head_ptr$q;
    end
    
endmodule // top$demodulator$lpf_down_2$fir


module top$demodulator$lpf_down_2$fir$accum(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$fir$accum


module top$demodulator$lpf_down_2$fir$coeff_memory(address,clock,data);
    
    // Module arguments
    input wire  [6:0] address;
    input wire  clock;
    output reg signed [15:0] data;
    
    // Update code (custom)
    reg[15:0] mem [127:0];
    
    initial begin
    mem[7'b0] = 16'hf902;
    mem[7'b1] = 16'hfbbb;
    mem[7'b10] = 16'hfd1c;
    mem[7'b11] = 16'he2;
    mem[7'b100] = 16'h6da;
    mem[7'b101] = 16'he0a;
    mem[7'b110] = 16'h14f1;
    mem[7'b111] = 16'h19ee;
    mem[7'b1000] = 16'h1bbf;
    end
    
    always @(posedge clock) begin
       data <= mem[address];
    end
endmodule // top$demodulator$lpf_down_2$fir$coeff_memory


module top$demodulator$lpf_down_2$fir$head_ptr(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$fir$head_ptr


module top$demodulator$lpf_down_2$fir$index(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$fir$index


module top$demodulator$lpf_down_2$fir$left_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$lpf_down_2$fir$left_bank


module top$demodulator$lpf_down_2$fir$right_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$lpf_down_2$fir$right_bank


module top$demodulator$lpf_down_2$fir$state(d,q,clock);
    
    // Module arguments
    input wire  [2:0] d;
    output reg  [2:0] q;
    input wire  clock;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Update code (custom)
    initial begin
       q = 64'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$fir$state


module top$demodulator$lpf_down_2$fir_buffer(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$lpf_down_2$fir_buffer$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$lpf_down_2$fir_buffer$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        data_out = data$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$lpf_down_2$fir_buffer


module top$demodulator$lpf_down_2$fir_buffer$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$fir_buffer$data


module top$demodulator$lpf_down_2$fir_buffer$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$fir_buffer$strobe


module top$demodulator$lpf_down_2$output_round(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [47:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [47:0] data$d;
    wire signed [47:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Local signals
    reg signed [15:0] truncated;
    
    // Sub module instances
    top$demodulator$lpf_down_2$output_round$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$lpf_down_2$output_round$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        if (strobe$q) begin
            strobe$d = 1'b0;
        end
        truncated = data$q[(32'h10)+:(16)];
        if (data$q[32'he]) begin
            data_out = truncated + 32'h1;
        end
        else begin
            data_out = truncated;
        end
    end
    
endmodule // top$demodulator$lpf_down_2$output_round


module top$demodulator$lpf_down_2$output_round$data(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$output_round$data


module top$demodulator$lpf_down_2$output_round$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$lpf_down_2$output_round$strobe


module top$demodulator$mark_pipeline(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] fir$data_in;
    reg  fir$strobe_in;
    wire signed [47:0] fir$data_out;
    wire  fir$strobe_out;
    reg  fir$clock;
    wire  fir$busy;
    reg  fir_round$clock;
    reg signed [47:0] fir_round$data_in;
    wire signed [15:0] fir_round$data_out;
    reg  fir_round$strobe_in;
    wire  fir_round$strobe_out;
    reg signed [15:0] envelope_filter$data_in;
    reg  envelope_filter$strobe_in;
    wire signed [47:0] envelope_filter$data_out;
    wire  envelope_filter$strobe_out;
    reg  envelope_filter$clock;
    wire  envelope_filter$busy;
    reg  abs$clock;
    reg signed [15:0] abs$data_in;
    reg  abs$strobe_in;
    wire signed [15:0] abs$data_out;
    wire  abs$strobe_out;
    reg  fir_buffer$clock;
    reg signed [15:0] fir_buffer$data_in;
    reg  fir_buffer$strobe_in;
    wire signed [15:0] fir_buffer$data_out;
    wire  fir_buffer$strobe_out;
    reg  env_buffer$clock;
    reg signed [15:0] env_buffer$data_in;
    reg  env_buffer$strobe_in;
    wire signed [15:0] env_buffer$data_out;
    wire  env_buffer$strobe_out;
    
    // Sub module instances
    top$demodulator$mark_pipeline$fir fir(
        .data_in(fir$data_in),
        .strobe_in(fir$strobe_in),
        .data_out(fir$data_out),
        .strobe_out(fir$strobe_out),
        .clock(fir$clock),
        .busy(fir$busy)
    );
    top$demodulator$mark_pipeline$fir_round fir_round(
        .clock(fir_round$clock),
        .data_in(fir_round$data_in),
        .data_out(fir_round$data_out),
        .strobe_in(fir_round$strobe_in),
        .strobe_out(fir_round$strobe_out)
    );
    top$demodulator$mark_pipeline$envelope_filter envelope_filter(
        .data_in(envelope_filter$data_in),
        .strobe_in(envelope_filter$strobe_in),
        .data_out(envelope_filter$data_out),
        .strobe_out(envelope_filter$strobe_out),
        .clock(envelope_filter$clock),
        .busy(envelope_filter$busy)
    );
    top$demodulator$mark_pipeline$abs abs(
        .clock(abs$clock),
        .data_in(abs$data_in),
        .strobe_in(abs$strobe_in),
        .data_out(abs$data_out),
        .strobe_out(abs$strobe_out)
    );
    top$demodulator$mark_pipeline$fir_buffer fir_buffer(
        .clock(fir_buffer$clock),
        .data_in(fir_buffer$data_in),
        .strobe_in(fir_buffer$strobe_in),
        .data_out(fir_buffer$data_out),
        .strobe_out(fir_buffer$strobe_out)
    );
    top$demodulator$mark_pipeline$env_buffer env_buffer(
        .clock(env_buffer$clock),
        .data_in(env_buffer$data_in),
        .strobe_in(env_buffer$strobe_in),
        .data_out(env_buffer$data_out),
        .strobe_out(env_buffer$strobe_out)
    );
    
    // Update code
    always @(*) begin
        fir$clock = clock;
        fir_buffer$clock = clock;
        envelope_filter$clock = clock;
        abs$clock = clock;
        env_buffer$clock = clock;
        fir_round$clock = clock;
        fir$data_in = data_in;
        fir$strobe_in = strobe_in;
        fir_round$data_in = fir$data_out;
        fir_round$strobe_in = fir$strobe_out;
        fir_buffer$data_in = fir_round$data_out;
        fir_buffer$strobe_in = fir_round$strobe_out;
        abs$data_in = fir_buffer$data_out;
        abs$strobe_in = fir_buffer$strobe_out;
        envelope_filter$data_in = abs$data_out;
        envelope_filter$strobe_in = abs$strobe_out;
        env_buffer$data_in = envelope_filter$data_out[(32'h14)+:(16)];
        env_buffer$strobe_in = envelope_filter$strobe_out;
        data_out = env_buffer$data_out;
        strobe_out = env_buffer$strobe_out;
    end
    
endmodule // top$demodulator$mark_pipeline


module top$demodulator$mark_pipeline$abs(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Constant declarations
    localparam signed max = 16'hffff;
    localparam signed one = 16'h1;
    localparam signed zero = 16'h0;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$mark_pipeline$abs$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$mark_pipeline$abs$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        strobe$d = 1'b0;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        if (data$q >= zero) begin
            data_out = data$q;
        end
        else begin
            data_out = max - data$q + one;
        end
    end
    
endmodule // top$demodulator$mark_pipeline$abs


module top$demodulator$mark_pipeline$abs$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$abs$data


module top$demodulator$mark_pipeline$abs$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$abs$strobe


module top$demodulator$mark_pipeline$env_buffer(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$mark_pipeline$env_buffer$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$mark_pipeline$env_buffer$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        data_out = data$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$mark_pipeline$env_buffer


module top$demodulator$mark_pipeline$env_buffer$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$env_buffer$data


module top$demodulator$mark_pipeline$env_buffer$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$env_buffer$strobe


module top$demodulator$mark_pipeline$envelope_filter(data_in,strobe_in,data_out,strobe_out,clock,busy);
    
    // Module arguments
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [47:0] data_out;
    output reg  strobe_out;
    input wire  clock;
    output reg  busy;
    
    // Constant declarations
    localparam  iters = 5'b111;
    localparam  bufsize = 32'h20;
    localparam  taps = 32'hf;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Stub signals
    reg  [4:0] coeff_memory$address;
    reg  coeff_memory$clock;
    wire signed [15:0] coeff_memory$data;
    reg  [4:0] left_bank$read_address;
    reg  left_bank$read_clock;
    wire signed [15:0] left_bank$read_data;
    reg  [4:0] left_bank$write_address;
    reg  left_bank$write_clock;
    reg signed [15:0] left_bank$write_data;
    reg  left_bank$write_enable;
    reg  [4:0] right_bank$read_address;
    reg  right_bank$read_clock;
    wire signed [15:0] right_bank$read_data;
    reg  [4:0] right_bank$write_address;
    reg  right_bank$write_clock;
    reg signed [15:0] right_bank$write_data;
    reg  right_bank$write_enable;
    reg  [4:0] head_ptr$d;
    wire  [4:0] head_ptr$q;
    reg  head_ptr$clock;
    reg  [4:0] index$d;
    wire  [4:0] index$q;
    reg  index$clock;
    reg signed [47:0] accum$d;
    wire signed [47:0] accum$q;
    reg  accum$clock;
    reg  [2:0] state$d;
    wire  [2:0] state$q;
    reg  state$clock;
    
    // Local signals
    reg  [4:0] left_ptr;
    reg  [4:0] right_ptr;
    reg signed [15:0] left_sample;
    reg signed [15:0] right_sample;
    reg signed [31:0] multiply_output;
    reg signed [47:0] mac_output;
    reg  [4:0] data_write;
    
    // Sub module instances
    top$demodulator$mark_pipeline$envelope_filter$coeff_memory coeff_memory(
        .address(coeff_memory$address),
        .clock(coeff_memory$clock),
        .data(coeff_memory$data)
    );
    top$demodulator$mark_pipeline$envelope_filter$left_bank left_bank(
        .read_address(left_bank$read_address),
        .read_clock(left_bank$read_clock),
        .read_data(left_bank$read_data),
        .write_address(left_bank$write_address),
        .write_clock(left_bank$write_clock),
        .write_data(left_bank$write_data),
        .write_enable(left_bank$write_enable)
    );
    top$demodulator$mark_pipeline$envelope_filter$right_bank right_bank(
        .read_address(right_bank$read_address),
        .read_clock(right_bank$read_clock),
        .read_data(right_bank$read_data),
        .write_address(right_bank$write_address),
        .write_clock(right_bank$write_clock),
        .write_data(right_bank$write_data),
        .write_enable(right_bank$write_enable)
    );
    top$demodulator$mark_pipeline$envelope_filter$head_ptr head_ptr(
        .d(head_ptr$d),
        .q(head_ptr$q),
        .clock(head_ptr$clock)
    );
    top$demodulator$mark_pipeline$envelope_filter$index index(
        .d(index$d),
        .q(index$q),
        .clock(index$clock)
    );
    top$demodulator$mark_pipeline$envelope_filter$accum accum(
        .d(accum$d),
        .q(accum$q),
        .clock(accum$clock)
    );
    top$demodulator$mark_pipeline$envelope_filter$state state(
        .d(state$d),
        .q(state$q),
        .clock(state$clock)
    );
    
    // Update code
    always @(*) begin
        coeff_memory$clock = clock;
        left_bank$read_clock = clock;
        left_bank$write_clock = clock;
        right_bank$read_clock = clock;
        right_bank$write_clock = clock;
        head_ptr$clock = clock;
        index$clock = clock;
        accum$clock = clock;
        state$clock = clock;
        head_ptr$d = head_ptr$q;
        index$d = index$q;
        accum$d = accum$q;
        state$d = state$q;
        left_bank$write_address = head_ptr$d;
        right_bank$write_address = head_ptr$d;
        left_bank$write_data = data_in;
        right_bank$write_data = data_in;
        left_bank$write_enable = strobe_in;
        right_bank$write_enable = strobe_in;
        left_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - taps + 32'h1 + ((index$q) & 32'hffffffff)) & 5'h1f);
        right_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - ((index$q) & 32'hffffffff)) & 5'h1f);
        left_bank$read_address = left_ptr;
        right_bank$read_address = right_ptr;
        coeff_memory$address = index$q;
        left_sample = left_bank$read_data;
        right_sample = right_bank$read_data;
        if (state$q == MACFIRState$CenterTap) begin
            right_sample = 32'h0;
        end
        multiply_output = (left_sample + right_sample) * (coeff_memory$data);
        mac_output = $signed(multiply_output) + accum$q;
        if (state$q == MACFIRState$Idle) begin
            mac_output = 32'h0;
        end
        data_write = head_ptr$q;
        data_out = accum$q;
        strobe_out = 1'b0;
        busy = state$q != MACFIRState$Idle;
        case (state$q)
            MACFIRState$Idle:
                begin
                    if (strobe_in) begin
                        state$d = MACFIRState$Dwell;
                    end
                end
            MACFIRState$Dwell:
                begin
                    index$d = index$q + 32'h1;
                    state$d = MACFIRState$Compute;
                end
            MACFIRState$Compute:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    if (index$q == iters) begin
                        state$d = MACFIRState$CenterTap;
                    end
                end
            MACFIRState$CenterTap:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    state$d = MACFIRState$Write;
                end
            MACFIRState$Write:
                begin
                    strobe_out = 1'b1;
                    state$d = MACFIRState$Idle;
                    head_ptr$d = head_ptr$q + 32'h1;
                    index$d = 32'h0;
                    accum$d = 32'h0;
                end
            default:
                begin
                    state$d = MACFIRState$Idle;
                end
        endcase
        data_write = head_ptr$q;
    end
    
endmodule // top$demodulator$mark_pipeline$envelope_filter


module top$demodulator$mark_pipeline$envelope_filter$accum(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$envelope_filter$accum


module top$demodulator$mark_pipeline$envelope_filter$coeff_memory(address,clock,data);
    
    // Module arguments
    input wire  [4:0] address;
    input wire  clock;
    output reg signed [15:0] data;
    
    // Update code (custom)
    reg[15:0] mem [31:0];
    
    initial begin
    mem[5'b0] = 16'hf6ea;
    mem[5'b1] = 16'h501;
    mem[5'b10] = 16'h75f;
    mem[5'b11] = 16'hae9;
    mem[5'b100] = 16'hed2;
    mem[5'b101] = 16'h1250;
    mem[5'b110] = 16'h14b8;
    mem[5'b111] = 16'h1593;
    end
    
    always @(posedge clock) begin
       data <= mem[address];
    end
endmodule // top$demodulator$mark_pipeline$envelope_filter$coeff_memory


module top$demodulator$mark_pipeline$envelope_filter$head_ptr(d,q,clock);
    
    // Module arguments
    input wire  [4:0] d;
    output reg  [4:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 5'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$envelope_filter$head_ptr


module top$demodulator$mark_pipeline$envelope_filter$index(d,q,clock);
    
    // Module arguments
    input wire  [4:0] d;
    output reg  [4:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 5'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$envelope_filter$index


module top$demodulator$mark_pipeline$envelope_filter$left_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [4:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [4:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[31:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$mark_pipeline$envelope_filter$left_bank


module top$demodulator$mark_pipeline$envelope_filter$right_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [4:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [4:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[31:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$mark_pipeline$envelope_filter$right_bank


module top$demodulator$mark_pipeline$envelope_filter$state(d,q,clock);
    
    // Module arguments
    input wire  [2:0] d;
    output reg  [2:0] q;
    input wire  clock;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Update code (custom)
    initial begin
       q = 64'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$envelope_filter$state


module top$demodulator$mark_pipeline$fir(data_in,strobe_in,data_out,strobe_out,clock,busy);
    
    // Module arguments
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [47:0] data_out;
    output reg  strobe_out;
    input wire  clock;
    output reg  busy;
    
    // Constant declarations
    localparam  iters = 7'b1000;
    localparam  bufsize = 32'h80;
    localparam  taps = 32'h11;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Stub signals
    reg  [6:0] coeff_memory$address;
    reg  coeff_memory$clock;
    wire signed [15:0] coeff_memory$data;
    reg  [6:0] left_bank$read_address;
    reg  left_bank$read_clock;
    wire signed [15:0] left_bank$read_data;
    reg  [6:0] left_bank$write_address;
    reg  left_bank$write_clock;
    reg signed [15:0] left_bank$write_data;
    reg  left_bank$write_enable;
    reg  [6:0] right_bank$read_address;
    reg  right_bank$read_clock;
    wire signed [15:0] right_bank$read_data;
    reg  [6:0] right_bank$write_address;
    reg  right_bank$write_clock;
    reg signed [15:0] right_bank$write_data;
    reg  right_bank$write_enable;
    reg  [6:0] head_ptr$d;
    wire  [6:0] head_ptr$q;
    reg  head_ptr$clock;
    reg  [6:0] index$d;
    wire  [6:0] index$q;
    reg  index$clock;
    reg signed [47:0] accum$d;
    wire signed [47:0] accum$q;
    reg  accum$clock;
    reg  [2:0] state$d;
    wire  [2:0] state$q;
    reg  state$clock;
    
    // Local signals
    reg  [6:0] left_ptr;
    reg  [6:0] right_ptr;
    reg signed [15:0] left_sample;
    reg signed [15:0] right_sample;
    reg signed [31:0] multiply_output;
    reg signed [47:0] mac_output;
    reg  [6:0] data_write;
    
    // Sub module instances
    top$demodulator$mark_pipeline$fir$coeff_memory coeff_memory(
        .address(coeff_memory$address),
        .clock(coeff_memory$clock),
        .data(coeff_memory$data)
    );
    top$demodulator$mark_pipeline$fir$left_bank left_bank(
        .read_address(left_bank$read_address),
        .read_clock(left_bank$read_clock),
        .read_data(left_bank$read_data),
        .write_address(left_bank$write_address),
        .write_clock(left_bank$write_clock),
        .write_data(left_bank$write_data),
        .write_enable(left_bank$write_enable)
    );
    top$demodulator$mark_pipeline$fir$right_bank right_bank(
        .read_address(right_bank$read_address),
        .read_clock(right_bank$read_clock),
        .read_data(right_bank$read_data),
        .write_address(right_bank$write_address),
        .write_clock(right_bank$write_clock),
        .write_data(right_bank$write_data),
        .write_enable(right_bank$write_enable)
    );
    top$demodulator$mark_pipeline$fir$head_ptr head_ptr(
        .d(head_ptr$d),
        .q(head_ptr$q),
        .clock(head_ptr$clock)
    );
    top$demodulator$mark_pipeline$fir$index index(
        .d(index$d),
        .q(index$q),
        .clock(index$clock)
    );
    top$demodulator$mark_pipeline$fir$accum accum(
        .d(accum$d),
        .q(accum$q),
        .clock(accum$clock)
    );
    top$demodulator$mark_pipeline$fir$state state(
        .d(state$d),
        .q(state$q),
        .clock(state$clock)
    );
    
    // Update code
    always @(*) begin
        coeff_memory$clock = clock;
        left_bank$read_clock = clock;
        left_bank$write_clock = clock;
        right_bank$read_clock = clock;
        right_bank$write_clock = clock;
        head_ptr$clock = clock;
        index$clock = clock;
        accum$clock = clock;
        state$clock = clock;
        head_ptr$d = head_ptr$q;
        index$d = index$q;
        accum$d = accum$q;
        state$d = state$q;
        left_bank$write_address = head_ptr$d;
        right_bank$write_address = head_ptr$d;
        left_bank$write_data = data_in;
        right_bank$write_data = data_in;
        left_bank$write_enable = strobe_in;
        right_bank$write_enable = strobe_in;
        left_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - taps + 32'h1 + ((index$q) & 32'hffffffff)) & 7'h7f);
        right_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - ((index$q) & 32'hffffffff)) & 7'h7f);
        left_bank$read_address = left_ptr;
        right_bank$read_address = right_ptr;
        coeff_memory$address = index$q;
        left_sample = left_bank$read_data;
        right_sample = right_bank$read_data;
        if (state$q == MACFIRState$CenterTap) begin
            right_sample = 32'h0;
        end
        multiply_output = (left_sample + right_sample) * (coeff_memory$data);
        mac_output = $signed(multiply_output) + accum$q;
        if (state$q == MACFIRState$Idle) begin
            mac_output = 32'h0;
        end
        data_write = head_ptr$q;
        data_out = accum$q;
        strobe_out = 1'b0;
        busy = state$q != MACFIRState$Idle;
        case (state$q)
            MACFIRState$Idle:
                begin
                    if (strobe_in) begin
                        state$d = MACFIRState$Dwell;
                    end
                end
            MACFIRState$Dwell:
                begin
                    index$d = index$q + 32'h1;
                    state$d = MACFIRState$Compute;
                end
            MACFIRState$Compute:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    if (index$q == iters) begin
                        state$d = MACFIRState$CenterTap;
                    end
                end
            MACFIRState$CenterTap:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    state$d = MACFIRState$Write;
                end
            MACFIRState$Write:
                begin
                    strobe_out = 1'b1;
                    state$d = MACFIRState$Idle;
                    head_ptr$d = head_ptr$q + 32'h1;
                    index$d = 32'h0;
                    accum$d = 32'h0;
                end
            default:
                begin
                    state$d = MACFIRState$Idle;
                end
        endcase
        data_write = head_ptr$q;
    end
    
endmodule // top$demodulator$mark_pipeline$fir


module top$demodulator$mark_pipeline$fir$accum(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir$accum


module top$demodulator$mark_pipeline$fir$coeff_memory(address,clock,data);
    
    // Module arguments
    input wire  [6:0] address;
    input wire  clock;
    output reg signed [15:0] data;
    
    // Update code (custom)
    reg[15:0] mem [127:0];
    
    initial begin
    mem[7'b0] = 16'hf4d7;
    mem[7'b1] = 16'h819;
    mem[7'b10] = 16'hb59;
    mem[7'b11] = 16'hc61;
    mem[7'b100] = 16'h772;
    mem[7'b101] = 16'hfbed;
    mem[7'b110] = 16'hed0a;
    mem[7'b111] = 16'he07a;
    mem[7'b1000] = 16'h5b92;
    end
    
    always @(posedge clock) begin
       data <= mem[address];
    end
endmodule // top$demodulator$mark_pipeline$fir$coeff_memory


module top$demodulator$mark_pipeline$fir$head_ptr(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir$head_ptr


module top$demodulator$mark_pipeline$fir$index(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir$index


module top$demodulator$mark_pipeline$fir$left_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$mark_pipeline$fir$left_bank


module top$demodulator$mark_pipeline$fir$right_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$mark_pipeline$fir$right_bank


module top$demodulator$mark_pipeline$fir$state(d,q,clock);
    
    // Module arguments
    input wire  [2:0] d;
    output reg  [2:0] q;
    input wire  clock;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Update code (custom)
    initial begin
       q = 64'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir$state


module top$demodulator$mark_pipeline$fir_buffer(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$mark_pipeline$fir_buffer$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$mark_pipeline$fir_buffer$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        data_out = data$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$mark_pipeline$fir_buffer


module top$demodulator$mark_pipeline$fir_buffer$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir_buffer$data


module top$demodulator$mark_pipeline$fir_buffer$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir_buffer$strobe


module top$demodulator$mark_pipeline$fir_round(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [47:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [47:0] data$d;
    wire signed [47:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Local signals
    reg signed [15:0] truncated;
    
    // Sub module instances
    top$demodulator$mark_pipeline$fir_round$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$mark_pipeline$fir_round$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        if (strobe$q) begin
            strobe$d = 1'b0;
        end
        truncated = data$q[(32'h10)+:(16)];
        if (data$q[32'he]) begin
            data_out = truncated + 32'h1;
        end
        else begin
            data_out = truncated;
        end
    end
    
endmodule // top$demodulator$mark_pipeline$fir_round


module top$demodulator$mark_pipeline$fir_round$data(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir_round$data


module top$demodulator$mark_pipeline$fir_round$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mark_pipeline$fir_round$strobe


module top$demodulator$mixer(clock,data_in_1,data_in_2,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in_1;
    input wire signed [15:0] data_in_2;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Enums
    localparam MixerState$Idle = 0;
    localparam MixerState$Dwell = 1;
    localparam MixerState$Compute = 2;
    localparam MixerState$Round = 3;
    localparam MixerState$Done = 4;
    
    // Stub signals
    reg signed [15:0] data_1$d;
    wire signed [15:0] data_1$q;
    reg  data_1$clock;
    reg signed [15:0] data_2$d;
    wire signed [15:0] data_2$q;
    reg  data_2$clock;
    reg  output_round$clock;
    reg signed [31:0] output_round$data_in;
    wire signed [15:0] output_round$data_out;
    reg  output_round$strobe_in;
    wire  output_round$strobe_out;
    reg  [2:0] state$d;
    wire  [2:0] state$q;
    reg  state$clock;
    
    // Sub module instances
    top$demodulator$mixer$data_1 data_1(
        .d(data_1$d),
        .q(data_1$q),
        .clock(data_1$clock)
    );
    top$demodulator$mixer$data_2 data_2(
        .d(data_2$d),
        .q(data_2$q),
        .clock(data_2$clock)
    );
    top$demodulator$mixer$output_round output_round(
        .clock(output_round$clock),
        .data_in(output_round$data_in),
        .data_out(output_round$data_out),
        .strobe_in(output_round$strobe_in),
        .strobe_out(output_round$strobe_out)
    );
    top$demodulator$mixer$state state(
        .d(state$d),
        .q(state$q),
        .clock(state$clock)
    );
    
    // Update code
    always @(*) begin
        output_round$clock = clock;
        data_1$clock = clock;
        data_2$clock = clock;
        state$clock = clock;
        data_1$d = data_1$q;
        data_2$d = data_2$q;
        state$d = state$q;
        output_round$data_in = data_1$q * data_2$q;
        data_out = output_round$data_out;
        strobe_out = 1'b0;
        output_round$strobe_in = 1'b0;
        case (state$q)
            MixerState$Idle:
                begin
                    if (strobe_in) begin
                        data_1$d = data_in_1;
                        data_2$d = data_in_2;
                        state$d = MixerState$Dwell;
                    end
                end
            MixerState$Dwell:
                begin
                    state$d = MixerState$Compute;
                end
            MixerState$Compute:
                begin
                    state$d = MixerState$Round;
                end
            MixerState$Round:
                begin
                    output_round$strobe_in = 1'b1;
                    state$d = MixerState$Done;
                end
            MixerState$Done:
                begin
                    strobe_out = 1'b1;
                    state$d = MixerState$Idle;
                end
        endcase
    end
    
endmodule // top$demodulator$mixer


module top$demodulator$mixer$data_1(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mixer$data_1


module top$demodulator$mixer$data_2(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mixer$data_2


module top$demodulator$mixer$output_round(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [31:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [31:0] data$d;
    wire signed [31:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Local signals
    reg signed [15:0] truncated;
    
    // Sub module instances
    top$demodulator$mixer$output_round$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$mixer$output_round$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        if (strobe$q) begin
            strobe$d = 1'b0;
        end
        truncated = data$q[(32'h10)+:(16)];
        if (data$q[32'he]) begin
            data_out = truncated + 32'h1;
        end
        else begin
            data_out = truncated;
        end
    end
    
endmodule // top$demodulator$mixer$output_round


module top$demodulator$mixer$output_round$data(d,q,clock);
    
    // Module arguments
    input wire signed [31:0] d;
    output reg signed [31:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 32'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mixer$output_round$data


module top$demodulator$mixer$output_round$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mixer$output_round$strobe


module top$demodulator$mixer$state(d,q,clock);
    
    // Module arguments
    input wire  [2:0] d;
    output reg  [2:0] q;
    input wire  clock;
    
    // Enums
    localparam MixerState$Idle = 0;
    localparam MixerState$Dwell = 1;
    localparam MixerState$Compute = 2;
    localparam MixerState$Round = 3;
    localparam MixerState$Done = 4;
    
    // Update code (custom)
    initial begin
       q = 64'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$mixer$state


module top$demodulator$space_pipeline(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] fir$data_in;
    reg  fir$strobe_in;
    wire signed [47:0] fir$data_out;
    wire  fir$strobe_out;
    reg  fir$clock;
    wire  fir$busy;
    reg  fir_round$clock;
    reg signed [47:0] fir_round$data_in;
    wire signed [15:0] fir_round$data_out;
    reg  fir_round$strobe_in;
    wire  fir_round$strobe_out;
    reg signed [15:0] envelope_filter$data_in;
    reg  envelope_filter$strobe_in;
    wire signed [47:0] envelope_filter$data_out;
    wire  envelope_filter$strobe_out;
    reg  envelope_filter$clock;
    wire  envelope_filter$busy;
    reg  abs$clock;
    reg signed [15:0] abs$data_in;
    reg  abs$strobe_in;
    wire signed [15:0] abs$data_out;
    wire  abs$strobe_out;
    reg  fir_buffer$clock;
    reg signed [15:0] fir_buffer$data_in;
    reg  fir_buffer$strobe_in;
    wire signed [15:0] fir_buffer$data_out;
    wire  fir_buffer$strobe_out;
    reg  env_buffer$clock;
    reg signed [15:0] env_buffer$data_in;
    reg  env_buffer$strobe_in;
    wire signed [15:0] env_buffer$data_out;
    wire  env_buffer$strobe_out;
    
    // Sub module instances
    top$demodulator$space_pipeline$fir fir(
        .data_in(fir$data_in),
        .strobe_in(fir$strobe_in),
        .data_out(fir$data_out),
        .strobe_out(fir$strobe_out),
        .clock(fir$clock),
        .busy(fir$busy)
    );
    top$demodulator$space_pipeline$fir_round fir_round(
        .clock(fir_round$clock),
        .data_in(fir_round$data_in),
        .data_out(fir_round$data_out),
        .strobe_in(fir_round$strobe_in),
        .strobe_out(fir_round$strobe_out)
    );
    top$demodulator$space_pipeline$envelope_filter envelope_filter(
        .data_in(envelope_filter$data_in),
        .strobe_in(envelope_filter$strobe_in),
        .data_out(envelope_filter$data_out),
        .strobe_out(envelope_filter$strobe_out),
        .clock(envelope_filter$clock),
        .busy(envelope_filter$busy)
    );
    top$demodulator$space_pipeline$abs abs(
        .clock(abs$clock),
        .data_in(abs$data_in),
        .strobe_in(abs$strobe_in),
        .data_out(abs$data_out),
        .strobe_out(abs$strobe_out)
    );
    top$demodulator$space_pipeline$fir_buffer fir_buffer(
        .clock(fir_buffer$clock),
        .data_in(fir_buffer$data_in),
        .strobe_in(fir_buffer$strobe_in),
        .data_out(fir_buffer$data_out),
        .strobe_out(fir_buffer$strobe_out)
    );
    top$demodulator$space_pipeline$env_buffer env_buffer(
        .clock(env_buffer$clock),
        .data_in(env_buffer$data_in),
        .strobe_in(env_buffer$strobe_in),
        .data_out(env_buffer$data_out),
        .strobe_out(env_buffer$strobe_out)
    );
    
    // Update code
    always @(*) begin
        fir$clock = clock;
        fir_buffer$clock = clock;
        envelope_filter$clock = clock;
        abs$clock = clock;
        env_buffer$clock = clock;
        fir_round$clock = clock;
        fir$data_in = data_in;
        fir$strobe_in = strobe_in;
        fir_round$data_in = fir$data_out;
        fir_round$strobe_in = fir$strobe_out;
        fir_buffer$data_in = fir_round$data_out;
        fir_buffer$strobe_in = fir_round$strobe_out;
        abs$data_in = fir_buffer$data_out;
        abs$strobe_in = fir_buffer$strobe_out;
        envelope_filter$data_in = abs$data_out;
        envelope_filter$strobe_in = abs$strobe_out;
        env_buffer$data_in = envelope_filter$data_out[(32'h14)+:(16)];
        env_buffer$strobe_in = envelope_filter$strobe_out;
        data_out = env_buffer$data_out;
        strobe_out = env_buffer$strobe_out;
    end
    
endmodule // top$demodulator$space_pipeline


module top$demodulator$space_pipeline$abs(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Constant declarations
    localparam signed max = 16'hffff;
    localparam signed one = 16'h1;
    localparam signed zero = 16'h0;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$space_pipeline$abs$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$space_pipeline$abs$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        strobe$d = 1'b0;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        if (data$q >= zero) begin
            data_out = data$q;
        end
        else begin
            data_out = max - data$q + one;
        end
    end
    
endmodule // top$demodulator$space_pipeline$abs


module top$demodulator$space_pipeline$abs$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$abs$data


module top$demodulator$space_pipeline$abs$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$abs$strobe


module top$demodulator$space_pipeline$env_buffer(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$space_pipeline$env_buffer$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$space_pipeline$env_buffer$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        data_out = data$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$space_pipeline$env_buffer


module top$demodulator$space_pipeline$env_buffer$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$env_buffer$data


module top$demodulator$space_pipeline$env_buffer$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$env_buffer$strobe


module top$demodulator$space_pipeline$envelope_filter(data_in,strobe_in,data_out,strobe_out,clock,busy);
    
    // Module arguments
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [47:0] data_out;
    output reg  strobe_out;
    input wire  clock;
    output reg  busy;
    
    // Constant declarations
    localparam  iters = 5'b111;
    localparam  bufsize = 32'h20;
    localparam  taps = 32'hf;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Stub signals
    reg  [4:0] coeff_memory$address;
    reg  coeff_memory$clock;
    wire signed [15:0] coeff_memory$data;
    reg  [4:0] left_bank$read_address;
    reg  left_bank$read_clock;
    wire signed [15:0] left_bank$read_data;
    reg  [4:0] left_bank$write_address;
    reg  left_bank$write_clock;
    reg signed [15:0] left_bank$write_data;
    reg  left_bank$write_enable;
    reg  [4:0] right_bank$read_address;
    reg  right_bank$read_clock;
    wire signed [15:0] right_bank$read_data;
    reg  [4:0] right_bank$write_address;
    reg  right_bank$write_clock;
    reg signed [15:0] right_bank$write_data;
    reg  right_bank$write_enable;
    reg  [4:0] head_ptr$d;
    wire  [4:0] head_ptr$q;
    reg  head_ptr$clock;
    reg  [4:0] index$d;
    wire  [4:0] index$q;
    reg  index$clock;
    reg signed [47:0] accum$d;
    wire signed [47:0] accum$q;
    reg  accum$clock;
    reg  [2:0] state$d;
    wire  [2:0] state$q;
    reg  state$clock;
    
    // Local signals
    reg  [4:0] left_ptr;
    reg  [4:0] right_ptr;
    reg signed [15:0] left_sample;
    reg signed [15:0] right_sample;
    reg signed [31:0] multiply_output;
    reg signed [47:0] mac_output;
    reg  [4:0] data_write;
    
    // Sub module instances
    top$demodulator$space_pipeline$envelope_filter$coeff_memory coeff_memory(
        .address(coeff_memory$address),
        .clock(coeff_memory$clock),
        .data(coeff_memory$data)
    );
    top$demodulator$space_pipeline$envelope_filter$left_bank left_bank(
        .read_address(left_bank$read_address),
        .read_clock(left_bank$read_clock),
        .read_data(left_bank$read_data),
        .write_address(left_bank$write_address),
        .write_clock(left_bank$write_clock),
        .write_data(left_bank$write_data),
        .write_enable(left_bank$write_enable)
    );
    top$demodulator$space_pipeline$envelope_filter$right_bank right_bank(
        .read_address(right_bank$read_address),
        .read_clock(right_bank$read_clock),
        .read_data(right_bank$read_data),
        .write_address(right_bank$write_address),
        .write_clock(right_bank$write_clock),
        .write_data(right_bank$write_data),
        .write_enable(right_bank$write_enable)
    );
    top$demodulator$space_pipeline$envelope_filter$head_ptr head_ptr(
        .d(head_ptr$d),
        .q(head_ptr$q),
        .clock(head_ptr$clock)
    );
    top$demodulator$space_pipeline$envelope_filter$index index(
        .d(index$d),
        .q(index$q),
        .clock(index$clock)
    );
    top$demodulator$space_pipeline$envelope_filter$accum accum(
        .d(accum$d),
        .q(accum$q),
        .clock(accum$clock)
    );
    top$demodulator$space_pipeline$envelope_filter$state state(
        .d(state$d),
        .q(state$q),
        .clock(state$clock)
    );
    
    // Update code
    always @(*) begin
        coeff_memory$clock = clock;
        left_bank$read_clock = clock;
        left_bank$write_clock = clock;
        right_bank$read_clock = clock;
        right_bank$write_clock = clock;
        head_ptr$clock = clock;
        index$clock = clock;
        accum$clock = clock;
        state$clock = clock;
        head_ptr$d = head_ptr$q;
        index$d = index$q;
        accum$d = accum$q;
        state$d = state$q;
        left_bank$write_address = head_ptr$d;
        right_bank$write_address = head_ptr$d;
        left_bank$write_data = data_in;
        right_bank$write_data = data_in;
        left_bank$write_enable = strobe_in;
        right_bank$write_enable = strobe_in;
        left_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - taps + 32'h1 + ((index$q) & 32'hffffffff)) & 5'h1f);
        right_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - ((index$q) & 32'hffffffff)) & 5'h1f);
        left_bank$read_address = left_ptr;
        right_bank$read_address = right_ptr;
        coeff_memory$address = index$q;
        left_sample = left_bank$read_data;
        right_sample = right_bank$read_data;
        if (state$q == MACFIRState$CenterTap) begin
            right_sample = 32'h0;
        end
        multiply_output = (left_sample + right_sample) * (coeff_memory$data);
        mac_output = $signed(multiply_output) + accum$q;
        if (state$q == MACFIRState$Idle) begin
            mac_output = 32'h0;
        end
        data_write = head_ptr$q;
        data_out = accum$q;
        strobe_out = 1'b0;
        busy = state$q != MACFIRState$Idle;
        case (state$q)
            MACFIRState$Idle:
                begin
                    if (strobe_in) begin
                        state$d = MACFIRState$Dwell;
                    end
                end
            MACFIRState$Dwell:
                begin
                    index$d = index$q + 32'h1;
                    state$d = MACFIRState$Compute;
                end
            MACFIRState$Compute:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    if (index$q == iters) begin
                        state$d = MACFIRState$CenterTap;
                    end
                end
            MACFIRState$CenterTap:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    state$d = MACFIRState$Write;
                end
            MACFIRState$Write:
                begin
                    strobe_out = 1'b1;
                    state$d = MACFIRState$Idle;
                    head_ptr$d = head_ptr$q + 32'h1;
                    index$d = 32'h0;
                    accum$d = 32'h0;
                end
            default:
                begin
                    state$d = MACFIRState$Idle;
                end
        endcase
        data_write = head_ptr$q;
    end
    
endmodule // top$demodulator$space_pipeline$envelope_filter


module top$demodulator$space_pipeline$envelope_filter$accum(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$envelope_filter$accum


module top$demodulator$space_pipeline$envelope_filter$coeff_memory(address,clock,data);
    
    // Module arguments
    input wire  [4:0] address;
    input wire  clock;
    output reg signed [15:0] data;
    
    // Update code (custom)
    reg[15:0] mem [31:0];
    
    initial begin
    mem[5'b0] = 16'hf6ea;
    mem[5'b1] = 16'h501;
    mem[5'b10] = 16'h75f;
    mem[5'b11] = 16'hae9;
    mem[5'b100] = 16'hed2;
    mem[5'b101] = 16'h1250;
    mem[5'b110] = 16'h14b8;
    mem[5'b111] = 16'h1593;
    end
    
    always @(posedge clock) begin
       data <= mem[address];
    end
endmodule // top$demodulator$space_pipeline$envelope_filter$coeff_memory


module top$demodulator$space_pipeline$envelope_filter$head_ptr(d,q,clock);
    
    // Module arguments
    input wire  [4:0] d;
    output reg  [4:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 5'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$envelope_filter$head_ptr


module top$demodulator$space_pipeline$envelope_filter$index(d,q,clock);
    
    // Module arguments
    input wire  [4:0] d;
    output reg  [4:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 5'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$envelope_filter$index


module top$demodulator$space_pipeline$envelope_filter$left_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [4:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [4:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[31:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$space_pipeline$envelope_filter$left_bank


module top$demodulator$space_pipeline$envelope_filter$right_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [4:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [4:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[31:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$space_pipeline$envelope_filter$right_bank


module top$demodulator$space_pipeline$envelope_filter$state(d,q,clock);
    
    // Module arguments
    input wire  [2:0] d;
    output reg  [2:0] q;
    input wire  clock;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Update code (custom)
    initial begin
       q = 64'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$envelope_filter$state


module top$demodulator$space_pipeline$fir(data_in,strobe_in,data_out,strobe_out,clock,busy);
    
    // Module arguments
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [47:0] data_out;
    output reg  strobe_out;
    input wire  clock;
    output reg  busy;
    
    // Constant declarations
    localparam  iters = 7'b111;
    localparam  bufsize = 32'h80;
    localparam  taps = 32'hf;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Stub signals
    reg  [6:0] coeff_memory$address;
    reg  coeff_memory$clock;
    wire signed [15:0] coeff_memory$data;
    reg  [6:0] left_bank$read_address;
    reg  left_bank$read_clock;
    wire signed [15:0] left_bank$read_data;
    reg  [6:0] left_bank$write_address;
    reg  left_bank$write_clock;
    reg signed [15:0] left_bank$write_data;
    reg  left_bank$write_enable;
    reg  [6:0] right_bank$read_address;
    reg  right_bank$read_clock;
    wire signed [15:0] right_bank$read_data;
    reg  [6:0] right_bank$write_address;
    reg  right_bank$write_clock;
    reg signed [15:0] right_bank$write_data;
    reg  right_bank$write_enable;
    reg  [6:0] head_ptr$d;
    wire  [6:0] head_ptr$q;
    reg  head_ptr$clock;
    reg  [6:0] index$d;
    wire  [6:0] index$q;
    reg  index$clock;
    reg signed [47:0] accum$d;
    wire signed [47:0] accum$q;
    reg  accum$clock;
    reg  [2:0] state$d;
    wire  [2:0] state$q;
    reg  state$clock;
    
    // Local signals
    reg  [6:0] left_ptr;
    reg  [6:0] right_ptr;
    reg signed [15:0] left_sample;
    reg signed [15:0] right_sample;
    reg signed [31:0] multiply_output;
    reg signed [47:0] mac_output;
    reg  [6:0] data_write;
    
    // Sub module instances
    top$demodulator$space_pipeline$fir$coeff_memory coeff_memory(
        .address(coeff_memory$address),
        .clock(coeff_memory$clock),
        .data(coeff_memory$data)
    );
    top$demodulator$space_pipeline$fir$left_bank left_bank(
        .read_address(left_bank$read_address),
        .read_clock(left_bank$read_clock),
        .read_data(left_bank$read_data),
        .write_address(left_bank$write_address),
        .write_clock(left_bank$write_clock),
        .write_data(left_bank$write_data),
        .write_enable(left_bank$write_enable)
    );
    top$demodulator$space_pipeline$fir$right_bank right_bank(
        .read_address(right_bank$read_address),
        .read_clock(right_bank$read_clock),
        .read_data(right_bank$read_data),
        .write_address(right_bank$write_address),
        .write_clock(right_bank$write_clock),
        .write_data(right_bank$write_data),
        .write_enable(right_bank$write_enable)
    );
    top$demodulator$space_pipeline$fir$head_ptr head_ptr(
        .d(head_ptr$d),
        .q(head_ptr$q),
        .clock(head_ptr$clock)
    );
    top$demodulator$space_pipeline$fir$index index(
        .d(index$d),
        .q(index$q),
        .clock(index$clock)
    );
    top$demodulator$space_pipeline$fir$accum accum(
        .d(accum$d),
        .q(accum$q),
        .clock(accum$clock)
    );
    top$demodulator$space_pipeline$fir$state state(
        .d(state$d),
        .q(state$q),
        .clock(state$clock)
    );
    
    // Update code
    always @(*) begin
        coeff_memory$clock = clock;
        left_bank$read_clock = clock;
        left_bank$write_clock = clock;
        right_bank$read_clock = clock;
        right_bank$write_clock = clock;
        head_ptr$clock = clock;
        index$clock = clock;
        accum$clock = clock;
        state$clock = clock;
        head_ptr$d = head_ptr$q;
        index$d = index$q;
        accum$d = accum$q;
        state$d = state$q;
        left_bank$write_address = head_ptr$d;
        right_bank$write_address = head_ptr$d;
        left_bank$write_data = data_in;
        right_bank$write_data = data_in;
        left_bank$write_enable = strobe_in;
        right_bank$write_enable = strobe_in;
        left_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - taps + 32'h1 + ((index$q) & 32'hffffffff)) & 7'h7f);
        right_ptr = ((((head_ptr$q) & 32'hffffffff) + bufsize - ((index$q) & 32'hffffffff)) & 7'h7f);
        left_bank$read_address = left_ptr;
        right_bank$read_address = right_ptr;
        coeff_memory$address = index$q;
        left_sample = left_bank$read_data;
        right_sample = right_bank$read_data;
        if (state$q == MACFIRState$CenterTap) begin
            right_sample = 32'h0;
        end
        multiply_output = (left_sample + right_sample) * (coeff_memory$data);
        mac_output = $signed(multiply_output) + accum$q;
        if (state$q == MACFIRState$Idle) begin
            mac_output = 32'h0;
        end
        data_write = head_ptr$q;
        data_out = accum$q;
        strobe_out = 1'b0;
        busy = state$q != MACFIRState$Idle;
        case (state$q)
            MACFIRState$Idle:
                begin
                    if (strobe_in) begin
                        state$d = MACFIRState$Dwell;
                    end
                end
            MACFIRState$Dwell:
                begin
                    index$d = index$q + 32'h1;
                    state$d = MACFIRState$Compute;
                end
            MACFIRState$Compute:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    if (index$q == iters) begin
                        state$d = MACFIRState$CenterTap;
                    end
                end
            MACFIRState$CenterTap:
                begin
                    index$d = index$q + 32'h1;
                    accum$d = mac_output;
                    state$d = MACFIRState$Write;
                end
            MACFIRState$Write:
                begin
                    strobe_out = 1'b1;
                    state$d = MACFIRState$Idle;
                    head_ptr$d = head_ptr$q + 32'h1;
                    index$d = 32'h0;
                    accum$d = 32'h0;
                end
            default:
                begin
                    state$d = MACFIRState$Idle;
                end
        endcase
        data_write = head_ptr$q;
    end
    
endmodule // top$demodulator$space_pipeline$fir


module top$demodulator$space_pipeline$fir$accum(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir$accum


module top$demodulator$space_pipeline$fir$coeff_memory(address,clock,data);
    
    // Module arguments
    input wire  [6:0] address;
    input wire  clock;
    output reg signed [15:0] data;
    
    // Update code (custom)
    reg[15:0] mem [127:0];
    
    initial begin
    mem[7'b0] = 16'hcd2;
    mem[7'b1] = 16'he250;
    mem[7'b10] = 16'hf01c;
    mem[7'b11] = 16'hf6b8;
    mem[7'b100] = 16'hfc69;
    mem[7'b101] = 16'h22f;
    mem[7'b110] = 16'h6a9;
    mem[7'b111] = 16'h855;
    end
    
    always @(posedge clock) begin
       data <= mem[address];
    end
endmodule // top$demodulator$space_pipeline$fir$coeff_memory


module top$demodulator$space_pipeline$fir$head_ptr(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir$head_ptr


module top$demodulator$space_pipeline$fir$index(d,q,clock);
    
    // Module arguments
    input wire  [6:0] d;
    output reg  [6:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 7'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir$index


module top$demodulator$space_pipeline$fir$left_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$space_pipeline$fir$left_bank


module top$demodulator$space_pipeline$fir$right_bank(read_address,read_clock,read_data,write_address,write_clock,write_data,write_enable);
    
    // Module arguments
    input wire  [6:0] read_address;
    input wire  read_clock;
    output reg signed [15:0] read_data;
    input wire  [6:0] write_address;
    input wire  write_clock;
    input wire signed [15:0] write_data;
    input wire  write_enable;
    
    // Update code (custom)
    reg[15:0] mem[127:0];
    
    
    
    always @(posedge read_clock) begin
       read_data <= mem[read_address];
    end
    
    always @(posedge write_clock) begin
       if (write_enable) begin
          mem[write_address] <= write_data;
       end
    end
                
endmodule // top$demodulator$space_pipeline$fir$right_bank


module top$demodulator$space_pipeline$fir$state(d,q,clock);
    
    // Module arguments
    input wire  [2:0] d;
    output reg  [2:0] q;
    input wire  clock;
    
    // Enums
    localparam MACFIRState$Idle = 0;
    localparam MACFIRState$Dwell = 1;
    localparam MACFIRState$Compute = 2;
    localparam MACFIRState$CenterTap = 3;
    localparam MACFIRState$Write = 4;
    
    // Update code (custom)
    initial begin
       q = 64'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir$state


module top$demodulator$space_pipeline$fir_buffer(clock,data_in,strobe_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [15:0] data_in;
    input wire  strobe_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [15:0] data$d;
    wire signed [15:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Sub module instances
    top$demodulator$space_pipeline$fir_buffer$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$space_pipeline$fir_buffer$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        data_out = data$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$demodulator$space_pipeline$fir_buffer


module top$demodulator$space_pipeline$fir_buffer$data(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir_buffer$data


module top$demodulator$space_pipeline$fir_buffer$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir_buffer$strobe


module top$demodulator$space_pipeline$fir_round(clock,data_in,data_out,strobe_in,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire signed [47:0] data_in;
    output reg signed [15:0] data_out;
    input wire  strobe_in;
    output reg  strobe_out;
    
    // Stub signals
    reg signed [47:0] data$d;
    wire signed [47:0] data$q;
    reg  data$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    
    // Local signals
    reg signed [15:0] truncated;
    
    // Sub module instances
    top$demodulator$space_pipeline$fir_round$data data(
        .d(data$d),
        .q(data$q),
        .clock(data$clock)
    );
    top$demodulator$space_pipeline$fir_round$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    
    // Update code
    always @(*) begin
        data$clock = clock;
        strobe$clock = clock;
        data$d = data$q;
        strobe$d = strobe$q;
        strobe_out = strobe$q;
        if (strobe_in) begin
            data$d = data_in;
            strobe$d = 1'b1;
        end
        if (strobe$q) begin
            strobe$d = 1'b0;
        end
        truncated = data$q[(32'h10)+:(16)];
        if (data$q[32'he]) begin
            data_out = truncated + 32'h1;
        end
        else begin
            data_out = truncated;
        end
    end
    
endmodule // top$demodulator$space_pipeline$fir_round


module top$demodulator$space_pipeline$fir_round$data(d,q,clock);
    
    // Module arguments
    input wire signed [47:0] d;
    output reg signed [47:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 48'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir_round$data


module top$demodulator$space_pipeline$fir_round$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$demodulator$space_pipeline$fir_round$strobe


module top$mark(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$mark


module top$modulator(clock,mark_in,data_out,strobe_out);
    
    // Module arguments
    input wire  clock;
    input wire  mark_in;
    output reg signed [15:0] data_out;
    output reg  strobe_out;
    
    // Stub signals
    reg  dds$clock;
    wire signed [15:0] dds$data_out;
    reg  dds$mark;
    wire  dds$strobe_out;
    reg  mark$d;
    wire  mark$q;
    reg  mark$clock;
    
    // Sub module instances
    top$modulator$dds dds(
        .clock(dds$clock),
        .data_out(dds$data_out),
        .mark(dds$mark),
        .strobe_out(dds$strobe_out)
    );
    top$modulator$mark mark(
        .d(mark$d),
        .q(mark$q),
        .clock(mark$clock)
    );
    
    // Update code
    always @(*) begin
        dds$clock = clock;
        mark$clock = clock;
        mark$d = mark$q;
        mark$d = mark_in;
        dds$mark = mark$q;
        data_out = dds$data_out;
        strobe_out = dds$strobe_out;
    end
    
endmodule // top$modulator


module top$modulator$dds(clock,data_out,mark,strobe_out);
    
    // Module arguments
    input wire  clock;
    output reg signed [15:0] data_out;
    input wire  mark;
    output reg  strobe_out;
    
    // Stub signals
    reg  [7:0] sin_rom$address;
    wire signed [15:0] sin_rom$data;
    reg  phase_accumulator$clock;
    wire  [7:0] phase_accumulator$ramp;
    wire  phase_accumulator$strobe_out;
    reg  phase_accumulator$mark;
    reg signed [15:0] sample$d;
    wire signed [15:0] sample$q;
    reg  sample$clock;
    reg  [7:0] rom_address$d;
    wire  [7:0] rom_address$q;
    reg  rom_address$clock;
    reg  mark_delay$d;
    wire  mark_delay$q;
    reg  mark_delay$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    reg  access_rom$d;
    wire  access_rom$q;
    reg  access_rom$clock;
    
    // Sub module instances
    top$modulator$dds$sin_rom sin_rom(
        .address(sin_rom$address),
        .data(sin_rom$data)
    );
    top$modulator$dds$phase_accumulator phase_accumulator(
        .clock(phase_accumulator$clock),
        .ramp(phase_accumulator$ramp),
        .strobe_out(phase_accumulator$strobe_out),
        .mark(phase_accumulator$mark)
    );
    top$modulator$dds$sample sample(
        .d(sample$d),
        .q(sample$q),
        .clock(sample$clock)
    );
    top$modulator$dds$rom_address rom_address(
        .d(rom_address$d),
        .q(rom_address$q),
        .clock(rom_address$clock)
    );
    top$modulator$dds$mark_delay mark_delay(
        .d(mark_delay$d),
        .q(mark_delay$q),
        .clock(mark_delay$clock)
    );
    top$modulator$dds$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    top$modulator$dds$access_rom access_rom(
        .d(access_rom$d),
        .q(access_rom$q),
        .clock(access_rom$clock)
    );
    
    // Update code
    always @(*) begin
        phase_accumulator$clock = clock;
        rom_address$clock = clock;
        mark_delay$clock = clock;
        strobe$clock = clock;
        access_rom$clock = clock;
        sample$clock = clock;
        rom_address$d = rom_address$q;
        mark_delay$d = mark_delay$q;
        strobe$d = strobe$q;
        access_rom$d = access_rom$q;
        sample$d = sample$q;
        mark_delay$d = mark;
        phase_accumulator$mark = mark_delay$q;
        strobe_out = strobe$q;
        sin_rom$address = rom_address$q;
        data_out = sample$q;
        if (phase_accumulator$strobe_out) begin
            rom_address$d = phase_accumulator$ramp;
            access_rom$d = 1'b1;
        end
        if (access_rom$q) begin
            sample$d = sin_rom$data;
            access_rom$d = 1'b0;
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$modulator$dds


module top$modulator$dds$access_rom(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$access_rom


module top$modulator$dds$mark_delay(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$mark_delay


module top$modulator$dds$phase_accumulator(clock,ramp,strobe_out,mark);
    
    // Module arguments
    input wire  clock;
    output reg  [7:0] ramp;
    output reg  strobe_out;
    input wire  mark;
    
    // Constant declarations
    localparam  mark_tuning_word = 24'h21cac0;
    localparam  space_tuning_word = 24'h20c49b;
    
    // Stub signals
    reg  [23:0] counter$d;
    wire  [23:0] counter$q;
    reg  counter$clock;
    reg  strobe$d;
    wire  strobe$q;
    reg  strobe$clock;
    reg  downclock$enable;
    wire  downclock$strobe;
    reg  downclock$clock;
    
    // Sub module instances
    top$modulator$dds$phase_accumulator$counter counter(
        .d(counter$d),
        .q(counter$q),
        .clock(counter$clock)
    );
    top$modulator$dds$phase_accumulator$strobe strobe(
        .d(strobe$d),
        .q(strobe$q),
        .clock(strobe$clock)
    );
    top$modulator$dds$phase_accumulator$downclock downclock(
        .enable(downclock$enable),
        .strobe(downclock$strobe),
        .clock(downclock$clock)
    );
    
    // Update code
    always @(*) begin
        downclock$clock = clock;
        counter$clock = clock;
        strobe$clock = clock;
        counter$d = counter$q;
        strobe$d = strobe$q;
        downclock$enable = 1'b1;
        strobe_out = strobe$q;
        ramp = counter$q[(32'h10)+:(8)];
        if (downclock$strobe) begin
            if (mark) begin
                counter$d = counter$q + mark_tuning_word;
            end
            else begin
                counter$d = counter$q + space_tuning_word;
            end
            strobe$d = 1'b1;
        end
        else begin
            strobe$d = 1'b0;
        end
    end
    
endmodule // top$modulator$dds$phase_accumulator


module top$modulator$dds$phase_accumulator$counter(d,q,clock);
    
    // Module arguments
    input wire  [23:0] d;
    output reg  [23:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 24'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$phase_accumulator$counter


module top$modulator$dds$phase_accumulator$downclock(enable,strobe,clock);
    
    // Module arguments
    input wire  enable;
    output reg  strobe;
    input wire  clock;
    
    // Constant declarations
    localparam  threshold = 20'h14;
    
    // Stub signals
    reg  [19:0] counter$d;
    wire  [19:0] counter$q;
    reg  counter$clock;
    
    // Sub module instances
    top$modulator$dds$phase_accumulator$downclock$counter counter(
        .d(counter$d),
        .q(counter$q),
        .clock(counter$clock)
    );
    
    // Update code
    always @(*) begin
        counter$clock = clock;
        counter$d = counter$q;
        if (enable) begin
            counter$d = counter$q + 32'h1;
        end
        strobe = enable & (counter$q == threshold);
        if (strobe) begin
            counter$d = 32'h1;
        end
    end
    
endmodule // top$modulator$dds$phase_accumulator$downclock


module top$modulator$dds$phase_accumulator$downclock$counter(d,q,clock);
    
    // Module arguments
    input wire  [19:0] d;
    output reg  [19:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 20'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$phase_accumulator$downclock$counter


module top$modulator$dds$phase_accumulator$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$phase_accumulator$strobe


module top$modulator$dds$rom_address(d,q,clock);
    
    // Module arguments
    input wire  [7:0] d;
    output reg  [7:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 8'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$rom_address


module top$modulator$dds$sample(d,q,clock);
    
    // Module arguments
    input wire signed [15:0] d;
    output reg signed [15:0] q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 16'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$sample


module top$modulator$dds$sin_rom(address,data);
    
    // Module arguments
    input wire  [7:0] address;
    output reg signed [15:0] data;
    
    // Update code (custom)
    always @*
    case (address)
        8'h0: data = 16'h0;
      8'h1: data = 16'h324;
      8'h2: data = 16'h647;
      8'h3: data = 16'h96a;
      8'h4: data = 16'hc8b;
      8'h5: data = 16'hfaa;
      8'h6: data = 16'h12c7;
      8'h7: data = 16'h15e1;
      8'h8: data = 16'h18f8;
      8'h9: data = 16'h1c0a;
      8'ha: data = 16'h1f19;
      8'hb: data = 16'h2222;
      8'hc: data = 16'h2527;
      8'hd: data = 16'h2825;
      8'he: data = 16'h2b1e;
      8'hf: data = 16'h2e0f;
      8'h10: data = 16'h30fa;
      8'h11: data = 16'h33dd;
      8'h12: data = 16'h36b8;
      8'h13: data = 16'h398b;
      8'h14: data = 16'h3c55;
      8'h15: data = 16'h3f15;
      8'h16: data = 16'h41cc;
      8'h17: data = 16'h4479;
      8'h18: data = 16'h471b;
      8'h19: data = 16'h49b2;
      8'h1a: data = 16'h4c3d;
      8'h1b: data = 16'h4ebd;
      8'h1c: data = 16'h5131;
      8'h1d: data = 16'h5399;
      8'h1e: data = 16'h55f3;
      8'h1f: data = 16'h5840;
      8'h20: data = 16'h5a80;
      8'h21: data = 16'h5cb1;
      8'h22: data = 16'h5ed5;
      8'h23: data = 16'h60e9;
      8'h24: data = 16'h62ef;
      8'h25: data = 16'h64e5;
      8'h26: data = 16'h66cc;
      8'h27: data = 16'h68a3;
      8'h28: data = 16'h6a6a;
      8'h29: data = 16'h6c21;
      8'h2a: data = 16'h6dc7;
      8'h2b: data = 16'h6f5c;
      8'h2c: data = 16'h70df;
      8'h2d: data = 16'h7252;
      8'h2e: data = 16'h73b2;
      8'h2f: data = 16'h7501;
      8'h30: data = 16'h763e;
      8'h31: data = 16'h7769;
      8'h32: data = 16'h7881;
      8'h33: data = 16'h7987;
      8'h34: data = 16'h7a79;
      8'h35: data = 16'h7b59;
      8'h36: data = 16'h7c26;
      8'h37: data = 16'h7ce0;
      8'h38: data = 16'h7d87;
      8'h39: data = 16'h7e1a;
      8'h3a: data = 16'h7e9a;
      8'h3b: data = 16'h7f06;
      8'h3c: data = 16'h7f5e;
      8'h3d: data = 16'h7fa3;
      8'h3e: data = 16'h7fd5;
      8'h3f: data = 16'h7ff2;
      8'h40: data = 16'h7ffc;
      8'h41: data = 16'h7ff2;
      8'h42: data = 16'h7fd5;
      8'h43: data = 16'h7fa3;
      8'h44: data = 16'h7f5e;
      8'h45: data = 16'h7f06;
      8'h46: data = 16'h7e9a;
      8'h47: data = 16'h7e1a;
      8'h48: data = 16'h7d87;
      8'h49: data = 16'h7ce0;
      8'h4a: data = 16'h7c26;
      8'h4b: data = 16'h7b59;
      8'h4c: data = 16'h7a79;
      8'h4d: data = 16'h7987;
      8'h4e: data = 16'h7881;
      8'h4f: data = 16'h7769;
      8'h50: data = 16'h763e;
      8'h51: data = 16'h7501;
      8'h52: data = 16'h73b2;
      8'h53: data = 16'h7252;
      8'h54: data = 16'h70df;
      8'h55: data = 16'h6f5c;
      8'h56: data = 16'h6dc7;
      8'h57: data = 16'h6c21;
      8'h58: data = 16'h6a6a;
      8'h59: data = 16'h68a3;
      8'h5a: data = 16'h66cc;
      8'h5b: data = 16'h64e5;
      8'h5c: data = 16'h62ef;
      8'h5d: data = 16'h60e9;
      8'h5e: data = 16'h5ed5;
      8'h5f: data = 16'h5cb1;
      8'h60: data = 16'h5a80;
      8'h61: data = 16'h5840;
      8'h62: data = 16'h55f3;
      8'h63: data = 16'h5399;
      8'h64: data = 16'h5131;
      8'h65: data = 16'h4ebd;
      8'h66: data = 16'h4c3d;
      8'h67: data = 16'h49b2;
      8'h68: data = 16'h471b;
      8'h69: data = 16'h4479;
      8'h6a: data = 16'h41cc;
      8'h6b: data = 16'h3f15;
      8'h6c: data = 16'h3c55;
      8'h6d: data = 16'h398b;
      8'h6e: data = 16'h36b8;
      8'h6f: data = 16'h33dd;
      8'h70: data = 16'h30fa;
      8'h71: data = 16'h2e0f;
      8'h72: data = 16'h2b1e;
      8'h73: data = 16'h2825;
      8'h74: data = 16'h2527;
      8'h75: data = 16'h2222;
      8'h76: data = 16'h1f19;
      8'h77: data = 16'h1c0a;
      8'h78: data = 16'h18f8;
      8'h79: data = 16'h15e1;
      8'h7a: data = 16'h12c7;
      8'h7b: data = 16'hfaa;
      8'h7c: data = 16'hc8b;
      8'h7d: data = 16'h96a;
      8'h7e: data = 16'h647;
      8'h7f: data = 16'h324;
      8'h80: data = 16'h0;
      8'h81: data = 16'hfcdc;
      8'h82: data = 16'hf9b9;
      8'h83: data = 16'hf696;
      8'h84: data = 16'hf375;
      8'h85: data = 16'hf056;
      8'h86: data = 16'hed39;
      8'h87: data = 16'hea1f;
      8'h88: data = 16'he708;
      8'h89: data = 16'he3f6;
      8'h8a: data = 16'he0e7;
      8'h8b: data = 16'hddde;
      8'h8c: data = 16'hdad9;
      8'h8d: data = 16'hd7db;
      8'h8e: data = 16'hd4e2;
      8'h8f: data = 16'hd1f1;
      8'h90: data = 16'hcf06;
      8'h91: data = 16'hcc23;
      8'h92: data = 16'hc948;
      8'h93: data = 16'hc675;
      8'h94: data = 16'hc3ab;
      8'h95: data = 16'hc0eb;
      8'h96: data = 16'hbe34;
      8'h97: data = 16'hbb87;
      8'h98: data = 16'hb8e5;
      8'h99: data = 16'hb64e;
      8'h9a: data = 16'hb3c3;
      8'h9b: data = 16'hb143;
      8'h9c: data = 16'haecf;
      8'h9d: data = 16'hac67;
      8'h9e: data = 16'haa0d;
      8'h9f: data = 16'ha7c0;
      8'ha0: data = 16'ha580;
      8'ha1: data = 16'ha34f;
      8'ha2: data = 16'ha12b;
      8'ha3: data = 16'h9f17;
      8'ha4: data = 16'h9d11;
      8'ha5: data = 16'h9b1b;
      8'ha6: data = 16'h9934;
      8'ha7: data = 16'h975d;
      8'ha8: data = 16'h9596;
      8'ha9: data = 16'h93df;
      8'haa: data = 16'h9239;
      8'hab: data = 16'h90a4;
      8'hac: data = 16'h8f21;
      8'had: data = 16'h8dae;
      8'hae: data = 16'h8c4e;
      8'haf: data = 16'h8aff;
      8'hb0: data = 16'h89c2;
      8'hb1: data = 16'h8897;
      8'hb2: data = 16'h877f;
      8'hb3: data = 16'h8679;
      8'hb4: data = 16'h8587;
      8'hb5: data = 16'h84a7;
      8'hb6: data = 16'h83da;
      8'hb7: data = 16'h8320;
      8'hb8: data = 16'h8279;
      8'hb9: data = 16'h81e6;
      8'hba: data = 16'h8166;
      8'hbb: data = 16'h80fa;
      8'hbc: data = 16'h80a2;
      8'hbd: data = 16'h805d;
      8'hbe: data = 16'h802b;
      8'hbf: data = 16'h800e;
      8'hc0: data = 16'h8004;
      8'hc1: data = 16'h800e;
      8'hc2: data = 16'h802b;
      8'hc3: data = 16'h805d;
      8'hc4: data = 16'h80a2;
      8'hc5: data = 16'h80fa;
      8'hc6: data = 16'h8166;
      8'hc7: data = 16'h81e6;
      8'hc8: data = 16'h8279;
      8'hc9: data = 16'h8320;
      8'hca: data = 16'h83da;
      8'hcb: data = 16'h84a7;
      8'hcc: data = 16'h8587;
      8'hcd: data = 16'h8679;
      8'hce: data = 16'h877f;
      8'hcf: data = 16'h8897;
      8'hd0: data = 16'h89c2;
      8'hd1: data = 16'h8aff;
      8'hd2: data = 16'h8c4e;
      8'hd3: data = 16'h8dae;
      8'hd4: data = 16'h8f21;
      8'hd5: data = 16'h90a4;
      8'hd6: data = 16'h9239;
      8'hd7: data = 16'h93df;
      8'hd8: data = 16'h9596;
      8'hd9: data = 16'h975d;
      8'hda: data = 16'h9934;
      8'hdb: data = 16'h9b1b;
      8'hdc: data = 16'h9d11;
      8'hdd: data = 16'h9f17;
      8'hde: data = 16'ha12b;
      8'hdf: data = 16'ha34f;
      8'he0: data = 16'ha580;
      8'he1: data = 16'ha7c0;
      8'he2: data = 16'haa0d;
      8'he3: data = 16'hac67;
      8'he4: data = 16'haecf;
      8'he5: data = 16'hb143;
      8'he6: data = 16'hb3c3;
      8'he7: data = 16'hb64e;
      8'he8: data = 16'hb8e5;
      8'he9: data = 16'hbb87;
      8'hea: data = 16'hbe34;
      8'heb: data = 16'hc0eb;
      8'hec: data = 16'hc3ab;
      8'hed: data = 16'hc675;
      8'hee: data = 16'hc948;
      8'hef: data = 16'hcc23;
      8'hf0: data = 16'hcf06;
      8'hf1: data = 16'hd1f1;
      8'hf2: data = 16'hd4e2;
      8'hf3: data = 16'hd7db;
      8'hf4: data = 16'hdad9;
      8'hf5: data = 16'hddde;
      8'hf6: data = 16'he0e7;
      8'hf7: data = 16'he3f6;
      8'hf8: data = 16'he708;
      8'hf9: data = 16'hea1f;
      8'hfa: data = 16'hed39;
      8'hfb: data = 16'hf056;
      8'hfc: data = 16'hf375;
      8'hfd: data = 16'hf696;
      8'hfe: data = 16'hf9b9;
      8'hff: data = 16'hfcdc;
      default: data = 16'h0;
    endcase
            
endmodule // top$modulator$dds$sin_rom


module top$modulator$dds$strobe(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$dds$strobe


module top$modulator$mark(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$modulator$mark


module top$rx_buffer(sig_in,sig_out,clock);
    
    // Module arguments
    input wire  sig_in;
    output reg  sig_out;
    input wire  clock;
    
    // Stub signals
    reg  dff0$d;
    wire  dff0$q;
    reg  dff0$clock;
    reg  dff1$d;
    wire  dff1$q;
    reg  dff1$clock;
    
    // Sub module instances
    top$rx_buffer$dff0 dff0(
        .d(dff0$d),
        .q(dff0$q),
        .clock(dff0$clock)
    );
    top$rx_buffer$dff1 dff1(
        .d(dff1$d),
        .q(dff1$q),
        .clock(dff1$clock)
    );
    
    // Update code
    always @(*) begin
        dff0$clock = clock;
        dff1$clock = clock;
        dff0$d = dff0$q;
        dff1$d = dff1$q;
        dff0$d = sig_in;
        dff1$d = dff0$q;
        sig_out = dff1$q;
    end
    
endmodule // top$rx_buffer


module top$rx_buffer$dff0(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$rx_buffer$dff0


module top$rx_buffer$dff1(d,q,clock);
    
    // Module arguments
    input wire  d;
    output reg  q;
    input wire  clock;
    
    // Update code (custom)
    initial begin
       q = 1'h0;
    end
    
    always @(posedge clock) begin
       q <= d;
    end
          
endmodule // top$rx_buffer$dff1
