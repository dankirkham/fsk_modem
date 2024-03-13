mod phase_accumulator;
mod sin_rom;

use rust_hdl::prelude::*;

use self::phase_accumulator::PhaseAccumulator24_8;
use self::sin_rom::*;

#[derive(LogicBlock)]
pub struct DDS24_8 {
    pub clock: Signal<In, Clock>,
    pub signal: Signal<Out, Bits<16>>,
    pub mark: Signal<In, Bit>,
    sin_rom: ROM<Bits<16>, 8>,
    phase_accumulator: PhaseAccumulator24_8,
    delay: DFF<Bits<8>>,
    mark_delay: DFF<Bit>,
}

impl Logic for DDS24_8 {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, phase_accumulator);
        dff_setup!(self, clock, delay, mark_delay);
        self.mark_delay.d.next = self.mark.val();
        self.phase_accumulator.mark.next = self.mark_delay.q.val();

        self.delay.d.next = self.phase_accumulator.ramp.val();
        self.sin_rom.address.next = self.delay.q.val();

        self.signal.next = self.sin_rom.data.val();
    }
}

impl DDS24_8 {
    pub fn new(mark_tuning_word: u64, space_tuning_word: u64) -> Self {
        let sin_rom = make_sin_rom::<8>();
        Self {
            clock: Signal::default(),
            signal: Signal::default(),
            mark: Signal::default(),
            sin_rom,
            phase_accumulator: PhaseAccumulator24_8::new(mark_tuning_word, space_tuning_word),
            delay: DFF::default(),
            mark_delay: DFF::default(),
        }
    }
}
