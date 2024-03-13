use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct MAC {
    pub clock: Signal<In, Clock>,
    pub a: Signal<In, Bits<16>>,
    pub b: Signal<In, Bits<16>>,
    pub c: Signal<In, Bits<32>>,
    pub prod: Signal<Out, Bits<32>>,
}

impl Logic for MAC {
    fn update(&mut self) {
        self.prod.next = (self.a.val() * self.b.val()) + self.c.val();
    }

    fn connect(&mut self) {
        self.prod.connect();
    }

    fn hdl(&self) -> Verilog {
        Verilog::Wrapper(Wrapper {
            code: r#"
SB_MAC16 #(
        .TOPOUTPUT_SELECT(2'b00), // adder, unregistered
        .TOPADDSUB_LOWERINPUT(2'b10), // multiplier hi bits
        .TOPADDSUB_UPPERINPUT(1'b1), // input C
        .TOPADDSUB_CARRYSELECT(2'b11), // top carry in is bottom carry out
        .BOTOUTPUT_SELECT(2'b00), // adder, unregistered
        .BOTADDSUB_LOWERINPUT(2'b10), // multiplier lo bits
        .BOTADDSUB_UPPERINPUT(1'b1), // input D
        .BOTADDSUB_CARRYSELECT(2'b00) // bottom carry in constant 0
) mac_inst (
        .CLK(clock),
        .A(a),
        .B(b),
        .C(c[31:16]),
        .D(c[15:0]),
        .O(prod[31:0]),
        .CO()
);
"#
            .into(),
            cores: "".into(),
        })
    }
}

impl Default for MAC {
    fn default() -> Self {
        Self {
            clock: Signal::default(),
            a: Signal::default(),
            b: Signal::default(),
            c: Signal::default(),
            prod: Signal::default(),
        }
    }
}
