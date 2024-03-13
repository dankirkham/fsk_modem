use rust_hdl::prelude::*;

use crate::bsp::pins;

#[derive(LogicBlock)]
pub struct PhaseAccumulator24_8 {
    pub clock: Signal<In, Clock>,
    pub ramp: Signal<Out, Bits<5>>,
    pub strobe_out: Signal<Out, Bit>,
    pub mark: Signal<In, Bit>,
    counter: DFF<Bits<24>>,
    strobe: DFF<Bit>,
    mark_tuning_word: Constant<Bits<24>>,
    space_tuning_word: Constant<Bits<24>>,
    downclock: Strobe<20>,
}

impl Logic for PhaseAccumulator24_8 {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, downclock);
        dff_setup!(self, clock, counter, strobe);
        self.downclock.enable.next = true;
        self.strobe_out.next = self.strobe.q.val();
        self.ramp.next = self.counter.q.val().get_bits::<5>(19);

        if self.downclock.strobe.val() {
            if self.mark.val() {
                self.counter.d.next = self.counter.q.val() + self.mark_tuning_word.val();
            } else {
                self.counter.d.next = self.counter.q.val() + self.space_tuning_word.val();
            }
            self.strobe.d.next = true;
        } else {
            self.strobe.d.next = false;
        }
    }
}

impl PhaseAccumulator24_8 {
    pub fn new(mark_tuning_word: u64, space_tuning_word: u64) -> Self {
        Self {
            clock: Signal::default(),
            ramp: Signal::default(),
            mark: Signal::default(),
            strobe_out: Signal::default(),
            counter: DFF::default(),
            strobe: DFF::default(),
            mark_tuning_word: Constant::new(mark_tuning_word.into()),
            space_tuning_word: Constant::new(space_tuning_word.into()),
            downclock: Strobe::new(pins::CLOCK_SPEED_48MHZ, 2_400_000.),
        }
    }
}
