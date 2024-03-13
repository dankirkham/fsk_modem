mod phase_accumulator;
mod sin_rom;

use rust_hdl::prelude::*;

use self::phase_accumulator::PhaseAccumulator24_8;
use self::sin_rom::*;

#[derive(LogicBlock)]
pub struct DDS24_8 {
    pub clock: Signal<In, Clock>,
    pub data_out: Signal<Out, Signed<16>>,
    pub mark: Signal<In, Bit>,
    pub strobe_out: Signal<Out, Bit>,
    sin_rom: ROM<Signed<16>, 5>,
    phase_accumulator: PhaseAccumulator24_8,
    sample: DFF<Signed<16>>,
    rom_address: DFF<Bits<5>>,
    mark_delay: DFF<Bit>,
    strobe: DFF<Bit>,
    access_rom: DFF<Bit>,
}

impl Logic for DDS24_8 {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, phase_accumulator);
        dff_setup!(
            self,
            clock,
            rom_address,
            mark_delay,
            strobe,
            access_rom,
            sample
        );
        self.mark_delay.d.next = self.mark.val();
        self.phase_accumulator.mark.next = self.mark_delay.q.val();
        self.strobe_out.next = self.strobe.q.val();
        self.sin_rom.address.next = self.rom_address.q.val();
        self.data_out.next = self.sample.q.val();

        if self.phase_accumulator.strobe_out.val() {
            self.rom_address.d.next = self.phase_accumulator.ramp.val();
            self.access_rom.d.next = true;
        }

        if self.access_rom.q.val() {
            self.sample.d.next = self.sin_rom.data.val();
            self.access_rom.d.next = false;
            self.strobe.d.next = true;
        } else {
            self.strobe.d.next = false;
        }
    }
}

impl DDS24_8 {
    pub fn new(mark_tuning_word: u64, space_tuning_word: u64) -> Self {
        let sin_rom = make_sin_rom::<5>();
        Self {
            clock: Signal::default(),
            data_out: Signal::default(),
            mark: Signal::default(),
            strobe_out: Signal::default(),
            sin_rom,
            phase_accumulator: PhaseAccumulator24_8::new(mark_tuning_word, space_tuning_word),
            rom_address: DFF::default(),
            mark_delay: DFF::default(),
            strobe: DFF::default(),
            access_rom: DFF::default(),
            sample: DFF::default(),
        }
    }
}
