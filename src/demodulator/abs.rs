use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct Abs {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_out: Signal<Out, Bit>,
    max: Constant<Signed<16>>,
    one: Constant<Signed<16>>,
    zero: Constant<Signed<16>>,
    data: DFF<Signed<16>>,
    strobe: DFF<Bit>,
}

impl Logic for Abs {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, data, strobe);

        self.strobe_out.next = self.strobe.q.val();

        self.strobe.d.next = false;
        if self.strobe_in.val() {
            self.data.d.next = self.data_in.val();
            self.strobe.d.next = true;
        }

        if self.data.q.val() >= self.zero.val() {
            self.data_out.next = self.data.q.val();
        } else {
            self.data_out.next = self.max.val() - self.data.q.val() + self.one.val();
        }
    }
}

impl Default for Abs {
    fn default() -> Self {
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            strobe_in: Signal::default(),
            data_out: Signal::default(),
            strobe_out: Signal::default(),
            max: Constant::new(0xffff_i64.into()),
            one: Constant::new(1_i64.into()),
            zero: Constant::new(0_i64.into()),
            data: DFF::default(),
            strobe: DFF::default(),
        }
    }
}
