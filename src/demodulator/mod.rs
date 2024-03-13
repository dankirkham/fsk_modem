mod decimator;

use std::time::Duration;

use rust_hdl::prelude::*;

use crate::bsp::pins;
use crate::fir::FIR;
use crate::mixer::Mixer;

use self::decimator::Decimator;

#[derive(LogicBlock)]
pub struct Demodulator {
    pub clock: Signal<In, Clock>,
    pub signal_in: Signal<In, Bits<16>>,
    pub mark_out: Signal<Out, Bit>,
    lo: Pulser,
    decimator: Decimator<7>,
    mixer: Mixer,
    fir: FIR<4>,
}

impl Logic for Demodulator {
    #[hdl_gen]
    fn update(&mut self) {
        // dff_setup!(self, clock);
        clock!(self, clock, decimator, lo, fir);

        self.lo.enable.next = true;

        self.mixer.signal_in_1.next = self.signal_in.val();
        self.mixer.signal_in_2.next = self.lo.pulse.val();

        self.fir.signal_in.next = self.mixer.signal_out.val();
        self.decimator.signal_in.next = self.fir.signal_out.val();

        self.mark_out.next = self.decimator.signal_out.val().get_bit(15);
    }
}

impl Default for Demodulator {
    fn default() -> Self {
        Self {
            clock: Signal::default(),
            signal_in: Signal::default(),
            mark_out: Signal::default(),
            decimator: Decimator::new(79),
            lo: Pulser::new(
                pins::CLOCK_SPEED_48MHZ,
                299_000.0,
                Duration::from_nanos(1_000_000_000 / 299_000 / 2),
            ),
            mixer: Mixer::default(),
            // fir: FIR::new([1164, 3492, 6111, 7274, 6111, 3492, 1164]),
            // fir: FIR::new([
            //     -256, -223, -223, -115, 141, 570, 1168, 1896, 2688, 3452, 4090, 4514, 4662, 4514,
            //     4090, 3452, 2688, 1896, 1168, 570, 141, -115, -223, -223, -256,
            // ]),
            fir: FIR::new([0x2000, 0x2000, 0x2000, 0x2000]),
        }
    }
}
