use std::time::Duration;

use rust_hdl::prelude::*;

use crate::bsp::pins;
use crate::dds::DDS24_8;
use crate::demodulator::Demodulator;

#[derive(LogicBlock)]
pub struct Modem {
    pub clock: Signal<In, Clock>,
    pub user_pins: Signal<Out, Bits<4>>,
    user_pins_w: Signal<Local, Bits<4>>,
    symbol_driver: Pulser,
    dds: DDS24_8,
    demodulator: Demodulator,
    delay: DFF<Bits<16>>,
}

impl Logic for Modem {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, dds, symbol_driver, demodulator);
        dff_setup!(self, clock, delay);
        self.user_pins_w.next = 0.into();
        self.user_pins.next = self
            .user_pins_w
            .val()
            .replace_bit(0, self.demodulator.mark_out.val());
        self.symbol_driver.enable.next = true;
        self.dds.mark.next = self.symbol_driver.pulse.val();
        self.delay.d.next = self.dds.signal.val();
        self.demodulator.signal_in.next = self.delay.q.val();
    }
}

impl Default for Modem {
    fn default() -> Self {
        Self {
            clock: pins::clock(),
            user_pins: pins::user_pins(),
            user_pins_w: Signal::default(),
            symbol_driver: Pulser::new(
                pins::CLOCK_SPEED_48MHZ,
                115_200. / 2.,
                Duration::from_nanos(1_000_000_000 / 115_200),
            ),
            dds: DDS24_8::new(105_207, 2 * 104_858),
            demodulator: Demodulator::default(),
            delay: DFF::default(),
        }
    }
}
