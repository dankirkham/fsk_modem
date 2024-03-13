use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct Mixer {
    pub signal_in_1: Signal<In, Bits<16>>,
    pub signal_in_2: Signal<In, Bit>,
    pub signal_out: Signal<Out, Bits<16>>,
}

impl Logic for Mixer {
    #[hdl_gen]
    fn update(&mut self) {
        if self.signal_in_2.val() {
            self.signal_out.next = self.signal_in_1.val();
        } else {
            self.signal_out.next = !self.signal_in_1.val() + 1;
        }
    }
}

impl Default for Mixer {
    fn default() -> Self {
        Self {
            signal_in_1: Signal::default(),
            signal_in_2: Signal::default(),
            signal_out: Signal::default(),
        }
    }
}
