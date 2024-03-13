use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct Decimator<const N: usize> {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_out: Signal<Out, Bit>,
    decimation_factor: Constant<Bits<N>>,
    counter: DFF<Bits<N>>,
    hold_out: DFF<Signed<16>>,
    strobe: DFF<Bit>,
}

impl<const N: usize> Logic for Decimator<N> {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, counter, hold_out, strobe);

        self.data_out.next = self.hold_out.q.val();
        self.strobe_out.next = self.strobe.q.val();

        self.strobe.d.next = false;
        if self.strobe_in.val() {
            if self.counter.q.val() == self.decimation_factor.val() - 1 {
                self.counter.d.next = 0.into();
                self.hold_out.d.next = self.data_in.val();
                self.strobe.d.next = true;
            } else {
                self.counter.d.next = self.counter.q.val() + 1;
            }
        }
    }
}

impl<const N: usize> Decimator<N> {
    pub fn new(factor: u64) -> Self {
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            strobe_in: Signal::default(),
            data_out: Signal::default(),
            strobe_out: Signal::default(),
            decimation_factor: Constant::new(factor.into()),
            counter: DFF::default(),
            hold_out: DFF::default(),
            strobe: DFF::default(),
        }
    }
}
