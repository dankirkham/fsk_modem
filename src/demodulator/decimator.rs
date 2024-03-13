use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct Decimator<const N: usize> {
    pub clock: Signal<In, Clock>,
    pub signal_in: Signal<In, Bits<16>>,
    pub signal_out: Signal<Out, Bits<16>>,
    decimation_factor: Constant<Bits<N>>,
    counter: DFF<Bits<N>>,
    signal_hold: DFF<Bits<16>>,
}

impl<const N: usize> Logic for Decimator<N> {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, counter, signal_hold);

        self.signal_out.next = self.signal_hold.q.val();
        if self.counter.q.val() == 0 {
            self.counter.d.next = self.decimation_factor.val();
            self.signal_hold.d.next = self.signal_in.val();
        } else {
            self.counter.d.next = self.counter.q.val() - 1;
        }
    }
}

impl<const N: usize> Decimator<N> {
    pub fn new(factor: u64) -> Self {
        Self {
            clock: Signal::default(),
            signal_in: Signal::default(),
            signal_out: Signal::default(),
            decimation_factor: Constant::new(factor.into()),
            counter: DFF::default(),
            signal_hold: DFF::default(),
        }
    }
}
