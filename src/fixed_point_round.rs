use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct FixedPointRound<const N: usize> {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<N>>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub strobe_out: Signal<Out, Bit>,
    data: DFF<Signed<N>>,
    strobe: DFF<Bit>,
    truncated: Signal<Local, Signed<16>>,
}

impl<const N: usize> Logic for FixedPointRound<N> {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, data, strobe);

        self.strobe_out.next = self.strobe.q.val();

        if self.strobe_in.val() {
            self.data.d.next = self.data_in.val();
            self.strobe.d.next = true;
        }

        if self.strobe.q.val() {
            self.strobe.d.next = false;
        }

        // Drop second sign bit and round
        self.truncated.next = self.data.q.val().get_bits::<16>(16);

        if self.data.q.val().get_bit(14) {
            // Round up
            self.data_out.next = self.truncated.val() + 1.into();
        } else {
            self.data_out.next = self.truncated.val();
        }
    }
}

impl<const N: usize> Default for FixedPointRound<N> {
    fn default() -> Self {
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            data_out: Signal::default(),
            strobe_in: Signal::default(),
            strobe_out: Signal::default(),
            data: DFF::default(),
            strobe: DFF::default(),
            truncated: Signal::default(),
        }
    }
}
