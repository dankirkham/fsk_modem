use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct PhaseAccumulator24_8 {
    pub clock: Signal<In, Clock>,
    pub ramp: Signal<Out, Bits<8>>,
    pub mark: Signal<In, Bit>,
    counter: DFF<Bits<24>>,
    mark_tuning_word: Constant<Bits<24>>,
    space_tuning_word: Constant<Bits<24>>,
}

impl Logic for PhaseAccumulator24_8 {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, counter);
        if self.mark.val() {
            self.counter.d.next = self.counter.q.val() + self.mark_tuning_word.val();
        } else {
            self.counter.d.next = self.counter.q.val() + self.space_tuning_word.val();
        }
        self.ramp.next = self.counter.q.val().get_bits::<8>(16);
    }
}

impl PhaseAccumulator24_8 {
    pub fn new(mark_tuning_word: u64, space_tuning_word: u64) -> Self {
        Self {
            clock: Signal::default(),
            ramp: Signal::default(),
            mark: Signal::default(),
            counter: DFF::default(),
            mark_tuning_word: Constant::new(mark_tuning_word.into()),
            space_tuning_word: Constant::new(space_tuning_word.into()),
        }
    }
}
