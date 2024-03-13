use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct Buffer {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_out: Signal<Out, Bit>,
    data: DFF<Signed<16>>,
    strobe: DFF<Bit>,
}

impl Logic for Buffer {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, data, strobe);

        self.strobe_out.next = self.strobe.q.val();
        self.data_out.next = self.data.q.val();

        if self.strobe_in.val() {
            self.data.d.next = self.data_in.val();
            self.strobe.d.next = true;
        } else {
            self.strobe.d.next = false;
        }
    }
}

impl Default for Buffer {
    fn default() -> Self {
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            strobe_in: Signal::default(),
            data_out: Signal::default(),
            strobe_out: Signal::default(),
            data: DFF::default(),
            strobe: DFF::default(),
        }
    }
}
